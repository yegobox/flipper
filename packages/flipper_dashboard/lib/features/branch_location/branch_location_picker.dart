import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/helpers/branch_coordinates.dart';
import 'package:flipper_services/abstractions/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

typedef BranchCoordinates = ({double latitude, double longitude});

/// Where the map opens when the branch has no real location yet.
const LatLng _kigali = LatLng(-1.9441, 30.0619);

/// Lets the user drop a pin for a branch, either by tapping an OpenStreetMap
/// map or from the device's GPS. Returns null when cancelled.
Future<BranchCoordinates?> showBranchLocationPicker(
  BuildContext context, {
  required FlipperLocation location,
  num? latitude,
  num? longitude,
}) {
  return showDialog<BranchCoordinates>(
    context: context,
    builder: (_) => _BranchLocationPickerDialog(
      location: location,
      initial: hasRealBranchCoordinates(latitude, longitude)
          ? LatLng(latitude!.toDouble(), longitude!.toDouble())
          : null,
    ),
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

class _BranchLocationPickerDialog extends StatefulWidget {
  const _BranchLocationPickerDialog({required this.location, this.initial});

  final FlipperLocation location;
  final LatLng? initial;

  @override
  State<_BranchLocationPickerDialog> createState() =>
      _BranchLocationPickerDialogState();
}

class _BranchLocationPickerDialogState
    extends State<_BranchLocationPickerDialog> {
  final _mapController = MapController();
  LatLng? _pin;
  bool _locating = false;
  LocationFailure? _failure;

  @override
  void initState() {
    super.initState();
    _pin = widget.initial;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _locating = true;
      _failure = null;
    });
    final outcome = await widget.location.currentPosition();
    if (!mounted) return;
    final fix = outcome.hasFix
        ? LatLng(outcome.latitude!, outcome.longitude!)
        : null;
    setState(() {
      _locating = false;
      _failure = outcome.failure;
      if (fix != null) _pin = fix;
    });
    if (fix != null) _mapController.move(fix, 17);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final pin = _pin;
    return AlertDialog(
      title: Text(l10n.branchLocationPickerTitle),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      content: SizedBox(
        width: 560,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.branchLocationTapToPlace,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                height: 340,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: widget.initial ?? _kigali,
                    initialZoom: widget.initial != null ? 16 : 12,
                    onTap: (_, point) => setState(() => _pin = point),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'rw.flipper',
                    ),
                    if (pin != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: pin,
                            width: 40,
                            height: 40,
                            alignment: Alignment.topCenter,
                            child: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    const SimpleAttributionWidget(
                      source: Text('OpenStreetMap contributors'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _locating ? null : _useCurrentLocation,
                  icon: _locating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location, size: 18),
                  label: Text(l10n.branchLocationUseCurrent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    pin == null
                        ? l10n.branchLocationMissing
                        : formatBranchCoordinates(pin.latitude, pin.longitude),
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
            if (_failure case final failure?)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        // The map still works without GPS, so say so.
                        '${locationFailureMessage(context, failure)} '
                        '${l10n.branchLocationTapMapInstead}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade400,
                        ),
                      ),
                    ),
                    if (locationFailureNeedsSettings(failure))
                      TextButton(
                        onPressed: () =>
                            widget.location.openSettingsFor(failure),
                        child: Text(l10n.branchLocationOpenSettings),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: pin == null
              ? null
              : () => Navigator.of(context).pop<BranchCoordinates>((
                  latitude: pin.latitude,
                  longitude: pin.longitude,
                )),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
