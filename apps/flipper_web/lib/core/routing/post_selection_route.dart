/// Route **name** opened once a business + branch are picked in
/// [BusinessBranchSelector].
///
/// flipper_web lands on Books (`accounting`). Apps that reuse this login /
/// business-selection flow as a package — e.g. `flipper_hr` — assign their own
/// home route name in `main()` before the router is built.
String postSelectionRouteName = 'accounting';
