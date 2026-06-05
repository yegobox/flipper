param(
  [string]$AppDir = "apps/flipper"
)

$ErrorActionPreference = "Stop"

$pluginCmake = Join-Path $AppDir "windows/flutter/ephemeral/.plugin_symlinks/desktop_webview_auth/windows/CMakeLists.txt"
if (-not (Test-Path $pluginCmake)) {
  Write-Host "desktop_webview_auth CMakeLists not found at $pluginCmake; skipping patch"
  exit 0
}

$content = Get-Content -Path $pluginCmake -Raw
$original = $content

# CMP0175: DEPENDS is invalid on add_custom_command(TARGET ...).
$content = $content -replace '(?m)^\s*DEPENDS \$\{NUGET\}\s*\r?\n', ''

if ($content -ne $original) {
  Set-Content -Path $pluginCmake -Value $content -NoNewline
  Write-Host "Patched desktop_webview_auth windows/CMakeLists.txt (removed invalid DEPENDS)"
} else {
  Write-Host "desktop_webview_auth windows/CMakeLists.txt already patched or unchanged"
}
