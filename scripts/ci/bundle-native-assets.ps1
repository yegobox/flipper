# Copies Dart native-asset DLLs into the Windows Release runner bundle.
#
# Why this exists:
#   Packages like turso_dart, flutter_gemma_litertlm and flutter_gemma_rag_qdrant
#   ship their native libraries as Dart "native assets" (hook/build.dart). On
#   Windows, `flutter build windows` compiles them into
#   build/native_assets/windows/ and writes a NativeAssetsManifest.json that
#   references each DLL by bare name ("absolute" link mode = load next to the
#   .exe at runtime) -- but it does NOT reliably copy those DLLs into the
#   runner Release folder. msix:create then packages the manifest WITHOUT the
#   binaries, so the Store build boots, reads the manifest, fails to load
#   turso_dart_native.dll, and dies with "Initialization Failed".
#
#   This script copies every DLL the manifest declares into the Release root and
#   FAILS the build if any declared DLL cannot be found. Run it after
#   `flutter build windows` and before `dart run msix:create --build-windows false`.

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

$releaseDir     = Join-Path $AppDir "build/windows/x64/runner/Release"
$nativeAssetsDir = Join-Path $AppDir "build/native_assets/windows"
$manifestPath   = Join-Path $releaseDir "data/flutter_assets/NativeAssetsManifest.json"

if (-not (Test-Path $releaseDir)) {
  throw "Release dir not found at $releaseDir. Run 'flutter build windows' first."
}

if (-not (Test-Path $manifestPath)) {
  # No native assets in this build -> nothing to do.
  Write-Host "No NativeAssetsManifest.json at $manifestPath; skipping native-asset bundling."
  exit 0
}

$manifest = Get-Content -Path $manifestPath -Raw | ConvertFrom-Json
$windowsAssets = $manifest.'native-assets'.'windows_x64'
if (-not $windowsAssets) {
  Write-Host "Manifest declares no windows_x64 native assets; nothing to bundle."
  exit 0
}

# Collect the bare DLL filename each asset resolves to (2nd element of the
# ["absolute","<file>"] / ["relative","<file>"] tuple).
$expected = New-Object System.Collections.Generic.HashSet[string]
foreach ($prop in $windowsAssets.PSObject.Properties) {
  $tuple = $prop.Value
  if ($tuple.Count -ge 2) {
    $file = [System.IO.Path]::GetFileName([string]$tuple[1])
    if ($file) { [void]$expected.Add($file) }
  }
}

$copied = 0
$missing = @()
foreach ($dll in $expected) {
  $dest = Join-Path $releaseDir $dll
  if (Test-Path $dest) { continue }

  $src = Join-Path $nativeAssetsDir $dll
  if (Test-Path $src) {
    Copy-Item -Path $src -Destination $dest -Force
    Write-Host "Bundled native asset: $dll"
    $copied++
  } else {
    $missing += $dll
  }
}

if ($missing.Count -gt 0) {
  Write-Host "::error::Native-asset DLL(s) declared in the manifest but not found in ${nativeAssetsDir}:"
  $missing | ForEach-Object { Write-Host "  - $_" }
  throw "Cannot package a complete MSIX: $($missing.Count) native-asset DLL(s) missing. " +
        "Ensure the Rust toolchain is installed and native assets are enabled so the " +
        "plugin build hooks (turso_dart, flutter_gemma_*) compile their libraries."
}

# Final guard: every declared DLL must now physically exist in Release.
$stillMissing = @($expected | Where-Object { -not (Test-Path (Join-Path $releaseDir $_)) })
if ($stillMissing.Count -gt 0) {
  throw "Native-asset bundling incomplete; missing in Release: $($stillMissing -join ', ')"
}

Write-Host "Native-asset bundling OK: $($expected.Count) DLL(s) verified in Release ($copied newly copied)."
