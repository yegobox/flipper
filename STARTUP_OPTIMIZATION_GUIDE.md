# Startup Optimization Guide

## Problem Analysis

The app shows a **blank black screen** before the StartupView appears because of the initialization sequence in `main.dart`:

### Current Flow:
1. **Native splash screen** shows (good! ✅)
2. App starts with `FutureBuilder` waiting for `initializeApp()` to complete
3. During `initializeApp()`:
   - Firebase initialization (awaited)
   - `initializeDependencies()` (awaited)
   - Supabase initialization (awaited in microtask)
   - Ditto initialization (awaited in microtask)
   - Service locator setup
   - Dialog/BottomSheet setup
   - DittoSyncRegistry
4. While waiting, shows a basic `CircularProgressIndicator` on white background
5. **BLACK SCREEN** appears when FutureBuilder is in waiting state but before the loading UI renders
6. Once complete, removes native splash and shows `FlipperApp`
7. Router navigates to `StartUpView`
8. `StartUpView` runs `runStartupLogic()` which does:
   - `_allRequirementsMeets()` - checks user, business, branches
   - `AppInitializer.initialize()`
   - Payment verification
   - EBM sync setup
   - Asset sync
   - More async operations...

### Root Causes of Black Screen:

1. **Double Initialization**: Heavy lifting happens in both `main.dart` and `StartupViewModel`
2. **Blocking Operations**: All initialization is awaited sequentially
3. **Missing Loading UI**: The FutureBuilder loading state is too basic
4. **Native Splash Removed Too Late**: Splash is kept until ALL initialization completes

## Recommended Optimizations

### 1. Keep Native Splash Longer ⚡
**Priority: HIGH** - Easiest and most impactful

```dart
// In main.dart - DO NOT remove splash in FutureBuilder
Future<void> main() async {
  final widgetsBinding = SentryWidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await SentryFlutter.init(
    (options) async => /* ... */,
    appRunner: () => runApp(
      FutureBuilder(
        future: initializeApp(),
        builder: (context, snapshot) {
          // DON'T remove splash here!
          // Let StartupView remove it when ready
          return const FlipperApp();
        },
      ),
    ),
  );
}

// In StartupViewModel - remove splash after successful navigation
Future<void> runStartupLogic() async {
  try {
    // ... your initialization code ...
    
    // Remove splash ONLY when ready to show first screen
    FlutterNativeSplash.remove();
    
    _routerService.navigateTo(FlipperAppRoute());
  } catch (e) {
    FlutterNativeSplash.remove(); // Remove on error too
    // ... error handling ...
  }
}
```

### 2. Parallel Initialization 🚀
**Priority: HIGH** - Significant performance gain

```dart
// In main.dart
Future<void> initializeApp() async {
  if (!skipDependencyInitialization) {
    // Run independent initializations in parallel
    await Future.wait([
      _initializeFirebase(),
      initializeDependencies(),
      _initializeSupabase(), // Already uses microtask internally
    ]);
    
    // Setup that depends on above
    loc.setupLocator(stackedRouter: stackedRouter);
    setupDialogUi();
    setupBottomSheetUi();
    
    // These can also run in parallel
    await Future.wait([
      initDependencies(),
      DittoSyncRegistry.registerDefaults(),
    ]);
  }
}
```

### 3. Defer Non-Critical Operations 📦
**Priority: MEDIUM** - Better perceived performance

Move non-critical initializations to run AFTER the first screen shows:

```dart
class StartupViewModel extends FlipperBaseModel with CoreMiscellaneous {
  Future<void> runStartupLogic() async {
    try {
      // CRITICAL: Must complete before showing app
      await _allRequirementsMeets();
      await _handleInitialPaymentVerification();
      
      // Remove splash and navigate IMMEDIATELY
      FlutterNativeSplash.remove();
      _routerService.navigateTo(FlipperAppRoute());
      
      // NON-CRITICAL: Run in background after navigation
      _initializeBackgroundServices();
    } catch (e, stackTrace) {
      FlutterNativeSplash.remove();
      await _handleStartupError(e, stackTrace);
    }
  }
  
  void _initializeBackgroundServices() {
    // Run without await - don't block navigation
    Future.microtask(() async {
      try {
        AppInitializer.initialize();
        final repository = Repository();
        EbmSyncService(repository);
        AssetSyncService().initialize();
        ProxyService.strategy.cleanDuplicatePlans();
        
        _paymentVerificationService
            .setPaymentStatusChangeCallback(_handlePaymentStatusChange);
        _paymentVerificationService.startPeriodicVerification();
        _internetConnectionService.startPeriodicConnectionCheck();
        
        await appService.appInit();
      } catch (e) {
        talker.warning('Background service initialization error: $e');
      }
    });
  }
}
```

### 4. Optimize Database Configuration ⚙️
**Priority: MEDIUM**

The database PRAGMA configuration is currently synchronous. Cache the connection:

```dart
// In database_manager.dart
Future<void> configureDatabaseSettings(
    String dbPath, DatabaseFactory dbFactory) async {
  // Only configure once per app session
  if (_isConfigured) return;
  
  try {
    // ... existing configuration code ...
    _isConfigured = true;
  } catch (e) {
    // ... error handling ...
  }
}
```

### 5. Add Intermediate Loading Screen 🎨
**Priority: LOW** - Better UX but not performance

Replace the basic CircularProgressIndicator in main.dart:

```dart
// Create a proper loading screen widget
class SplashLoadingScreen extends StatelessWidget {
  const SplashLoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white, // Match your splash screen color
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your logo
              Image.asset('assets/logo.png', width: 120),
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Loading...',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Use in main.dart FutureBuilder
builder: (context, snapshot) {
  if (snapshot.connectionState == ConnectionState.done) {
    return const FlipperApp();
  }
  return const SplashLoadingScreen();
}
```

### 6. Profile and Measure 📊
**Priority: HIGH** - Know what to optimize

Add timing measurements:

```dart
Future<void> initializeApp() async {
  final stopwatch = Stopwatch()..start();
  
  debugPrint('⏱️ Starting initialization...');
  
  await _initializeFirebase();
  debugPrint('⏱️ Firebase: ${stopwatch.elapsedMilliseconds}ms');
  
  await initializeDependencies();
  debugPrint('⏱️ Dependencies: ${stopwatch.elapsedMilliseconds}ms');
  
  await _initializeSupabase();
  debugPrint('⏱️ Supabase: ${stopwatch.elapsedMilliseconds}ms');
  
  // ... etc
  
  debugPrint('⏱️ Total initialization: ${stopwatch.elapsedMilliseconds}ms');
}
```

## Implementation Priority

### Phase 1: Quick Wins (< 1 hour)
1. ✅ Keep native splash until navigation
2. ✅ Add timing measurements
3. ✅ Parallelize independent operations

### Phase 2: Background Services (2-3 hours)
1. ✅ Defer non-critical services
2. ✅ Move EBM/Asset sync to background
3. ✅ Optimize database configuration caching

### Phase 3: UI Polish (1-2 hours)
1. ✅ Create proper loading screen
2. ✅ Add progress indicators
3. ✅ Test on physical devices

## Expected Results

### Before Optimization:
- Native splash → Black screen (500-1000ms) → StartupView (500ms) → Main app
- Total: **2-3 seconds** to first interaction

### After Optimization:
- Native splash → Main app (immediately visible)
- Background services load while user can already interact
- Total: **< 1 second** to first interaction

## Testing Checklist

- [ ] Test on iOS physical device
- [ ] Test on Android physical device
- [ ] Test on Windows
- [ ] Test on macOS
- [ ] Test with slow network
- [ ] Test with no network
- [ ] Test first-time installation
- [ ] Test with existing data
- [ ] Verify all background services eventually initialize
- [ ] Check for race conditions in background init

## Potential Issues to Watch

1. **Race Conditions**: Ensure critical services are initialized before use
2. **Error Handling**: Background services need proper error handling
3. **Memory**: Don't start too many operations simultaneously on low-end devices
4. **User Experience**: Don't show errors from background services to users

## Additional Notes

The black screen is caused by the window being rendered before any content is ready. The native splash screen is the best solution because it's rendered by the native platform, not Flutter.

By keeping the native splash visible until the first actual screen is ready to render, users never see a black screen.
