# Switches the primary display of a Windows CI runner to the given resolution.
#
# GitHub's windows-* runners boot with a 1024x768 virtual display, which clamps
# the Flipper window (requested 1280x720 in windows/runner/main.cpp) to about
# 1028x681 and pushes the bottom of taller forms off-screen. Screenshots taken
# there are both small and, for scrolled forms, incomplete.
#
# Best-effort: prints the outcome and never fails the job, since a runner image
# without a resizable display is still fine for a smoke run.
#
#   ./scripts/ci/set-display-resolution.ps1 -Width 1920 -Height 1080

param(
  [int]$Width = 1920,
  [int]$Height = 1080
)

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class CiDisplay {
  [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
  public struct DEVMODE {
    [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] public string dmDeviceName;
    public short dmSpecVersion, dmDriverVersion, dmSize, dmDriverExtra;
    public int dmFields;
    public int dmPositionX, dmPositionY, dmDisplayOrientation, dmDisplayFixedOutput;
    public short dmColor, dmDuplex, dmYResolution, dmTTOption, dmCollate;
    [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] public string dmFormName;
    public short dmLogPixels;
    public int dmBitsPerPel, dmPelsWidth, dmPelsHeight, dmDisplayFlags, dmDisplayFrequency;
    public int dmICMMethod, dmICMIntent, dmMediaType, dmDitherType;
    public int dmReserved1, dmReserved2, dmPanningWidth, dmPanningHeight;
  }

  const int ENUM_CURRENT_SETTINGS = -1;
  const int DM_PELSWIDTH  = 0x00080000;
  const int DM_PELSHEIGHT = 0x00100000;

  [DllImport("user32.dll", CharSet = CharSet.Ansi)]
  static extern bool EnumDisplaySettings(string deviceName, int modeNum, ref DEVMODE devMode);

  [DllImport("user32.dll", CharSet = CharSet.Ansi)]
  static extern int ChangeDisplaySettings(ref DEVMODE devMode, int flags);

  // Returns DISP_CHANGE_* (0 = success) or -100 when the current mode can't be read.
  public static int Set(int width, int height) {
    var dm = new DEVMODE();
    dm.dmSize = (short)Marshal.SizeOf(typeof(DEVMODE));
    if (!EnumDisplaySettings(null, ENUM_CURRENT_SETTINGS, ref dm)) return -100;
    dm.dmPelsWidth = width;
    dm.dmPelsHeight = height;
    dm.dmFields = DM_PELSWIDTH | DM_PELSHEIGHT;
    return ChangeDisplaySettings(ref dm, 0);
  }

  public static string Current() {
    var dm = new DEVMODE();
    dm.dmSize = (short)Marshal.SizeOf(typeof(DEVMODE));
    if (!EnumDisplaySettings(null, ENUM_CURRENT_SETTINGS, ref dm)) return "unknown";
    return dm.dmPelsWidth + "x" + dm.dmPelsHeight;
  }
}
"@

$before = [CiDisplay]::Current()
$result = [CiDisplay]::Set($Width, $Height)
Start-Sleep -Seconds 2
$after = [CiDisplay]::Current()

if ($result -eq 0) {
  Write-Host "Display resolution: $before -> $after"
} else {
  Write-Host "::warning::Could not set display to ${Width}x${Height} (ChangeDisplaySettings returned $result); staying at $after"
}
exit 0
