import 'package:flipper_models/daily_report_download_client.dart';
import 'package:flipper_models/models/daily_report_file.dart';
import 'package:flipper_models/providers/daily_report_files_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';

class DailyReportFilesScreen extends ConsumerStatefulWidget {
  const DailyReportFilesScreen({super.key});

  @override
  ConsumerState<DailyReportFilesScreen> createState() =>
      _DailyReportFilesScreenState();
}

class _DailyReportFilesScreenState extends ConsumerState<DailyReportFilesScreen> {
  static const Color _bg = Color(0xFFF4F6FB);
  static const Color _border = Color(0xFFEAECEF);
  static const Color _blue = Color(0xFF2563EB);

  // Use a row-unique key (not only `id`) because some Ditto rows can share IDs
  // (e.g. migrated docs missing `_id`/`id`, or repeated exports).
  final Set<String> _selectedKeys = {};
  bool _batchBusy = false;
  String? _singleBusyId;
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _toggleAll(List<DailyReportFile> files, {required bool select}) {
    setState(() {
      _selectedKeys.clear();
      if (select) {
        _selectedKeys.addAll(files.map(_rowKey));
      }
    });
  }

  String _rowKey(DailyReportFile f) {
    final created = f.createdAt?.toUtc().toIso8601String() ?? '';
    final key = (f.s3ObjectKey ?? '').trim();
    final id = f.id.trim();
    return '$id|$created|$key';
  }

  List<DailyReportFile> _applySearch(List<DailyReportFile> files) {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return files;
    return files.where((f) {
      final name = (f.fileName ?? '').toLowerCase();
      final day = (f.day ?? '').toLowerCase();
      final key = (f.s3ObjectKey ?? '').toLowerCase();
      return name.contains(q) || day.contains(q) || key.contains(q);
    }).toList(growable: false);
  }

  Future<void> _download(
    DailyReportFile file, {
    required bool openAfterSave,
  }) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null || branchId.isEmpty) {
      showCustomSnackBarUtil(
        context,
        'No active branch.',
        type: NotificationType.error,
      );
      return;
    }
    final key = file.s3ObjectKey?.trim();
    if (key == null || key.isEmpty) {
      showCustomSnackBarUtil(
        context,
        'This file has no storage key yet.',
        type: NotificationType.error,
      );
      return;
    }

    final ebm = await ProxyService.strategy.ebm(
      branchId: branchId,
      fetchRemote: false,
    );

    await downloadDailyReportExcel(
      branchId: branchId,
      objectKey: key,
      dataConnectorUrl: ebm?.dataConnectorUrl,
      openAfterSave: openAfterSave,
    );
  }

  Future<void> _onDownloadOne(DailyReportFile file) async {
    setState(() => _singleBusyId = _rowKey(file));
    try {
      await _download(file, openAfterSave: true);
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          'Saved ${file.fileName ?? "report"}',
          type: NotificationType.success,
        );
      }
    } on DailyReportDownloadException catch (e) {
      if (mounted) {
        showCustomSnackBarUtil(context, e.message, type: NotificationType.error);
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          e.toString(),
          type: NotificationType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _singleBusyId = null);
    }
  }

  Future<void> _onDownloadSelected(List<DailyReportFile> all) async {
    final selected =
        all.where((f) => _selectedKeys.contains(_rowKey(f))).toList(growable: false);
    if (selected.isEmpty) return;

    setState(() => _batchBusy = true);
    try {
      for (var i = 0; i < selected.length; i++) {
        final last = i == selected.length - 1;
        await _download(selected[i], openAfterSave: last);
      }
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          'Downloaded ${selected.length} file(s)',
          type: NotificationType.success,
        );
      }
    } on DailyReportDownloadException catch (e) {
      if (mounted) {
        showCustomSnackBarUtil(context, e.message, type: NotificationType.error);
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          e.toString(),
          type: NotificationType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _batchBusy = false;
          _selectedKeys.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final branchId = ProxyService.box.getBranchId() ?? '';
    final filesAsync = ref.watch(dailyReportFilesProvider(branchId));

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 12,
        automaticallyImplyLeading: false,
        toolbarHeight: 72,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(58),
          child: Column(
            children: [
              Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          controller: _search,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Search files (date, name, key)…',
                            hintStyle: GoogleFonts.outfit(color: Colors.black45),
                            prefixIcon: const Icon(Icons.search_rounded, size: 20),
                            filled: true,
                            fillColor: const Color(0xFFF7F8FA),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade200),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: _blue.withValues(alpha: 0.5)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      tooltip: 'Refresh',
                      onPressed: () =>
                          ref.invalidate(dailyReportFilesProvider(branchId)),
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Daily Reports',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            Text(
              branchId.isEmpty
                  ? 'Select a branch'
                  : 'Excel files generated for this branch',
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.icon(
              onPressed: _batchBusy || _selectedKeys.isEmpty
                  ? null
                  : () {
                      final async = ref.read(dailyReportFilesProvider(branchId));
                      final list = async.asData?.value ??
                          const <DailyReportFile>[];
                      _onDownloadSelected(list);
                    },
              style: FilledButton.styleFrom(
                backgroundColor: _blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: _batchBusy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.download_rounded, size: 20),
              label: Text(
                'Download selected',
                style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: branchId.isEmpty
          ? _EmptyState(
              title: 'No branch selected',
              message: 'Select a branch to see the daily Excel exports.',
              primaryLabel: 'Refresh',
              onPrimary: () =>
                  ref.invalidate(dailyReportFilesProvider(branchId)),
            )
          : filesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => _EmptyState(
                title: 'Could not load reports',
                message: 'Check your connection and try again.',
                primaryLabel: 'Retry',
                onPrimary: () =>
                    ref.invalidate(dailyReportFilesProvider(branchId)),
              ),
              data: (files) {
                final visible = _applySearch(files);
                if (files.isEmpty) {
                  return _EmptyState(
                    title: 'No daily reports yet',
                    message:
                        'When reports are generated for this branch, they’ll appear here for download.',
                    primaryLabel: 'Refresh',
                    onPrimary: () =>
                        ref.invalidate(dailyReportFilesProvider(branchId)),
                  );
                }

                if (visible.isEmpty) {
                  return _EmptyState(
                    title: 'No matches',
                    message: 'Try a different search term.',
                    primaryLabel: 'Clear search',
                    onPrimary: () => setState(() => _search.clear()),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(dailyReportFilesProvider(branchId));
                    await Future<void>.delayed(const Duration(milliseconds: 150));
                  },
                  child: _GroupedFileList(
                    files: visible,
                    selectedKeys: _selectedKeys,
                    busyAll: _batchBusy,
                    busyId: _singleBusyId,
                    rowKeyOf: _rowKey,
                    onToggle: (id) {
                      setState(() {
                        if (_selectedKeys.contains(id)) {
                          _selectedKeys.remove(id);
                        } else {
                          _selectedKeys.add(id);
                        }
                      });
                    },
                    onDownload: (f) => _onDownloadOne(f),
                    onSelectAll: () => _toggleAll(visible, select: true),
                    onClearSelection: () => _toggleAll(visible, select: false),
                  ),
                );
              },
            ),
    );
  }
}

class _GroupedFileList extends StatelessWidget {
  const _GroupedFileList({
    required this.files,
    required this.selectedKeys,
    required this.busyAll,
    required this.busyId,
    required this.rowKeyOf,
    required this.onToggle,
    required this.onDownload,
    required this.onSelectAll,
    required this.onClearSelection,
  });

  final List<DailyReportFile> files;
  final Set<String> selectedKeys;
  final bool busyAll;
  final String? busyId;
  final String Function(DailyReportFile) rowKeyOf;
  final void Function(String id) onToggle;
  final void Function(DailyReportFile file) onDownload;
  final VoidCallback onSelectAll;
  final VoidCallback onClearSelection;

  static final _dfHeader = DateFormat.yMMMMd();

  String _groupKey(DailyReportFile f) {
    final day = (f.day ?? '').trim();
    if (day.isNotEmpty) return day;
    final created = f.createdAt;
    if (created != null) {
      final d = created.toLocal();
      return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    }
    return 'Unknown date';
  }

  String _prettyGroupLabel(String key) {
    final dt = DateTime.tryParse(key);
    if (dt != null) return _dfHeader.format(dt);
    return key;
  }

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<DailyReportFile>>{};
    for (final f in files) {
      groups.putIfAbsent(_groupKey(f), () => <DailyReportFile>[]).add(f);
    }
    final orderedKeys = groups.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    final allSelected =
        files.isNotEmpty && files.every((f) => selectedKeys.contains(rowKeyOf(f)));
    final selectionLabel = selectedKeys.isEmpty
        ? '${files.length} file(s)'
        : '${selectedKeys.length} selected';

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      children: [
        _CommandBar(
          label: selectionLabel,
          allSelected: allSelected,
          onSelectAll: onSelectAll,
          onClearSelection: onClearSelection,
        ),
        const SizedBox(height: 14),
        for (final key in orderedKeys) ...[
          _GroupHeader(title: _prettyGroupLabel(key)),
          const SizedBox(height: 10),
          ...groups[key]!.map((f) {
            final rowKey = rowKeyOf(f);
            final isSelected = selectedKeys.contains(rowKey);
            final busy = busyAll ? isSelected : (busyId == rowKey);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _FileCard(
                file: f,
                selected: isSelected,
                busy: busy,
                onToggle: () => onToggle(rowKey),
                onDownload: () => onDownload(f),
              ),
            );
          }),
          const SizedBox(height: 6),
        ],
      ],
    );
  }
}

class _CommandBar extends StatelessWidget {
  const _CommandBar({
    required this.label,
    required this.allSelected,
    required this.onSelectAll,
    required this.onClearSelection,
  });

  final String label;
  final bool allSelected;
  final VoidCallback onSelectAll;
  final VoidCallback onClearSelection;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: _DailyReportFilesScreenState._border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: allSelected ? onClearSelection : onSelectAll,
              icon: Icon(
                allSelected
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank_rounded,
                size: 18,
              ),
              label: Text(
                allSelected ? 'Clear' : 'Select all',
                style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
  });

  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 84,
                height: 84,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _DailyReportFilesScreenState._border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: AdminDashboardSvgs.picture(
                  AdminDashboardSvgs.dailyReportsExcel,
                  size: 64,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  height: 1.35,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onPrimary,
                style: FilledButton.styleFrom(
                  backgroundColor: _DailyReportFilesScreenState._blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(
                  primaryLabel,
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Tip: pull down to refresh when you have files.',
                style: GoogleFonts.outfit(fontSize: 12, color: Colors.black45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FileCard extends StatelessWidget {
  const _FileCard({
    required this.file,
    required this.selected,
    required this.busy,
    required this.onToggle,
    required this.onDownload,
  });

  final DailyReportFile file;
  final bool selected;
  final bool busy;
  final VoidCallback onToggle;
  final VoidCallback onDownload;

  static final _df = DateFormat.yMMMd().add_jm();

  @override
  Widget build(BuildContext context) {
    final name = file.fileName ?? file.day ?? file.id;
    final day = file.day;
    final created = file.createdAt;

    String subtitle = '';
    if (day != null && day.isNotEmpty) {
      subtitle = 'Day $day';
    }
    if (created != null) {
      if (subtitle.isNotEmpty) subtitle += ' · ';
      subtitle += _df.format(created.toLocal());
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: busy ? null : onToggle,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: _DailyReportFilesScreenState._border),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Checkbox(
                value: selected,
                onChanged: busy ? null : (_) => onToggle(),
              ),
              const SizedBox(width: 4),
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FAF8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _DailyReportFilesScreenState._border,
                  ),
                ),
                child: AdminDashboardSvgs.picture(
                  AdminDashboardSvgs.dailyReportsExcel,
                  size: 38,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Download',
                onPressed: busy ? null : onDownload,
                icon: busy
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.download_rounded, color: Colors.grey.shade800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
