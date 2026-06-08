param(
  [string]$AppDir = "apps/flipper",
  [string]$Arch = "x64",
  [int]$MinBytes = 2000000,
  [int]$MaxAttempts = 6
)

$ErrorActionPreference = "Stop"

function Get-PdfiumVersion {
  param([string]$PrintingCmake)

  if (-not (Test-Path $PrintingCmake)) {
    throw "printing CMakeLists not found at $PrintingCmake. Run 'flutter pub get' first."
  }

  $match = Select-String -Path $PrintingCmake -Pattern 'set\(PDFIUM_VERSION "(\d+)"' |
    Select-Object -First 1
  if (-not $match) {
    throw "Could not read PDFIUM_VERSION from $PrintingCmake"
  }
  return $match.Matches.Groups[1].Value
}

Push-Location $AppDir
try {
  $printingCmake = "windows/flutter/ephemeral/.plugin_symlinks/printing/windows/CMakeLists.txt"
  if (-not (Test-Path $printingCmake)) {
    Write-Host "Plugin symlinks missing; running flutter pub get..."
    flutter pub get | Out-Host
  }

  $pdfiumVersion = Get-PdfiumVersion -PrintingCmake $printingCmake
  $archiveName = "pdfium-win-$Arch.tgz"
  $cacheDir = Join-Path $env:RUNNER_TEMP "pdfium"
  New-Item -ItemType Directory -Force -Path $cacheDir | Out-Null
  $archivePath = Join-Path $cacheDir $archiveName

  if ((Test-Path $archivePath) -and ((Get-Item $archivePath).Length -ge $MinBytes)) {
    Write-Host "Reusing cached $archiveName ($pdfiumVersion) at $archivePath"
  } else {
    $urls = @(
      "https://github.com/bblanchon/pdfium-binaries/releases/download/chromium/$pdfiumVersion/$archiveName",
      "https://github.com/bblanchon/pdfium-binaries/releases/latest/download/$archiveName"
    )

    $downloaded = $false
    foreach ($url in $urls) {
      for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
        try {
          Write-Host "Downloading $archiveName from $url (attempt $attempt/$MaxAttempts)..."
          Invoke-WebRequest -Uri $url -OutFile $archivePath -UseBasicParsing
          $size = (Get-Item $archivePath).Length
          if ($size -lt $MinBytes) {
            Remove-Item $archivePath -Force -ErrorAction SilentlyContinue
            throw "Downloaded file was too small ($size bytes)"
          }
          $downloaded = $true
          Write-Host "Downloaded $archiveName ($size bytes)"
          break
        } catch {
          Write-Warning "Attempt $attempt failed for ${url}: $_"
          Remove-Item $archivePath -Force -ErrorAction SilentlyContinue
          if ($attempt -lt $MaxAttempts) {
            Start-Sleep -Seconds ([Math]::Min(30, 5 * $attempt))
          }
        }
      }
      if ($downloaded) {
        break
      }
    }

    if (-not $downloaded) {
      throw "Failed to download $archiveName after $MaxAttempts attempts per URL"
    }
  }

  # CMake install scripts treat \ as escapes (D:\a\... -> invalid \a). Use forward slashes.
  $archivePathForCmake = $archivePath -replace '\\', '/'
  Add-Content -Path $env:GITHUB_ENV -Value "PDFIUM_TGZ_PATH=$archivePathForCmake"
  Write-Host "pdfium archive ready at $archivePathForCmake (version $pdfiumVersion)"
} finally {
  Pop-Location
}
