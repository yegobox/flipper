import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_admin_widgets.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_services/proxy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

class _ZoneGroup {
  const _ZoneGroup({
    required this.zoneId,
    required this.zoneName,
    required this.tables,
  });

  final String zoneId;
  final String zoneName;
  final List<BarTable> tables;
}

/// Admin floor-plan editor — zones, tables, seats (`.bar-admin` handover).
class BarFloorPlanEditor extends ConsumerStatefulWidget {
  const BarFloorPlanEditor({super.key});

  @override
  ConsumerState<BarFloorPlanEditor> createState() =>
      _BarFloorPlanEditorState();
}

class _BarFloorPlanEditorState extends ConsumerState<BarFloorPlanEditor> {
  String? _selectedTableId;
  bool _busy = false;

  dynamic get _sync => ProxyService.getStrategy(Strategy.capella);

  String? get _branchId => ProxyService.box.getBranchId();

  List<_ZoneGroup> _groupZones(List<BarTable> tables) {
    final byZone = <String, List<BarTable>>{};
    for (final t in tables) {
      byZone.putIfAbsent(t.zoneId, () => []).add(t);
    }
    final zones = byZone.entries.map((e) {
      final zoneTables = List<BarTable>.from(e.value)
        ..sort((a, b) => a.ordinal.compareTo(b.ordinal));
      return _ZoneGroup(
        zoneId: e.key,
        zoneName: zoneTables.first.zoneName,
        tables: zoneTables,
      );
    }).toList();
    zones.sort(
      (a, b) => (a.tables.firstOrNull?.ordinal ?? 0)
          .compareTo(b.tables.firstOrNull?.ordinal ?? 0),
    );
    return zones;
  }

  Set<String> _openTableIds(List<ITransaction> tabs) {
    return tabs
        .map((t) => t.tableId)
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet();
  }

  Future<void> _runBusy(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _seedDefaults() async {
    final branchId = _branchId;
    if (branchId == null) return;
    await _runBusy(() => _sync.seedDefaultFloorPlan(branchId: branchId));
  }

  Future<void> _saveTable(BarTable table) async {
    await _sync.saveBarTable(table);
  }

  Future<void> _renameZone(_ZoneGroup zone, String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty || trimmed == zone.zoneName) return;
    await _runBusy(() async {
      for (final t in zone.tables) {
        await _saveTable(t.copyWith(zoneName: trimmed));
      }
    });
  }

  String _prefixForZone(_ZoneGroup zone) {
    if (zone.tables.isNotEmpty) {
      final name = zone.tables.first.name.trim();
      final m = RegExp(r'^([A-Za-z]+)').firstMatch(name);
      if (m != null && m.group(1)!.isNotEmpty) {
        return m.group(1)!.toUpperCase();
      }
    }
    final id = zone.zoneId.toLowerCase();
    if (id.contains('vip')) return 'V';
    if (id.contains('terrace')) return 'T';
    if (id.contains('bar')) return 'B';
    return zone.zoneName.isNotEmpty
        ? zone.zoneName.substring(0, 1).toUpperCase()
        : 'T';
  }

  int _nextTableNumber(_ZoneGroup zone, String prefix) {
    var max = 0;
    for (final t in zone.tables) {
      final m = RegExp(
        '^${RegExp.escape(prefix)}(\\d+)\$',
        caseSensitive: false,
      ).firstMatch(t.name.trim());
      if (m != null) {
        max = math.max(max, int.tryParse(m.group(1)!) ?? 0);
      }
    }
    return max + 1;
  }

  Future<void> _addTable(_ZoneGroup zone, List<BarTable> allTables) async {
    final branchId = _branchId;
    if (branchId == null) return;
    final prefix = _prefixForZone(zone);
    final num = _nextTableNumber(zone, prefix);
    final name = '$prefix$num';
    final maxOrdinal = allTables.isEmpty
        ? 0
        : allTables.map((t) => t.ordinal).reduce(math.max);
    final table = BarTable(
      id: '${branchId}_${zone.zoneId}_$name',
      branchId: branchId,
      zoneId: zone.zoneId,
      zoneName: zone.zoneName,
      name: name,
      seats: 2,
      ordinal: maxOrdinal + 1,
    );
    await _runBusy(() => _saveTable(table));
  }

  Future<void> _addZone() async {
    final branchId = _branchId;
    if (branchId == null) return;
    final name = await _promptZoneName(context);
    if (name == null || name.trim().isEmpty) return;
    final trimmed = name.trim();
    final zoneId =
        trimmed.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    final zone = _ZoneGroup(zoneId: zoneId, zoneName: trimmed, tables: const []);
    await _runBusy(() => _addTable(zone, ref.read(barTablesProvider).value ?? []));
  }

  Future<void> _deleteTable(
    BarTable table, {
    required Set<String> openTableIds,
  }) async {
    if (openTableIds.contains(table.id)) {
      _snack('Close the open tab on ${table.name} before deleting.');
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete table?'),
        content: Text('Remove ${table.name} from the floor plan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await _runBusy(
      () => _sync.deleteBarTable(id: table.id, branchId: table.branchId),
    );
    if (_selectedTableId == table.id) {
      setState(() => _selectedTableId = null);
    }
  }

  Future<void> _deleteZone(
    _ZoneGroup zone, {
    required Set<String> openTableIds,
  }) async {
    final openInZone =
        zone.tables.where((t) => openTableIds.contains(t.id)).toList();
    if (openInZone.isNotEmpty) {
      _snack(
        'Close open tabs in ${zone.zoneName} before deleting the zone.',
      );
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete zone?'),
        content: Text(
          'Remove ${zone.zoneName} and its ${zone.tables.length} tables?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete zone'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await _runBusy(() async {
      for (final t in zone.tables) {
        await _sync.deleteBarTable(id: t.id, branchId: t.branchId);
      }
    });
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tablesAsync = ref.watch(barTablesProvider);
    final tabsAsync = ref.watch(barTabsProvider);

    return tablesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('$e'),
      data: (tables) {
        final openIds = _openTableIds(tabsAsync.value ?? []);
        if (tables.isEmpty) {
          return BarCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No tables configured yet.',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: BarTokens.ink2,
                  ),
                ),
                const SizedBox(height: 14),
                BarPrimaryButton(
                  label: 'Load default floor plan',
                  icon: Icons.grid_view,
                  onPressed: _busy ? null : _seedDefaults,
                ),
              ],
            ),
          );
        }

        final zones = _groupZones(tables);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final zone in zones) ...[
              _ZoneCard(
                zone: zone,
                openTableIds: openIds,
                selectedTableId: _selectedTableId,
                busy: _busy,
                onSelect: (id) => setState(() => _selectedTableId = id),
                onRenameZone: (name) => _renameZone(zone, name),
                onDeleteZone: () => _deleteZone(zone, openTableIds: openIds),
                onAddTable: () => _addTable(zone, tables),
                onSaveTable: _saveTable,
                onDeleteTable: (t) =>
                    _deleteTable(t, openTableIds: openIds),
              ),
              const SizedBox(height: 14),
            ],
            _DashedAddButton(
              label: 'Add zone',
              onPressed: _busy ? null : _addZone,
            ),
          ],
        );
      },
    );
  }
}

class _ZoneCard extends StatelessWidget {
  const _ZoneCard({
    required this.zone,
    required this.openTableIds,
    required this.selectedTableId,
    required this.busy,
    required this.onSelect,
    required this.onRenameZone,
    required this.onDeleteZone,
    required this.onAddTable,
    required this.onSaveTable,
    required this.onDeleteTable,
  });

  final _ZoneGroup zone;
  final Set<String> openTableIds;
  final String? selectedTableId;
  final bool busy;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onRenameZone;
  final VoidCallback onDeleteZone;
  final VoidCallback onAddTable;
  final Future<void> Function(BarTable) onSaveTable;
  final Future<void> Function(BarTable) onDeleteTable;

  @override
  Widget build(BuildContext context) {
    return BarCard(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _ZoneNameField(
                  key: ValueKey('zone-name-${zone.zoneId}'),
                  initialName: zone.zoneName,
                  onSubmitted: onRenameZone,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${zone.tables.length} tables',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: BarTokens.ink3,
                ),
              ),
              IconButton(
                tooltip: 'Delete zone',
                onPressed: busy ? null : onDeleteZone,
                icon: Icon(Icons.delete_outline, color: BarTokens.ink3),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              const minTile = 280.0;
              final cols = math.max(
                1,
                (constraints.maxWidth / minTile).floor(),
              );
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 52,
                ),
                itemCount: zone.tables.length,
                itemBuilder: (context, i) {
                  final table = zone.tables[i];
                  return _TableRow(
                    key: ValueKey(table.id),
                    table: table,
                    isOpen: openTableIds.contains(table.id),
                    isSelected: selectedTableId == table.id,
                    enabled: !busy,
                    onTap: () => onSelect(table.id),
                    onSave: onSaveTable,
                    onDelete: () => onDeleteTable(table),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 12),
          _DashedAddButton(
            label: 'Add table',
            onPressed: busy ? null : onAddTable,
          ),
        ],
      ),
    );
  }
}

class _ZoneNameField extends StatefulWidget {
  const _ZoneNameField({
    super.key,
    required this.initialName,
    required this.onSubmitted,
  });

  final String initialName;
  final ValueChanged<String> onSubmitted;

  @override
  State<_ZoneNameField> createState() => _ZoneNameFieldState();
}

class _ZoneNameFieldState extends State<_ZoneNameField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void didUpdateWidget(covariant _ZoneNameField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialName != widget.initialName &&
        _controller.text != widget.initialName) {
      _controller.text = widget.initialName;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: GoogleFonts.outfit(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.01,
        color: BarTokens.ink1,
      ),
      decoration: const InputDecoration(
        isDense: true,
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      onSubmitted: widget.onSubmitted,
      onEditingComplete: () => widget.onSubmitted(_controller.text),
    );
  }
}

class _TableRow extends StatefulWidget {
  const _TableRow({
    super.key,
    required this.table,
    required this.isOpen,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
    required this.onSave,
    required this.onDelete,
  });

  final BarTable table;
  final bool isOpen;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;
  final Future<void> Function(BarTable) onSave;
  final VoidCallback onDelete;

  @override
  State<_TableRow> createState() => _TableRowState();
}

class _TableRowState extends State<_TableRow> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.table.name);
  }

  @override
  void didUpdateWidget(covariant _TableRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.table.name != widget.table.name &&
        _nameController.text != widget.table.name) {
      _nameController.text = widget.table.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _commitName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || name == widget.table.name) return;
    await widget.onSave(widget.table.copyWith(name: name));
  }

  Future<void> _setSeats(int seats) async {
    final next = seats.clamp(1, 99);
    if (next == widget.table.seats) return;
    await widget.onSave(widget.table.copyWith(seats: next));
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.isOpen || widget.isSelected;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.enabled ? widget.onTap : null,
        borderRadius: BorderRadius.circular(BarTokens.radiusMd),
        child: Container(
          decoration: BoxDecoration(
            color: widget.isSelected ? BarTokens.blueTint : BarTokens.surface2,
            borderRadius: BorderRadius.circular(BarTokens.radiusMd),
            border: Border.all(
              color: accent ? BarTokens.blue : BarTokens.line,
              width: widget.isSelected ? 1.5 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (accent)
                  const ColoredBox(
                    color: BarTokens.blue,
                    child: SizedBox(width: 4),
                  ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: _nameController,
                    enabled: widget.enabled,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: BarTokens.ink1,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: BarTokens.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: BarTokens.line),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: BarTokens.line),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: BarTokens.blue),
                      ),
                    ),
                    onSubmitted: (_) => _commitName(),
                    onEditingComplete: _commitName,
                  ),
                ),
              ),
              _SeatStepper(
                seats: widget.table.seats,
                enabled: widget.enabled,
                onChanged: _setSeats,
              ),
              if (widget.isOpen)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.shield_outlined,
                    size: 16,
                    color: BarTokens.blue,
                  ),
                ),
              IconButton(
                tooltip: 'Delete table',
                onPressed: widget.enabled ? widget.onDelete : null,
                icon: Icon(Icons.close, size: 18, color: BarTokens.ink3),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SeatStepper extends StatelessWidget {
  const _SeatStepper({
    required this.seats,
    required this.enabled,
    required this.onChanged,
  });

  final int seats;
  final bool enabled;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: BarTokens.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: BarTokens.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepBtn(
            icon: Icons.remove,
            enabled: enabled && seats > 1,
            onTap: () => onChanged(seats - 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$seats',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: BarTokens.ink1,
                  ),
                ),
                Text(
                  'SEATS',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: BarTokens.ink4,
                  ),
                ),
              ],
            ),
          ),
          _StepBtn(
            icon: Icons.add,
            enabled: enabled && seats < 99,
            onTap: () => onChanged(seats + 1),
          ),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: 28,
          height: 28,
          child: Icon(
            icon,
            size: 16,
            color: enabled ? BarTokens.ink2 : BarTokens.ink4,
          ),
        ),
      ),
    );
  }
}

class _DashedAddButton extends StatelessWidget {
  const _DashedAddButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(BarTokens.radiusMd),
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: onPressed == null ? BarTokens.line : BarTokens.lineStrong,
            radius: BarTokens.radiusMd,
          ),
          child: Container(
            width: double.infinity,
            height: 46,
            alignment: Alignment.center,
            child: Text(
              '+ $label',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: onPressed == null ? BarTokens.ink4 : BarTokens.ink2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    const dash = 6.0;
    const gap = 4.0;
    for (final metric in path.computeMetrics()) {
      var dist = 0.0;
      while (dist < metric.length) {
        final end = math.min(dist + dash, metric.length);
        canvas.drawPath(metric.extractPath(dist, end), paint);
        dist += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}

Future<String?> _promptZoneName(BuildContext context) {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Add zone'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Zone name',
          hintText: 'e.g. Patio',
        ),
        onSubmitted: (v) => Navigator.pop(ctx, v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, controller.text),
          child: const Text('Add'),
        ),
      ],
    ),
  );
}
