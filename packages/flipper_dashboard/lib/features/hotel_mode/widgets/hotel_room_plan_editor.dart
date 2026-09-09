import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_admin_widgets.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

class _Floor {
  const _Floor({
    required this.id,
    required this.name,
    required this.rooms,
  });

  final String id;
  final String name;
  final List<HotelRoom> rooms;
}

/// Room inventory editor for [AdminControl] — the hotel counterpart of
/// [BarFloorPlanEditor].
///
/// Rooms are seeded from a default plan on first launch; this is where a
/// property replaces those with its own numbers, types, capacities and rates.
class HotelRoomPlanEditor extends ConsumerStatefulWidget {
  const HotelRoomPlanEditor({super.key});

  @override
  ConsumerState<HotelRoomPlanEditor> createState() =>
      _HotelRoomPlanEditorState();
}

class _HotelRoomPlanEditorState extends ConsumerState<HotelRoomPlanEditor> {
  bool _busy = false;

  dynamic get _sync => ProxyService.getStrategy(Strategy.capella);

  List<_Floor> _floors(List<HotelRoom> rooms) {
    final order = <String>[];
    final byFloor = <String, List<HotelRoom>>{};
    for (final room in rooms) {
      if (!byFloor.containsKey(room.floorId)) order.add(room.floorId);
      byFloor.putIfAbsent(room.floorId, () => <HotelRoom>[]).add(room);
    }
    return [
      for (final id in order)
        _Floor(id: id, name: byFloor[id]!.first.floorName, rooms: byFloor[id]!),
    ];
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          '$e',
          backgroundColor: Colors.red.shade600,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save(HotelRoom room) => _run(() => _sync.saveHotelRoom(room));

  Future<void> _renameFloor(_Floor floor, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed == floor.name) return;
    await _run(() async {
      for (final room in floor.rooms) {
        await _sync.saveHotelRoom(room.copyWith(floorName: trimmed));
      }
    });
  }

  Future<void> _addRoom(_Floor floor, List<HotelRoom> allRooms) async {
    final template = floor.rooms.isEmpty ? null : floor.rooms.last;
    var suggestion = hotelSuggestRoomNumber(floor.rooms);
    // Never mint a duplicate: walk forward until the number is free.
    var guard = 0;
    while (hotelRoomNumberIsTaken(rooms: allRooms, name: suggestion) &&
        guard++ < 500) {
      final asNumber = int.tryParse(suggestion);
      suggestion = asNumber == null
          ? '$suggestion+'
          : '${asNumber + 1}';
    }

    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;

    await _save(
      HotelRoom(
        id: const Uuid().v4(),
        branchId: branchId,
        floorId: floor.id,
        floorName: floor.name,
        name: suggestion,
        roomType: template?.roomType ?? 'Double',
        capacity: template?.capacity ?? 2,
        nightlyRate: template?.nightlyRate ?? 50000,
        ordinal: allRooms.length,
      ),
    );
  }

  Future<void> _addFloor(List<HotelRoom> allRooms) async {
    final name = await _promptName(context, title: 'New floor or wing');
    if (name == null || name.trim().isEmpty) return;

    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;

    final floorId = const Uuid().v4();
    var suggestion = hotelSuggestRoomNumber(const []);
    var guard = 0;
    while (hotelRoomNumberIsTaken(rooms: allRooms, name: suggestion) &&
        guard++ < 500) {
      suggestion = 'Room ${allRooms.length + guard + 1}';
    }

    // A floor exists only through its rooms, so it starts with one.
    await _save(
      HotelRoom(
        id: const Uuid().v4(),
        branchId: branchId,
        floorId: floorId,
        floorName: name.trim(),
        name: suggestion,
        roomType: 'Double',
        capacity: 2,
        nightlyRate: 50000,
        ordinal: allRooms.length,
      ),
    );
  }

  Future<void> _deleteRoom(HotelRoom room, List<HotelStay> stays) async {
    if (!hotelRoomCanBeDeleted(room: room, stays: stays)) {
      showCustomSnackBarUtil(
        context,
        'Room ${room.name} has a guest or a booking. Check them out first.',
        backgroundColor: Colors.red.shade600,
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Delete room ${room.name}?',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'It disappears from the board, the calendar and availability. '
          'Past stays and their invoices are untouched.',
          style: GoogleFonts.outfit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await _run(
      () => _sync.deleteHotelRoom(id: room.id, branchId: room.branchId),
    );
  }

  Future<void> _deleteFloor(_Floor floor, List<HotelStay> stays) async {
    final blocked = floor.rooms
        .where((room) => !hotelRoomCanBeDeleted(room: room, stays: stays))
        .toList();
    if (blocked.isNotEmpty) {
      showCustomSnackBarUtil(
        context,
        'Room ${blocked.first.name} still has a guest or a booking.',
        backgroundColor: Colors.red.shade600,
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Delete ${floor.name}?',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Removes ${floor.rooms.length} room'
          '${floor.rooms.length == 1 ? '' : 's'} on this floor.',
          style: GoogleFonts.outfit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await _run(() async {
      for (final room in floor.rooms) {
        await _sync.deleteHotelRoom(id: room.id, branchId: room.branchId);
      }
    });
  }

  Future<void> _seedDefaults() async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return;
    await _run(() => _sync.seedDefaultRooms(branchId: branchId));
  }

  @override
  Widget build(BuildContext context) {
    final roomsAsync = ref.watch(hotelRoomsProvider);
    final stays = ref.watch(hotelStaysProvider).value ?? const <HotelStay>[];

    return roomsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('$e'),
      data: (rooms) {
        final floors = _floors(rooms);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (rooms.isEmpty)
              _emptyState()
            else
              for (final floor in floors) ...[
                _floorCard(floor, rooms, stays),
                const SizedBox(height: 12),
              ],
            _addFloorButton(rooms),
          ],
        );
      },
    );
  }

  Widget _emptyState() {
    return BarCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No rooms on this branch yet.',
            style: GoogleFonts.outfit(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: HotelTokens.ink1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Start from a sample plan of 15 rooms across three floors, then '
            'edit the numbers, types and rates to match the property.',
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              height: 1.4,
              color: HotelTokens.ink3,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: BarPrimaryButton(
              label: 'Create a starter plan',
              onPressed: _busy ? null : _seedDefaults,
            ),
          ),
        ],
      ),
    );
  }

  Widget _floorCard(_Floor floor, List<HotelRoom> allRooms, List<HotelStay> stays) {
    return BarCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _FloorNameField(
                  key: ValueKey('hotel-floor-name-${floor.id}'),
                  initialName: floor.name,
                  onCommit: (name) => _renameFloor(floor, name),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${floor.rooms.length} room'
                '${floor.rooms.length == 1 ? '' : 's'}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: HotelTokens.ink3,
                ),
              ),
              IconButton(
                tooltip: 'Delete floor',
                onPressed: _busy ? null : () => _deleteFloor(floor, stays),
                icon: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: HotelTokens.ink3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          for (final room in floor.rooms)
            _RoomRow(
              key: ValueKey('hotel-room-row-${room.id}'),
              room: room,
              allRooms: allRooms,
              locked: !hotelRoomCanBeDeleted(room: room, stays: stays),
              busy: _busy,
              onSave: _save,
              onDelete: () => _deleteRoom(room, stays),
            ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _busy ? null : () => _addRoom(floor, allRooms),
              icon: const Icon(Icons.add, size: 17),
              label: Text(
                'Add room',
                style: GoogleFonts.outfit(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addFloorButton(List<HotelRoom> rooms) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: _busy ? null : () => _addFloor(rooms),
        icon: const Icon(Icons.add_circle_outline, size: 18),
        label: Text(
          'Add a floor or wing',
          style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

Future<String?> _promptName(BuildContext context, {required String title}) {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'e.g. Second Floor'),
        onSubmitted: (v) => Navigator.of(dialogContext).pop(v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(controller.text),
          child: const Text('Add'),
        ),
      ],
    ),
  );
}

class _FloorNameField extends StatefulWidget {
  const _FloorNameField({
    super.key,
    required this.initialName,
    required this.onCommit,
  });

  final String initialName;
  final ValueChanged<String> onCommit;

  @override
  State<_FloorNameField> createState() => _FloorNameFieldState();
}

class _FloorNameFieldState extends State<_FloorNameField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) widget.onCommit(_controller.text);
      },
      child: TextField(
        controller: _controller,
        onSubmitted: widget.onCommit,
        style: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: HotelTokens.ink1,
        ),
        decoration: const InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

/// One editable room: number, type, capacity, nightly rate.
class _RoomRow extends StatefulWidget {
  const _RoomRow({
    super.key,
    required this.room,
    required this.allRooms,
    required this.locked,
    required this.busy,
    required this.onSave,
    required this.onDelete,
  });

  final HotelRoom room;
  final List<HotelRoom> allRooms;

  /// A room with a guest or a booking can be re-priced but not removed.
  final bool locked;
  final bool busy;
  final Future<void> Function(HotelRoom) onSave;
  final VoidCallback onDelete;

  @override
  State<_RoomRow> createState() => _RoomRowState();
}

class _RoomRowState extends State<_RoomRow> {
  late final TextEditingController _nameController;
  late final TextEditingController _typeController;
  late final TextEditingController _rateController;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.room.name);
    _typeController = TextEditingController(text: widget.room.roomType);
    _rateController = TextEditingController(
      text: widget.room.nightlyRate.round().toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  void _commitName() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Required');
      _nameController.text = widget.room.name;
      return;
    }
    if (hotelRoomNumberIsTaken(
      rooms: widget.allRooms,
      name: name,
      excludeRoomId: widget.room.id,
    )) {
      setState(() => _nameError = 'In use');
      _nameController.text = widget.room.name;
      return;
    }
    setState(() => _nameError = null);
    if (name != widget.room.name) {
      widget.onSave(widget.room.copyWith(name: name));
    }
  }

  void _commitType() {
    final type = _typeController.text.trim();
    if (type.isEmpty || type == widget.room.roomType) {
      _typeController.text = widget.room.roomType;
      return;
    }
    widget.onSave(widget.room.copyWith(roomType: type));
  }

  void _commitRate() {
    final rate = double.tryParse(_rateController.text.replaceAll(',', ''));
    if (rate == null || rate == widget.room.nightlyRate) {
      _rateController.text = widget.room.nightlyRate.round().toString();
      return;
    }
    widget.onSave(widget.room.copyWith(nightlyRate: rate));
  }

  void _setCapacity(int capacity) {
    if (capacity < 1 || capacity > 12) return;
    widget.onSave(widget.room.copyWith(capacity: capacity));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: HotelTokens.line)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 640;
          final number = SizedBox(
            width: stacked ? null : 96,
            child: _field(
              controller: _nameController,
              hint: 'No.',
              errorText: _nameError,
              onCommit: _commitName,
              bold: true,
            ),
          );
          final type = _field(
            controller: _typeController,
            hint: 'Type',
            onCommit: _commitType,
          );
          final rate = SizedBox(
            width: stacked ? null : 130,
            child: _field(
              controller: _rateController,
              hint: 'Rate',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onCommit: _commitRate,
              prefix: 'RWF ',
            ),
          );
          final capacity = _CapacityStepper(
            value: widget.room.capacity,
            onChanged: widget.busy ? null : _setCapacity,
          );
          final delete = IconButton(
            tooltip: widget.locked
                ? 'Occupied or booked — cannot delete'
                : 'Delete room',
            onPressed: (widget.busy || widget.locked) ? null : widget.onDelete,
            icon: Icon(
              widget.locked ? Icons.lock_outline : Icons.delete_outline,
              size: 17,
              color: widget.locked ? HotelTokens.ink4 : HotelTokens.ink3,
            ),
          );

          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: number),
                    const SizedBox(width: 8),
                    capacity,
                    delete,
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(child: type),
                    const SizedBox(width: 8),
                    Expanded(child: rate),
                  ],
                ),
              ],
            );
          }

          return Row(
            children: [
              number,
              const SizedBox(width: 10),
              Expanded(child: type),
              const SizedBox(width: 10),
              capacity,
              const SizedBox(width: 10),
              rate,
              delete,
            ],
          );
        },
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required VoidCallback onCommit,
    String? errorText,
    String? prefix,
    bool bold = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) onCommit();
      },
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onSubmitted: (_) => onCommit(),
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
          color: HotelTokens.ink1,
        ),
        decoration: InputDecoration(
          hintText: hint,
          prefixText: prefix,
          errorText: errorText,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          filled: true,
          fillColor: HotelTokens.surface2,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
            borderSide: const BorderSide(color: HotelTokens.line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
            borderSide: const BorderSide(color: HotelTokens.line),
          ),
        ),
      ),
    );
  }
}

class _CapacityStepper extends StatelessWidget {
  const _CapacityStepper({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: HotelTokens.surface2,
        borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
        border: Border.all(color: HotelTokens.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove, value > 1 ? () => onChanged?.call(value - 1) : null),
          SizedBox(
            width: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 13,
                  color: HotelTokens.ink3,
                ),
                const SizedBox(width: 3),
                Text(
                  '$value',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: HotelTokens.ink1,
                  ),
                ),
              ],
            ),
          ),
          _btn(
            Icons.add,
            value < 12 ? () => onChanged?.call(value + 1) : null,
          ),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback? onTap) {
    return SizedBox(
      width: 28,
      height: 40,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onChanged == null ? null : onTap,
        icon: Icon(
          icon,
          size: 15,
          color: onTap == null ? HotelTokens.ink4 : HotelTokens.ink2,
        ),
      ),
    );
  }
}
