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

  if ($_.Name -eq 'flutter_soloud') {
    # Parent APPLY_STANDARD_SETTINGS uses /W4; soloud third-party sources fail on VS 2026.
    $content = $content -replace '(?m)^apply_standard_settings\(\$\{PLUGIN_NAME\}\)\s*\r?\n', "# apply_standard_settings skipped (VS 2026 CI)`n"

    # copy_pdbs runs on every build and fails when PDB is missing (copy_if_different error).
    $content = $content -replace '(?ms)\r?\n\s*# Create a custom target for copying PDB files.*?VERBATIM\s*\)\s*\r?\n', "`n"

    # /GL + /LTCG are fragile on GitHub VS 2026 runners.
    $content = $content -replace '(?m)^\s*/GL\s*# Whole program optimization\s*\r?\n', ''
    $content = $content -replace '(?m)^\s*set\(CMAKE_EXE_LINKER_FLAGS "\$\{CMAKE_EXE_LINKER_FLAGS\} /LTCG /OPT:REF /OPT:ICF"\)\s*\r?\n', ''
    $content = $content -replace '(?m)^\s*set\(CMAKE_SHARED_LINKER_FLAGS "\$\{CMAKE_SHARED_LINKER_FLAGS\} /LTCG /OPT:REF /OPT:ICF"\)\s*\r?\n', ''

    # Downgrade plugin warning level; app CMakeLists.txt also forces /W0 /WX- on this target.
    $content = $content -replace '/W4\s*# Warning level 4', '/W0 # Warning level disabled for CI'
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
