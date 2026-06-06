param(
  [string]$AppDir = "apps/flipper"
)

$ErrorActionPreference = "Stop"
Push-Location $AppDir

try {
  $dittoVersion = dart pub deps --style=compact 2>$null |
    Select-String -Pattern '^- ditto_live (\S+)' |
    ForEach-Object { $_.Matches.Groups[1].Value } |
    Select-Object -First 1

  if (-not $dittoVersion) {
    throw "Could not determine ditto_live version from pub deps"
  }

  $dllDir = Join-Path $env:RUNNER_TEMP "dittoffi"
  New-Item -ItemType Directory -Force -Path $dllDir | Out-Null
  $dllPath = Join-Path $dllDir "dittoffi.dll"

  $urls = @(
    "https://software.ditto.live/flutter/ditto/$dittoVersion/windows/x86_64/dittoffi.dll",
    "https://software.ditto.live/flutter/ditto/5.0.1/windows/x86_64/dittoffi.dll"
  )

  $downloaded = $false
  foreach ($url in $urls) {
    for ($attempt = 1; $attempt -le 3; $attempt++) {
      try {
        Write-Host "Downloading dittoffi.dll from $url (attempt $attempt)..."
        Invoke-WebRequest -Uri $url -OutFile $dllPath -UseBasicParsing
        if ((Get-Item $dllPath).Length -gt 1000000) {
          $downloaded = $true
          break
        }
        Remove-Item $dllPath -Force -ErrorAction SilentlyContinue
        throw "Downloaded file was too small"
      } catch {
        Write-Warning "Attempt $attempt failed for ${url}: $_"
        if ($attempt -lt 3) {
          Start-Sleep -Seconds 5
        }
      }
    }
    if ($downloaded) {
      break
    }
  }

  if (-not $downloaded) {
    throw "Failed to download dittoffi.dll"
  }

  # CMake install scripts treat \ as escapes (D:\a\... → invalid \a). Use forward slashes.
  $dllPathForCmake = $dllPath -replace '\\', '/'
  Add-Content -Path $env:GITHUB_ENV -Value "LIBDITTOFFI_PATH=$dllPathForCmake"
  Write-Host "dittoffi.dll ready at $dllPathForCmake (ditto_live $dittoVersion)"
} finally {
  Pop-Location
}
