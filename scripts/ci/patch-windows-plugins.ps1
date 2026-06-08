param(
  [string]$AppDir = ""
)

$ErrorActionPreference = "Stop"

function Write-Utf8NoBom {
  param(
    [string]$Path,
    [string]$Text
  )

  $utf8 = New-Object System.Text.UTF8Encoding $false
  [System.IO.File]::WriteAllText($Path, $Text, $utf8)
}

if (-not $AppDir) {
  if ($env:GITHUB_WORKSPACE) {
    $AppDir = Join-Path $env:GITHUB_WORKSPACE "apps/flipper"
  } else {
    $repoRoot = Resolve-Path (Join-Path $PSScriptRoot "../..")
    $AppDir = Join-Path $repoRoot "apps/flipper"
  }
}

$AppDir = (Resolve-Path $AppDir).Path
$symlinksDir = Join-Path $AppDir "windows/flutter/ephemeral/.plugin_symlinks"

if (-not (Test-Path $symlinksDir)) {
  throw "Plugin symlinks not found at $symlinksDir. Run 'flutter pub get' in apps/flipper first."
}

$printingDownloadBlock = '(?ms)(?:# Use CI-prefetched pdfium archive[^\r\n]*\r?\nif\(DEFINED ENV\{PDFIUM_TGZ_PATH\}.*?endif\(\)\r?\n\r?\n)?# Download pdfium\r?\ninclude\(\.\./windows/DownloadProject\.cmake\)\r?\ndownload_project\(PROJ\r?\n\s+pdfium\r?\n\s+URL\r?\n\s+\$\{PDFIUM_URL\}\)\r?\n'

$printingDownloadReplacement = @'
# Prefetched pdfium for CI (see scripts/ci/prefetch-pdfium.ps1)
if(DEFINED ENV{PDFIUM_SOURCE_DIR} AND NOT "$ENV{PDFIUM_SOURCE_DIR}" STREQUAL "")
  file(TO_CMAKE_PATH "$ENV{PDFIUM_SOURCE_DIR}" pdfium_SOURCE_DIR)
  string(REPLACE "\\" "/" pdfium_SOURCE_DIR "${pdfium_SOURCE_DIR}")
  if(NOT EXISTS "${pdfium_SOURCE_DIR}/PDFiumConfig.cmake")
    message(FATAL_ERROR "Prefetched pdfium not found at ${pdfium_SOURCE_DIR}")
  endif()
else()
  include(../windows/DownloadProject.cmake)
  download_project(PROJ
                   pdfium
                   URL
                   ${PDFIUM_URL})
endif()

'@

$patched = 0
Get-ChildItem -Path $symlinksDir -Directory | ForEach-Object {
  $pluginCmake = Join-Path $_.FullName "windows/CMakeLists.txt"
  if (-not (Test-Path $pluginCmake)) {
    return
  }

  $content = Get-Content -Path $pluginCmake -Raw
  $original = $content

  # CMP0175: DEPENDS is invalid on add_custom_command(TARGET ...).
  $content = $content -replace '(?m)^\s*DEPENDS \$\{NUGET\}\s*\r?\n', ''

  # dittoffi bundled path is embedded in cmake_install.cmake; backslashes are escapes (D:\a\...).
  if ($_.Name -eq "ditto_live" -and $content -notmatch 'string\(REPLACE "\\\\" "/" DITTOFFI_LIB_PATH') {
    $content = $content -replace '(?m)^set\(ditto_live_bundled_libraries\r?\n', @'
# CMake install() embeds literal paths; normalize so D:/a/... does not parse \a as escape.
string(REPLACE "\\" "/" DITTOFFI_LIB_PATH "${DITTOFFI_LIB_PATH}")
set(ditto_live_bundled_libraries
'@
  }

  # printing downloads pdfium from GitHub during cmake configure; use CI prefetch instead.
  if ($_.Name -eq "printing" -and $env:PDFIUM_SOURCE_DIR -and $content -notmatch 'Prefetched pdfium for CI') {
    if ($content -notmatch $printingDownloadBlock) {
      throw "printing/windows/CMakeLists.txt did not match expected pdfium download block"
    }
    $content = $content -replace $printingDownloadBlock, $printingDownloadReplacement
  }

  if ($content -ne $original) {
    Write-Utf8NoBom -Path $pluginCmake -Text $content
    $reasons = @()
    if ($original -match '(?m)^\s*DEPENDS \$\{NUGET\}') { $reasons += "removed invalid DEPENDS" }
    if ($_.Name -eq "ditto_live" -and $content -match 'string\(REPLACE "\\\\" "/" DITTOFFI_LIB_PATH') {
      $reasons += "normalized dittoffi path slashes"
    }
    if ($_.Name -eq "printing" -and $content -match 'Prefetched pdfium for CI') {
      $reasons += "use prefetched pdfium source"
    }
    $summary = if ($reasons.Count -gt 0) { ($reasons -join "; ") } else { "updated" }
    Write-Host "Patched $($_.Name)/windows/CMakeLists.txt ($summary)"
    $patched++
  }
}

if ($patched -eq 0) {
  Write-Host "No Windows plugin CMakeLists required patching under $symlinksDir"
} else {
  Write-Host "Patched $patched Windows plugin CMakeLists file(s)"
}
