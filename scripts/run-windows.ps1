#!/usr/bin/env pwsh
# Build and run the Flipper Windows app reliably on a local (non-CI) machine.
#
# CI runs on elevated GitHub runners with Rust pre-installed and no third-party
# antivirus, so it "just works" there. Local machines need a few workarounds,
# which this script bundles so nobody has to remember them:
#
#   1. Put the Rust toolchain (~/.cargo/bin) on PATH for turso_dart's build hook.
#   2. Set UseMultiToolTask=true so each source compiles to its own PDB, avoiding
#      antivirus PDB-lock failures (C1041 / LNK1104 / MSB6003 "used by another
#      process").
#   3. Recover turso_dart_native.dll: cargo sometimes fails to link the built DLL
#      from release\deps\ to the release\ root (antivirus grabs it mid-build),
#      which makes Flutter's install_code_assets step fail. Restore it and retry.
#
# Usage:
#   pwsh scripts/run-windows.ps1            # flutter run -d windows
#   pwsh scripts/run-windows.ps1 --release  # extra args are forwarded to flutter

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$appDir = Join-Path $repoRoot "apps/flipper"

# 1. Rust toolchain on PATH (install once: winget install Rustlang.Rustup; rustup default stable)
$cargoBin = Join-Path $env:USERPROFILE ".cargo\bin"
if (Test-Path (Join-Path $cargoBin "rustup.exe")) {
  $env:Path = "$cargoBin;$env:Path"
} else {
  Write-Warning "rustup not found at $cargoBin. turso_dart's native build will fail."
  Write-Warning "Install it: winget install Rustlang.Rustup; then run 'rustup default stable'."
}

# 2. Per-source PDBs to dodge antivirus PDB locking during parallel compiles.
$env:UseMultiToolTask = "true"

function Restore-TursoDll {
  # Copy release\deps\turso_dart_native.dll back to the release\ root if the
  # link there went missing. Returns $true if anything was restored.
  $base = Join-Path $appDir ".dart_tool/hooks_runner/shared/turso_dart/build"
  if (-not (Test-Path $base)) { return $false }
  $restored = $false
  Get-ChildItem -Path $base -Recurse -Filter "turso_dart_native.dll" -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -match "release\\deps\\" } |
    ForEach-Object {
      $rootDll = Join-Path $_.Directory.Parent.FullName "turso_dart_native.dll"
      if (-not (Test-Path $rootDll)) {
        Copy-Item $_.FullName $rootDll -Force
        Write-Host "[run-windows] restored $rootDll"
        $restored = $true
      }
    }
  return $restored
}

Push-Location $appDir
try {
  flutter run -d windows @args
  if ($LASTEXITCODE -eq 0) { exit 0 }

  Write-Host "[run-windows] build failed; attempting turso DLL recovery + one retry..."
  if (Restore-TursoDll) {
    flutter run -d windows @args
  }
  exit $LASTEXITCODE
} finally {
  Pop-Location
}
