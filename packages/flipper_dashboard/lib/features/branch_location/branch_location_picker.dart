import 'dart:async';

import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/helpers/branch_coordinates.dart';
import 'package:flipper_services/abstractions/location.dart';
import 'package:flipper_services/place_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// What the picker returns: the pinned spot and, when the lookup found one,
/// a short street address for it.
class BranchLocationPick {
  const BranchLocationPick({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  final double latitude;
  final double longitude;
  final String? address;
}

/// Where the map opens when the branch has no real location yet.
const LatLng _kigali = LatLng(-1.9441, 30.0619);

/// Below this width the picker takes the whole screen.
const double _fullScreenBelow = 600;

/// Pick a branch's location on an OpenStreetMap map. The pin stays in the
/// middle and the map moves under it (drag, search, or the device's GPS).
/// Returns null when cancelled.
Future<BranchLocationPick?> showBranchLocationPicker(
  BuildContext context, {
  required FlipperLocation location,
  required PlaceSearch places,
  num? latitude,
  num? longitude,
  @visibleForTesting bool loadTiles = true,
}) {
  final initial = hasRealBranchCoordinates(latitude, longitude)
      ? LatLng(latitude!.toDouble(), longitude!.toDouble())
      : null;
  return showDialog<BranchLocationPick>(
    context: context,
    builder: (dialogContext) {
      final picker = _BranchLocationPicker(
        location: location,
        places: places,
        initial: initial,
        loadTiles: loadTiles,
        fullScreen: MediaQuery.sizeOf(dialogContext).width < _fullScreenBelow,
      );
      if (MediaQuery.sizeOf(dialogContext).width < _fullScreenBelow) {
        return Dialog.fullscreen(child: SafeArea(child: picker));
      }
      final size = MediaQuery.sizeOf(dialogContext);
      return Dialog(
        insetPadding: const EdgeInsets.all(32),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          width: (size.width - 64).clamp(0, 960).toDouble(),
          height: (size.height - 64).clamp(0, 720).toDouble(),
          child: picker,
        ),
      );
    },
  );
}

String formatBranchCoordinates(num latitude, num longitude) =>
    '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';

/// What to tell the user when the device position could not be read.
String locationFailureMessage(BuildContext context, LocationFailure failure) {
  final l10n = context.flipperL10n;
  return switch (failure) {
    LocationFailure.serviceDisabled => l10n.branchLocationServiceOff,
    LocationFailure.denied => l10n.branchLocationDenied,
    LocationFailure.deniedForever => l10n.branchLocationBlocked,
    LocationFailure.unavailable => l10n.branchLocationUnavailable,
  };
}

/// Failures only the system settings can fix: the OS will not show the
/// permission dialog again, or location is switched off.
bool locationFailureNeedsSettings(LocationFailure failure) =>
    failure == LocationFailure.deniedForever ||
    failure == LocationFailure.serviceDisabled;

class _BranchLocationPicker extends StatefulWidget {
  const _BranchLocationPicker({
    required this.location,
    required this.places,
    required this.initial,
    required this.loadTiles,
    required this.fullScreen,
  });

  final FlipperLocation location;
  final PlaceSearch places;
  final LatLng? initial;
  final bool loadTiles;
  final bool fullScreen;

  @override
  State<_BranchLocationPicker> createState() => _BranchLocationPickerState();
}

class _BranchLocationPickerState extends State<_BranchLocationPicker> {
  final _map = MapController();
  final _query = TextEditingController();
  final _queryFocus = FocusNode();

  late LatLng _center = widget.initial ?? _kigali;

  /// False until the user has put the pin somewhere on purpose, so the
  /// default view of Kigali can never be saved by accident.
  late bool _chosen = widget.initial != null;

  /// The map is being dragged; the pin lifts while it is.
  bool _moving = false;
  Timer? _settleTimer;

  LatLng? _gpsFix;
  double? _gpsAccuracy;
  bool _locating = false;
  LocationFailure? _failure;

  String? _address;
  bool _lookingUp = false;
  Timer? _lookupTimer;
  int _lookupSeq = 0;

  List<PlaceResult>? _results;
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    if (_chosen) {
      _lookingUp = true; // no setState inside initState
      _scheduleLookup(immediately: true);
    } else {
      // Jump to the device only when that cannot pop a permission dialog
      // the user did not ask for.
      unawaited(_locateIfAlreadyAllowed());
    }
  }

  @override
  void dispose() {
    _settleTimer?.cancel();
    _lookupTimer?.cancel();
    _map.dispose();
    _query.dispose();
    _queryFocus.dispose();
    super.dispose();
  }

  Future<void> _locateIfAlreadyAllowed() async {
    final allowed = await widget.location.hasLocationPermission();
    if (allowed && mounted && !_chosen) await _useCurrentLocation();
  }

  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    _center = camera.center;
    if (!hasGesture) return;
    _settleTimer?.cancel();
    _settleTimer = Timer(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => _moving = false);
    });
    setState(() {
      _chosen = true;
      _moving = true;
      _lookingUp = true;
      _results = null;
    });
    _scheduleLookup();
  }

  void _moveTo(LatLng point, {double zoom = 17, String? address}) {
    _map.move(point, zoom);
    setState(() {
      _center = point;
      _chosen = true;
      _results = null;
    });
    if (address != null) {
      _lookupTimer?.cancel();
      _lookupSeq++;
      setState(() {
        _address = address;
        _lookingUp = false;
      });
    } else {
      _scheduleLookup();
    }
  }

  void _zoomBy(double delta) {
    final camera = _map.camera;
    _map.move(camera.center, (camera.zoom + delta).clamp(3, 19).toDouble());
  }

  /// Reverse-geocode the pin once the map has been still for a moment
  /// (Nominatim allows one request a second).
  void _scheduleLookup({bool immediately = false}) {
    _lookupTimer?.cancel();
    final seq = ++_lookupSeq;
    if (!_lookingUp) setState(() => _lookingUp = true);
    _lookupTimer = Timer(
      immediately ? Duration.zero : const Duration(milliseconds: 1100),
      () async {
        final point = _center;
        final address = await widget.places.addressAt(
          point.latitude,
          point.longitude,
        );
        if (!mounted || seq != _lookupSeq) return;
        setState(() {
          _address = address;
          _lookingUp = false;
        });
      },
    );
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _locating = true;
      _failure = null;
    });
    final outcome = await widget.location.currentPosition();
    if (!mounted) return;
    setState(() {
      _locating = false;
      _failure = outcome.failure;
    });
    if (!outcome.hasFix) return;
    final fix = LatLng(outcome.latitude!, outcome.longitude!);
    final accuracy = outcome.accuracy;
    setState(() {
      _gpsFix = fix;
      _gpsAccuracy = accuracy;
    });
    // A coarse fix gets a wider view so its circle fits on screen.
    _moveTo(fix, zoom: (accuracy ?? 0) > 150 ? 15 : 18);
  }

  Future<void> _search() async {
    final query = _query.text.trim();
    if (query.isEmpty) return;
    setState(() => _searching = true);
    final results = await widget.places.search(query);
    if (!mounted) return;
    setState(() {
      _searching = false;
      _results = results;
    });
  }

  bool get _pinOnGpsFix {
    final fix = _gpsFix;
    return fix != null &&
        const Distance().as(LengthUnit.Meter, fix, _center) < 2;
  }

  void _save() {
    Navigator.of(context).pop(
      BranchLocationPick(
        latitude: _center.latitude,
        longitude: _center.longitude,
        address: _lookingUp ? null : _address,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(fullScreen: widget.fullScreen),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: _buildMap(theme)),
                Positioned.fill(
                  child: IgnorePointer(child: _CentrePin(lifted: _moving)),
                ),
                Positioned(
                  right: 12,
                  bottom: 24,
                  child: _MapControls(
                    locating: _locating,
                    onZoomIn: () => _zoomBy(1),
                    onZoomOut: () => _zoomBy(-1),
                    onLocate: _locating ? null : _useCurrentLocation,
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  top: 12,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: _SearchCard(
                        controller: _query,
                        focusNode: _queryFocus,
                        searching: _searching,
                        results: _results,
                        hint: l10n.branchLocationSearchHint,
                        noResults: l10n.branchLocationNoResults,
                        onSubmit: _search,
                        onClear: () => setState(() {
                          _query.clear();
                          _results = null;
                        }),
                        onPick: (place) {
                          _queryFocus.unfocus();
                          _moveTo(
                            LatLng(place.latitude, place.longitude),
                            address: place.label,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildPanel(context),
        ],
      ),
    );
  }

  Widget _buildMap(ThemeData theme) {
    final fix = _gpsFix;
    final accuracy = _gpsAccuracy;
    return FlutterMap(
      mapController: _map,
      options: MapOptions(
        initialCenter: _center,
        initialZoom: widget.initial != null ? 17 : 12,
        minZoom: 3,
        maxZoom: 19,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        onPositionChanged: _onPositionChanged,
        // Tapping a spot brings it under the pin.
        onTap: (_, point) => _moveTo(point, zoom: _map.camera.zoom),
      ),
      children: [
        if (widget.loadTiles)
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'rw.flipper',
          ),
        if (fix != null && accuracy != null)
          CircleLayer(
            circles: [
              CircleMarker(
                point: fix,
                radius: accuracy,
                useRadiusInMeter: true,
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                borderColor: theme.colorScheme.primary.withValues(alpha: 0.4),
                borderStrokeWidth: 1,
              ),
            ],
          ),
        if (fix != null)
          MarkerLayer(
            markers: [
              Marker(
                point: fix,
                width: 18,
                height: 18,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        const _OsmAttribution(),
      ],
    );
  }

  Widget _buildPanel(BuildContext context) {
    final l10n = context.flipperL10n;
    final theme = Theme.of(context);
    final failure = _failure;
    final accuracy = _gpsAccuracy;

    final String title;
    if (!_chosen) {
      title = l10n.branchLocationPickerHint;
    } else if (_lookingUp) {
      title = l10n.branchLocationFindingAddress;
    } else {
      title = _address ?? l10n.branchLocationNoAddress;
    }
    final details = [
      if (_chosen) formatBranchCoordinates(_center.latitude, _center.longitude),
      if (_chosen && _pinOnGpsFix && accuracy != null)
        l10n.branchLocationAccuracy(accuracy.round().toString()),
    ].join('  ·  ');

    final save = FilledButton.icon(
      onPressed: _chosen ? _save : null,
      icon: const Icon(Icons.check, size: 18),
      label: Text(l10n.branchLocationSave),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (failure != null) ...[
              _FailureBanner(
                message:
                    '${locationFailureMessage(context, failure)} '
                    '${l10n.branchLocationDragInstead}',
                actionLabel: locationFailureNeedsSettings(failure)
                    ? l10n.branchLocationOpenSettings
                    : null,
                onAction: () => widget.location.openSettingsFor(failure),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.storefront_outlined,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: _chosen && !_lookingUp
                              ? null
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (details.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          details,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!widget.fullScreen) ...[
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: 8),
                  save,
                ],
              ],
            ),
            if (widget.fullScreen) ...[
              const SizedBox(height: 12),
              SizedBox(height: 48, child: save),
            ],
          ],
        ),
      ),
    );
  }
}

/// The credit OpenStreetMap's tile licence requires. flutter_map's own
/// attribution widget cannot shrink, and overflows on narrow phones.
class _OsmAttribution extends StatelessWidget {
  const _OsmAttribution();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ConstrainedBox(
          // Leave room for the map controls on the right.
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.6,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              child: Text(
                '© OpenStreetMap contributors',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10, color: Colors.black87),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.fullScreen});

  final bool fullScreen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final theme = Theme.of(context);
    final close = IconButton(
      icon: Icon(fullScreen ? Icons.arrow_back : Icons.close),
      onPressed: () => Navigator.of(context).pop(),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Row(
        children: [
          if (fullScreen) close else const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.branchLocationPickerTitle,
              style: theme.textTheme.titleLarge,
            ),
          ),
          if (!fullScreen) close,
        ],
      ),
    );
  }
}

/// The pin fixed at the map's centre; its tip marks the chosen spot.
class _CentrePin extends StatelessWidget {
  const _CentrePin({required this.lifted});

  final bool lifted;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.error;
    return Center(
      child: SizedBox(
        width: 48,
        height: 96,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Shadow where the tip touches down.
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: lifted ? 8 : 12,
              height: lifted ? 3 : 5,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: lifted ? 0.2 : 0.35),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            AnimatedSlide(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              // location_on's tip is 22/24 down the glyph, i.e. 20px below
              // the icon's centre at size 48: shift up 20/48 to put the tip
              // on the map centre, further while lifted.
              offset: Offset(0, lifted ? -0.62 : -0.4167),
              child: Icon(Icons.location_on, size: 48, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapControls extends StatelessWidget {
  const _MapControls({
    required this.locating,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onLocate,
  });

  final bool locating;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback? onLocate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final theme = Theme.of(context);
    Widget button(IconData icon, String label, VoidCallback? onPressed) {
      return Semantics(
        label: label,
        button: true,
        child: IconButton(icon: Icon(icon), onPressed: onPressed),
      );
    }

    return Column(
      children: [
        Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.surface,
          child: Column(
            children: [
              button(Icons.add, l10n.branchLocationZoomIn, onZoomIn),
              const SizedBox(width: 32, child: Divider(height: 1)),
              button(Icons.remove, l10n.branchLocationZoomOut, onZoomOut),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Material(
          elevation: 2,
          shape: const CircleBorder(),
          color: theme.colorScheme.surface,
          child: Semantics(
            label: l10n.branchLocationUseCurrent,
            button: true,
            child: IconButton(
              key: const Key('branchLocationLocate'),
              onPressed: onLocate,
              icon: locating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.my_location, color: theme.colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchCard extends StatelessWidget {
  const _SearchCard({
    required this.controller,
    required this.focusNode,
    required this.searching,
    required this.results,
    required this.hint,
    required this.noResults,
    required this.onSubmit,
    required this.onClear,
    required this.onPick,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool searching;
  final List<PlaceResult>? results;
  final String hint;
  final String noResults;
  final VoidCallback onSubmit;
  final VoidCallback onClear;
  final ValueChanged<PlaceResult> onPick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final found = results;
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      color: theme.colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => onSubmit(),
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              suffixIcon: searching
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : ListenableBuilder(
                      listenable: controller,
                      builder: (context, _) => controller.text.isEmpty
                          ? const SizedBox.shrink()
                          : IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: onClear,
                            ),
                    ),
            ),
          ),
          if (found != null) ...[
            const Divider(height: 1),
            if (found.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  noResults,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 260),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                    for (final place in found)
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.place_outlined),
                        title: Text(
                          place.label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => onPick(place),
                      ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _FailureBanner extends StatelessWidget {
  const _FailureBanner({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final label = actionLabel;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.location_off_outlined, color: scheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: scheme.onErrorContainer, fontSize: 13),
            ),
          ),
          if (label != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: scheme.onErrorContainer,
              ),
              child: Text(label),
            ),
        ],
      ),
    );
  }
}
