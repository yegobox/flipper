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

  # flutter_soloud: skip parent /W4 apply_standard_settings; app CMakeLists sets /W0 /WX-.
  if ($_.Name -eq 'flutter_soloud') {
    $content = $content -replace '(?m)^apply_standard_settings\(\$\{PLUGIN_NAME\}\)\s*\r?\n', "# apply_standard_settings skipped (VS 2026 third-party soloud warnings)`n"
  }

  if ($content -ne $original) {
    Set-Content -Path $pluginCmake -Value $content -NoNewline
    Write-Host "Patched $($_.Name)/windows/CMakeLists.txt"
    $patched++
  }
}

if ($patched -eq 0) {
  Write-Host "No Windows plugin CMakeLists required patching under $symlinksDir"
} else {
  Write-Host "Patched $patched Windows plugin CMakeLists file(s)"
}
