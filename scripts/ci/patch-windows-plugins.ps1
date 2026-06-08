param(
  [string]$AppDir = ""
)

$ErrorActionPreference = "Stop"

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
  if ($_.Name -eq "printing" -and $env:PDFIUM_TGZ_PATH -and $content -notmatch 'PDFIUM_TGZ_PATH') {
    $content = $content -replace '(?m)^# Download pdfium\r?\n', @'
# Use CI-prefetched pdfium archive when available (avoids flaky GitHub 504s in cmake).
if(DEFINED ENV{PDFIUM_TGZ_PATH} AND NOT "$ENV{PDFIUM_TGZ_PATH}" STREQUAL "")
  file(TO_CMAKE_PATH "$ENV{PDFIUM_TGZ_PATH}" _pdfium_tgz)
  string(REPLACE "\\" "/" _pdfium_tgz "${_pdfium_tgz}")
  set(PDFIUM_URL "file:///${_pdfium_tgz}")
endif()

# Download pdfium
'@
  }

  if ($content -ne $original) {
    Set-Content -Path $pluginCmake -Value $content -NoNewline
    $reasons = @()
    if ($original -match '(?m)^\s*DEPENDS \$\{NUGET\}') { $reasons += "removed invalid DEPENDS" }
    if ($_.Name -eq "ditto_live" -and $content -match 'string\(REPLACE "\\\\" "/" DITTOFFI_LIB_PATH') {
      $reasons += "normalized dittoffi path slashes"
    }
    if ($_.Name -eq "printing" -and $content -match 'PDFIUM_TGZ_PATH') {
      $reasons += "use prefetched pdfium archive"
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
