# Vendored `device_preview_plus` 2.8.4

Copied from `~/.pub-cache/hosted/pub.dev/device_preview_plus-2.8.4` (`example/`,
`test/` and the JS tooling files are not included). Wired in through
`dependency_overrides` in `apps/flipper/pubspec.yaml`.

## Why it is forked

**One patch, in `lib/src/device_preview.dart`: the root `LayoutBuilder` that
hosts the app is now a `Builder`.**

A `LayoutBuilder` owns its own `BuildScope`
(`flutter/lib/src/widgets/layout_builder.dart:119-121`), and
`Element.buildScope` propagates that scope to the *entire* subtree. Because the
app is hosted inside it, **every rebuild anywhere in the app ran during
`performLayout`** whenever DevicePreview was enabled.

Rebuilding during layout is only legal for render objects inside dirty subtrees,
so this broke ordinary work:

- Mounting any `OverlayPortal` — a `Tooltip`, a `flutter_typeahead` suggestions
  box — threw from `_RenderTheater._addDeferredChild`
  (`'!_skipMarkNeedsLayout'`).
- Pushing a route re-parented stacked's GlobalKey'd `Navigator`
  (`route_navigator.dart:65`); every `OverlayPortal` in that subtree re-inserted
  its deferred child during layout, throwing `A _RenderLayoutBuilder was mutated
  in _RenderLayoutBuilder.performLayout`, followed by
  `_elements.contains(element)` from the GlobalKey retake.

Worse, the fallout outlived the trigger. Both
`_RenderTheater._addDeferredChild` and `MouseTracker._deviceUpdatePhase` set a
debug guard, run a callback, then clear the guard **with no `try`/`finally`** — so
the first throw leaves the guard latched `true` and every later frame asserts
identically until the app restarts. Hot reload does not clear it. That is why one
navigation produced thousands of identical, misleading stack traces, in two
different subsystems.

## Why the patch is safe

`constraints` was used exactly twice: `constraints.maxWidth < 700` (toolbar
layout) and `constraints.maxHeight * 0.5` (menu height). Both now read
`mediaQuery.size`, and `mediaQuery` was already declared on the next line.

That `MediaQuery` comes from the `MediaQueryObserver` immediately above, which
installs `MediaQueryData.fromView(window)` and calls `setState` from
`didChangeMetrics`. Its size therefore equals the constraints this root-level box
received, and the toolbar still re-lays-out on window resize.

## Upgrading

The override pins the version, so `pub upgrade` cannot silently undo this. When
moving to a newer release:

1. Re-copy the package here and re-apply the single patch (search for
   `FLIPPER PATCH`).
2. Run `apps/flipper/test/device_preview_no_layout_builder_test.dart`, which
   fails if a `LayoutBuilder` is an ancestor of the hosted app again.
3. If upstream has fixed it, drop the override and delete this directory.
