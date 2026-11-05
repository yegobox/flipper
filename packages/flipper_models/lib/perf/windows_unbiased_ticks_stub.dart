/// No unbiased interrupt time off native platforms; the watchdog uses
/// `Stopwatch` instead.
int Function()? windowsUnbiasedTicks() => null;
