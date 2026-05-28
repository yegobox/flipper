import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flipper_models/daily_report_download_client.dart';
import 'package:flipper_models/models/daily_report_file.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/daily_report_files_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flipper_dashboard/widgets/dashboard_quick_access_svgs.dart';

class DailyReportFilesScreen extends ConsumerStatefulWidget {
  const DailyReportFilesScreen({super.key});

  @override
  ConsumerState<DailyReportFilesScreen> createState() =>
      _DailyReportFilesScreenState();
}

class _DailyReportFilesScreenState
    extends ConsumerState<DailyReportFilesScreen> {
  static const Color _bg = Color(0xFFF7F8FA);
  static const Color _ink = Color(0xFF151616);
  static const Color _muted = Color(0xFF7A7D78);
  static const Color _border = Color(0xFFE6E7E1);
  static const Color _accent = Color(0xFF006AFE);
  static const Color _green = Color(0xFF0F6F43);
  static const Color _greenSoft = Color(0xFFEFF8F2);
  static const Color _selected = Color(0xFFEAF3F0);

  // Use a row-unique key (not only `id`) because some Ditto rows can share IDs
  // (e.g. migrated docs missing `_id`/`id`, or repeated exports).
  final Set<String> _selectedKeys = {};
  bool _batchBusy = false;
  String? _singleBusyId;
  DailyReportFile? _previewFile;
  Future<DailyReportPreviewResponse>? _previewFuture;
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
    return files
        .where((f) {
          final name = (f.fileName ?? '').toLowerCase();
          final day = (f.day ?? '').toLowerCase();
          final key = (f.s3ObjectKey ?? '').toLowerCase();
          final runId = (f.runId ?? '').toLowerCase();
          final id = f.id.toLowerCase();
          return name.contains(q) ||
              day.contains(q) ||
              key.contains(q) ||
              runId.contains(q) ||
              id.contains(q);
        })
        .toList(growable: false);
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
        showCustomSnackBarUtil(
          context,
          e.message,
          type: NotificationType.error,
        );
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

  Future<DailyReportPreviewResponse> _loadPreview(DailyReportFile file) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null || branchId.isEmpty) {
      throw DailyReportDownloadException('No active branch.');
    }
    final key = file.s3ObjectKey?.trim();
    if (key == null || key.isEmpty) {
      throw DailyReportDownloadException('This file has no storage key yet.');
    }
    final ebm = await ProxyService.strategy.ebm(
      branchId: branchId,
      fetchRemote: false,
    );
    return previewDailyReportExcel(
      branchId: branchId,
      objectKey: key,
      dataConnectorUrl: ebm?.dataConnectorUrl,
    );
  }

  void _openPreview(DailyReportFile file) {
    setState(() {
      _previewFile = file;
      _previewFuture = _loadPreview(file);
    });
  }

  void _closePreview() {
    setState(() {
      _previewFile = null;
      _previewFuture = null;
    });
  }

  Future<void> _onDownloadSelected(List<DailyReportFile> all) async {
    final selected = all
        .where((f) => _selectedKeys.contains(_rowKey(f)))
        .toList(growable: false);
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
        showCustomSnackBarUtil(
          context,
          e.message,
          type: NotificationType.error,
        );
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

  Future<void> _onMergeSelected(List<DailyReportFile> all) async {
    final selected = all
        .where((f) => _selectedKeys.contains(_rowKey(f)))
        .toList(growable: false);
    if (selected.length < 2) return;

    final objectKeys = selected
        .map((f) => f.s3ObjectKey?.trim() ?? '')
        .where((key) => key.isNotEmpty)
        .toList(growable: false);
    if (objectKeys.length != selected.length) {
      showCustomSnackBarUtil(
        context,
        'Every selected report must have a storage key before merging.',
        type: NotificationType.error,
      );
      return;
    }

    final branchId = ProxyService.box.getBranchId();
    if (branchId == null || branchId.isEmpty) {
      showCustomSnackBarUtil(
        context,
        'No active branch.',
        type: NotificationType.error,
      );
      return;
    }

    setState(() => _batchBusy = true);
    try {
      final ebm = await ProxyService.strategy.ebm(
        branchId: branchId,
        fetchRemote: false,
      );
      await mergeAndDownloadDailyReportExcels(
        branchId: branchId,
        objectKeys: objectKeys,
        dataConnectorUrl: ebm?.dataConnectorUrl,
      );
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          'Merged ${selected.length} reports',
          type: NotificationType.success,
        );
      }
    } on DailyReportDownloadException catch (e) {
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          e.message,
          type: NotificationType.error,
        );
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

  String _branchName(String branchId) {
    final activeBranch = ref.watch(activeBranchProvider);
    return activeBranch.maybeWhen(
      data: (branch) {
        final name = (branch.name ?? '').trim();
        return name.isEmpty ? 'Current Branch' : name;
      },
      orElse: () => branchId.isEmpty ? 'No Branch' : 'Current Branch',
    );
  }

  @override
  Widget build(BuildContext context) {
    final branchId = ProxyService.box.getBranchId() ?? '';
    final branchName = _branchName(branchId);
    final filesAsync = ref.watch(dailyReportFilesProvider(branchId));

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: branchId.isEmpty
            ? _Shell(
                branchName: branchName,
                files: const <DailyReportFile>[],
                visibleFiles: const <DailyReportFile>[],
                selectedKeys: _selectedKeys,
                batchBusy: _batchBusy,
                search: _search,
                onSearchChanged: (_) => setState(() {}),
                onSelectAll: () {},
                onClearSelection: () {},
                onRefresh: () =>
                    ref.invalidate(dailyReportFilesProvider(branchId)),
                onDownloadSelected: null,
                onMergeSelected: null,
                child: _EmptyState(
                  title: 'No branch selected',
                  message: 'Select a branch to see the daily Excel exports.',
                  primaryLabel: 'Refresh',
                  onPrimary: () =>
                      ref.invalidate(dailyReportFilesProvider(branchId)),
                ),
              )
            : filesAsync.when(
                loading: () => _Shell(
                  branchName: branchName,
                  files: const <DailyReportFile>[],
                  visibleFiles: const <DailyReportFile>[],
                  selectedKeys: _selectedKeys,
                  batchBusy: _batchBusy,
                  search: _search,
                  onSearchChanged: (_) => setState(() {}),
                  onSelectAll: () {},
                  onClearSelection: () {},
                  onRefresh: () =>
                      ref.invalidate(dailyReportFilesProvider(branchId)),
                  onDownloadSelected: null,
                  onMergeSelected: null,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => _Shell(
                  branchName: branchName,
                  files: const <DailyReportFile>[],
                  visibleFiles: const <DailyReportFile>[],
                  selectedKeys: _selectedKeys,
                  batchBusy: _batchBusy,
                  search: _search,
                  onSearchChanged: (_) => setState(() {}),
                  onSelectAll: () {},
                  onClearSelection: () {},
                  onRefresh: () =>
                      ref.invalidate(dailyReportFilesProvider(branchId)),
                  onDownloadSelected: null,
                  onMergeSelected: null,
                  child: _EmptyState(
                    title: 'Could not load reports',
                    message: 'Check your connection and try again.',
                    primaryLabel: 'Retry',
                    onPrimary: () =>
                        ref.invalidate(dailyReportFilesProvider(branchId)),
                  ),
                ),
                data: (files) {
                  final visible = _applySearch(files);
                  return _Shell(
                    branchName: branchName,
                    files: files,
                    visibleFiles: visible,
                    selectedKeys: _selectedKeys,
                    batchBusy: _batchBusy,
                    search: _search,
                    onSearchChanged: (_) => setState(() {}),
                    onSelectAll: () => _toggleAll(visible, select: true),
                    onClearSelection: () => _toggleAll(visible, select: false),
                    onRefresh: () =>
                        ref.invalidate(dailyReportFilesProvider(branchId)),
                    onDownloadSelected: _selectedKeys.isEmpty
                        ? null
                        : () => _onDownloadSelected(files),
                    onMergeSelected: _selectedKeys.length < 2
                        ? null
                        : () => _onMergeSelected(files),
                    previewFile: _previewFile,
                    previewFuture: _previewFuture,
                    onClosePreview: _closePreview,
                    onDownloadPreview: _previewFile == null
                        ? null
                        : () => _onDownloadOne(_previewFile!),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(dailyReportFilesProvider(branchId));
                        await Future<void>.delayed(
                          const Duration(milliseconds: 150),
                        );
                      },
                      child: visible.isEmpty
                          ? ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * .36,
                                  child: _EmptyState(
                                    title: files.isEmpty
                                        ? 'No daily reports yet'
                                        : 'No matches',
                                    message: files.isEmpty
                                        ? 'When reports are generated for this branch, they will appear here for download.'
                                        : 'Try a different report name, date, or ID.',
                                    primaryLabel: files.isEmpty
                                        ? 'Refresh'
                                        : 'Clear search',
                                    onPrimary: files.isEmpty
                                        ? () => ref.invalidate(
                                            dailyReportFilesProvider(branchId),
                                          )
                                        : () => setState(() => _search.clear()),
                                  ),
                                ),
                              ],
                            )
                          : _GroupedFileList(
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
                              onPreview: _openPreview,
                              onSelectAll: () =>
                                  _toggleAll(visible, select: true),
                              onClearSelection: () =>
                                  _toggleAll(visible, select: false),
                            ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _Shell extends StatelessWidget {
  const _Shell({
    required this.branchName,
    required this.files,
    required this.visibleFiles,
    required this.selectedKeys,
    required this.batchBusy,
    required this.search,
    required this.onSearchChanged,
    required this.onSelectAll,
    required this.onClearSelection,
    required this.onRefresh,
    required this.onDownloadSelected,
    required this.onMergeSelected,
    required this.child,
    this.previewFile,
    this.previewFuture,
    this.onClosePreview,
    this.onDownloadPreview,
  });

  final String branchName;
  final List<DailyReportFile> files;
  final List<DailyReportFile> visibleFiles;
  final Set<String> selectedKeys;
  final bool batchBusy;
  final TextEditingController search;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSelectAll;
  final VoidCallback onClearSelection;
  final VoidCallback onRefresh;
  final VoidCallback? onDownloadSelected;
  final VoidCallback? onMergeSelected;
  final DailyReportFile? previewFile;
  final Future<DailyReportPreviewResponse>? previewFuture;
  final VoidCallback? onClosePreview;
  final VoidCallback? onDownloadPreview;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.sizeOf(context).width < 720
        ? 18.0
        : 36.0;

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroHeader(branchName: branchName, onRefresh: onRefresh),
                    const SizedBox(height: 28),
                    _KpiStrip(files: files),
                    const SizedBox(height: 20),
                    _ListFrame(
                      files: visibleFiles,
                      allFiles: files,
                      selectedCount: selectedKeys.length,
                      search: search,
                      onSearchChanged: onSearchChanged,
                      onSelectAll: onSelectAll,
                      onClearSelection: onClearSelection,
                      onRefresh: onRefresh,
                      child: Expanded(child: child),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (selectedKeys.isNotEmpty)
          _SelectionBar(
            selectedCount: selectedKeys.length,
            busy: batchBusy,
            onDownload: onDownloadSelected,
            onMerge: onMergeSelected,
            onClose: onClearSelection,
          ),
        if (previewFile != null && previewFuture != null)
          _PreviewOverlay(
            file: previewFile!,
            previewFuture: previewFuture!,
            onClose: onClosePreview ?? () {},
            onDownload: onDownloadPreview,
          ),
      ],
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.branchName, required this.onRefresh});

  final String branchName;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 860;
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Reports',
          style: GoogleFonts.outfit(
            color: _DailyReportFilesScreenState._ink,
            fontSize: 34,
            height: 1.05,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text.rich(
            TextSpan(
              text: 'Excel exports generated for ',
              children: [
                TextSpan(
                  text: branchName,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const TextSpan(
                  text: '. Select multiple files to download together.',
                ),
              ],
            ),
            style: GoogleFonts.outfit(
              color: const Color(0xFF5F625D),
              fontSize: 16,
              height: 1.42,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(top: 26),
      child: Flex(
        direction: compact ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: compact
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          if (compact) titleBlock else Expanded(child: titleBlock),
          SizedBox(width: compact ? 0 : 16, height: compact ? 16 : 0),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeaderButton(
                icon: DashboardQuickAccessSvgs.calendar,
                label: 'Last 7 days',
                trailing: DashboardQuickAccessSvgs.chevronDown,
                onTap: () {},
              ),
              _HeaderButton(
                icon: DashboardQuickAccessSvgs.sparkle,
                label: 'Generate report',
                filled: true,
                onTap: onRefresh,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.filled = false,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final String? trailing;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? _DailyReportFilesScreenState._ink : Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: filled
                  ? _DailyReportFilesScreenState._ink
                  : _DailyReportFilesScreenState._border,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: filled ? .12 : .04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DashboardQuickAccessSvgs.assetIcon(
                icon,
                size: 18,
                color: filled
                    ? Colors.white
                    : _DailyReportFilesScreenState._ink,
              ),
              const SizedBox(width: 9),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: filled
                      ? Colors.white
                      : _DailyReportFilesScreenState._ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                DashboardQuickAccessSvgs.assetIcon(
                  trailing!,
                  size: 18,
                  color: filled
                      ? Colors.white
                      : _DailyReportFilesScreenState._ink,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _KpiStrip extends StatelessWidget {
  const _KpiStrip({required this.files});

  final List<DailyReportFile> files;

  static final _time = DateFormat.jm();

  @override
  Widget build(BuildContext context) {
    final days = files
        .map((f) => (f.day ?? '').trim())
        .where((day) => day.isNotEmpty)
        .toSet()
        .length;
    final latest = files
        .where((f) => f.createdAt != null)
        .map((f) => f.createdAt!)
        .fold<DateTime?>(null, (a, b) => a == null || b.isAfter(a) ? b : a);
    final ready = files
        .where((f) => (f.s3ObjectKey ?? '').trim().isNotEmpty)
        .length;

    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _DailyReportFilesScreenState._border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _KpiCell(
              label: 'FILES',
              value: NumberFormat.decimalPattern().format(files.length),
              caption: files.isEmpty ? 'none yet' : 'available',
            ),
          ),
          const _VerticalRule(),
          Expanded(
            child: _KpiCell(
              label: 'REPORT DAYS',
              value: NumberFormat.decimalPattern().format(days),
              caption: days == 1 ? 'day grouped' : 'days grouped',
            ),
          ),
          const _VerticalRule(),
          Expanded(
            child: _KpiCell(
              label: 'READY FILES',
              value: NumberFormat.decimalPattern().format(ready),
              caption: 'with storage keys',
            ),
          ),
          const _VerticalRule(),
          Expanded(
            child: _KpiCell(
              label: 'LAST GENERATED',
              value: latest == null ? '--' : _time.format(latest.toLocal()),
              caption: latest == null ? 'No exports' : _relativeDay(latest),
            ),
          ),
        ],
      ),
    );
  }

  static String _relativeDay(DateTime date) {
    final local = date.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(local.year, local.month, local.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return DateFormat.MMMd().format(local);
  }
}

class _KpiCell extends StatelessWidget {
  const _KpiCell({
    required this.label,
    required this.value,
    required this.caption,
  });

  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              color: _DailyReportFilesScreenState._muted,
              fontSize: 13,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              color: _DailyReportFilesScreenState._ink,
              fontSize: 30,
              height: 1,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            caption,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              color: _DailyReportFilesScreenState._muted,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalRule extends StatelessWidget {
  const _VerticalRule();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: double.infinity,
      child: VerticalDivider(
        width: 1,
        thickness: 1,
        color: _DailyReportFilesScreenState._border,
      ),
    );
  }
}

class _ListFrame extends StatelessWidget {
  const _ListFrame({
    required this.files,
    required this.allFiles,
    required this.selectedCount,
    required this.search,
    required this.onSearchChanged,
    required this.onSelectAll,
    required this.onClearSelection,
    required this.onRefresh,
    required this.child,
  });

  final List<DailyReportFile> files;
  final List<DailyReportFile> allFiles;
  final int selectedCount;
  final TextEditingController search;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSelectAll;
  final VoidCallback onClearSelection;
  final VoidCallback onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _DailyReportFilesScreenState._border),
        ),
        child: Column(
          children: [
            Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _DailyReportFilesScreenState._border,
                  ),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 26,
                    height: 26,
                    child: Checkbox(
                      value: selectedCount > 0,
                      onChanged: (_) => selectedCount > 0
                          ? onClearSelection()
                          : onSelectAll(),
                      activeColor: _DailyReportFilesScreenState._ink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    selectedCount > 0
                        ? '$selectedCount selected'
                        : '${allFiles.length} files',
                    style: GoogleFonts.outfit(
                      color: _DailyReportFilesScreenState._ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  if (selectedCount > 0)
                    TextButton(
                      onPressed: onClearSelection,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF5F625D),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 36),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Clear selection',
                        style: GoogleFonts.outfit(
                          decoration: TextDecoration.underline,
                          decorationColor: const Color(0xFF5F625D),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(width: 18),
                  DashboardQuickAccessSvgs.assetIcon(
                    DashboardQuickAccessSvgs.clock,
                    size: 17,
                    color: _DailyReportFilesScreenState._muted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Auto-syncs every 5 min',
                    style: GoogleFonts.outfit(
                      color: _DailyReportFilesScreenState._muted,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 68,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFFFBFCFB),
                border: Border(
                  bottom: BorderSide(
                    color: _DailyReportFilesScreenState._border,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: search,
                      onChanged: onSearchChanged,
                      style: GoogleFonts.outfit(
                        color: _DailyReportFilesScreenState._ink,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search by report name, date, or ID...',
                        hintStyle: GoogleFonts.outfit(
                          color: _DailyReportFilesScreenState._muted,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(13),
                          child: DashboardQuickAccessSvgs.assetIcon(
                            DashboardQuickAccessSvgs.search,
                            size: 20,
                            color: _DailyReportFilesScreenState._muted,
                          ),
                        ),
                        suffixIcon: Container(
                          width: 42,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F4F0),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _DailyReportFilesScreenState._border,
                            ),
                          ),
                          child: Text(
                            '#K',
                            style: GoogleFonts.outfit(
                              color: _DailyReportFilesScreenState._muted,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: _outline(),
                        enabledBorder: _outline(),
                        focusedBorder: _outline(
                          color: _DailyReportFilesScreenState._accent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _ToolChip(
                    icon: DashboardQuickAccessSvgs.filter,
                    label: 'Type:',
                    value: 'All',
                  ),
                  const SizedBox(width: 8),
                  const _ToolChip(
                    icon: DashboardQuickAccessSvgs.sortDesc,
                    label: 'Sort:',
                    value: 'Newest first',
                  ),
                  const SizedBox(width: 8),
                  const _ToolChip(
                    icon: DashboardQuickAccessSvgs.group,
                    label: '',
                    value: 'Group by day',
                    filled: true,
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    tooltip: 'Refresh',
                    onPressed: onRefresh,
                    icon: DashboardQuickAccessSvgs.assetIcon(
                      DashboardQuickAccessSvgs.refresh,
                      color: _DailyReportFilesScreenState._ink,
                    ),
                  ),
                ],
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _outline({
    Color color = _DailyReportFilesScreenState._border,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color),
    );
  }
}

class _ToolChip extends StatelessWidget {
  const _ToolChip({
    required this.icon,
    required this.label,
    required this.value,
    this.filled = false,
  });

  final String icon;
  final String label;
  final String value;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: filled ? _DailyReportFilesScreenState._ink : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: filled
              ? _DailyReportFilesScreenState._ink
              : _DailyReportFilesScreenState._border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DashboardQuickAccessSvgs.assetIcon(
            icon,
            size: 18,
            color: filled ? Colors.white : _DailyReportFilesScreenState._ink,
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: _DailyReportFilesScreenState._muted,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(width: 5),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: filled ? Colors.white : _DailyReportFilesScreenState._ink,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (!filled) ...[
            const SizedBox(width: 5),
            DashboardQuickAccessSvgs.assetIcon(
              DashboardQuickAccessSvgs.chevronDown,
              size: 18,
              color: _DailyReportFilesScreenState._ink,
            ),
          ],
        ],
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
    required this.onPreview,
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
  final void Function(DailyReportFile file) onPreview;
  final VoidCallback onSelectAll;
  final VoidCallback onClearSelection;

  static final _dfHeader = DateFormat('MMM dd, yyyy');

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
    if (dt != null) return _dfHeader.format(dt).toUpperCase();
    return key.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<DailyReportFile>>{};
    for (final f in files) {
      groups.putIfAbsent(_groupKey(f), () => <DailyReportFile>[]).add(f);
    }
    final orderedKeys = groups.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView(
      padding: const EdgeInsets.only(bottom: 112),
      children: [
        for (final key in orderedKeys) ...[
          _GroupHeader(
            title: _prettyGroupLabel(key),
            count: groups[key]!.length,
          ),
          ...groups[key]!.map((f) {
            final rowKey = rowKeyOf(f);
            final isSelected = selectedKeys.contains(rowKey);
            final busy = busyAll ? isSelected : (busyId == rowKey);
            return _FileRow(
              file: f,
              selected: isSelected,
              busy: busy,
              onToggle: () => onToggle(rowKey),
              onDownload: () => onDownload(f),
              onPreview: () => onPreview(f),
            );
          }),
        ],
      ],
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: _DailyReportFilesScreenState._border),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              color: const Color(0xFF555852),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 26,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFBFCFB),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _DailyReportFilesScreenState._border),
            ),
            child: Text(
              'Today',
              style: GoogleFonts.outfit(
                color: _DailyReportFilesScreenState._muted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Spacer(),
          Text(
            '$count ${count == 1 ? 'file' : 'files'}',
            style: GoogleFonts.outfit(
              color: _DailyReportFilesScreenState._muted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FileRow extends StatelessWidget {
  const _FileRow({
    required this.file,
    required this.selected,
    required this.busy,
    required this.onToggle,
    required this.onDownload,
    required this.onPreview,
  });

  final DailyReportFile file;
  final bool selected;
  final bool busy;
  final VoidCallback onToggle;
  final VoidCallback onDownload;
  final VoidCallback onPreview;

  static final _time = DateFormat.jm();

  @override
  Widget build(BuildContext context) {
    final name = _displayName(file);
    final created = file.createdAt;
    final id = _shortId(file);
    final category = _category(file);

    return Material(
      color: selected ? _DailyReportFilesScreenState._selected : Colors.white,
      child: InkWell(
        onTap: busy ? null : onPreview,
        child: Container(
          height: 104,
          decoration: BoxDecoration(
            border: selected
                ? const Border(
                    left: BorderSide(
                      color: _DailyReportFilesScreenState._green,
                      width: 3,
                    ),
                    bottom: BorderSide(
                      color: _DailyReportFilesScreenState._border,
                    ),
                  )
                : const Border(
                    bottom: BorderSide(
                      color: _DailyReportFilesScreenState._border,
                    ),
                  ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              Checkbox(
                value: selected,
                onChanged: busy ? null : (_) => onToggle(),
                activeColor: _DailyReportFilesScreenState._ink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFDDECE2)),
                ),
                child: DashboardQuickAccessSvgs.assetIcon(
                  DashboardQuickAccessSvgs.fileExcel,
                  size: 34,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              color: _DailyReportFilesScreenState._ink,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _CodePill(text: id),
                        const SizedBox(width: 8),
                        Text(
                          '.xlsx',
                          style: GoogleFonts.outfit(
                            color: _DailyReportFilesScreenState._muted,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_isNew(file)) const _NewPill(compact: true),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          created == null
                              ? '--'
                              : _time.format(created.toLocal()),
                          style: _metaStyle(context, strong: true),
                        ),
                        const SizedBox(width: 10),
                        _Dot(),
                        const SizedBox(width: 10),
                        Text(
                          file.day ?? 'No report day',
                          style: _metaStyle(context),
                        ),
                        const SizedBox(width: 10),
                        _Dot(),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _metaStyle(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              _StatusPill(ready: (file.s3ObjectKey ?? '').trim().isNotEmpty),
              const SizedBox(width: 18),
              IconButton(
                tooltip: 'Preview',
                onPressed: busy ? null : onPreview,
                icon: DashboardQuickAccessSvgs.assetIcon(
                  DashboardQuickAccessSvgs.eye,
                  size: 20,
                  color: _DailyReportFilesScreenState._ink,
                ),
              ),
              IconButton(
                tooltip: 'Download',
                onPressed: busy ? null : onDownload,
                icon: busy
                    ? const SizedBox(
                        width: 19,
                        height: 19,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : DashboardQuickAccessSvgs.assetIcon(
                        DashboardQuickAccessSvgs.download,
                        size: 21,
                        color: _DailyReportFilesScreenState._green,
                      ),
              ),
              IconButton(
                tooltip: 'More',
                onPressed: () {},
                icon: DashboardQuickAccessSvgs.assetIcon(
                  DashboardQuickAccessSvgs.more,
                  size: 22,
                  color: _DailyReportFilesScreenState._ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _displayName(DailyReportFile file) {
    final raw = (file.fileName ?? file.type).trim();
    if (raw.isEmpty) return 'Daily Transactions';
    final lower = raw.toLowerCase();
    if (lower.contains('daily_transactions') ||
        lower.contains('daily transactions') ||
        file.type.toLowerCase().contains('transaction')) {
      return 'Daily Transactions';
    }
    if (lower.contains('sales_summary') || lower.contains('sales summary')) {
      return 'Sales Summary';
    }
    if (lower.contains('payments_breakdown') ||
        lower.contains('payments breakdown')) {
      return 'Payments Breakdown';
    }
    if (lower.contains('stock_movement') || lower.contains('stock movement')) {
      return 'Stock Movement';
    }
    final withoutExtension = raw.replaceAll(
      RegExp(r'\.xlsx$', caseSensitive: false),
      '',
    );
    final withoutDate = withoutExtension.replaceAll(
      RegExp(r'[\s_-]*\d{4}[\s_-]?\d{2}[\s_-]?\d{2}.*$'),
      '',
    );
    final withoutHash = withoutDate.replaceAll(
      RegExp(r'[\s_-]*[a-f0-9]{8,}.*$', caseSensitive: false),
      '',
    );
    final cleaned = withoutHash
        .replaceAll(RegExp(r'[_-]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (cleaned.isEmpty) return 'Daily Transactions';
    return cleaned
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  static String _shortId(DailyReportFile file) {
    final source = (file.runId ?? file.id).replaceAll('-', '').trim();
    if (source.isEmpty) return 'report';
    return source.length <= 8 ? source : source.substring(0, 8);
  }

  static String _category(DailyReportFile file) {
    if ((file.implementation ?? '').trim().isNotEmpty) {
      return file.implementation!.trim();
    }
    if (file.type.contains('transaction')) return 'Transactions';
    return 'Daily report';
  }

  static bool _isNew(DailyReportFile file) {
    final created = file.createdAt;
    if (created == null) return false;
    return DateTime.now().difference(created.toLocal()).inHours < 24;
  }

  static TextStyle _metaStyle(BuildContext context, {bool strong = false}) {
    return GoogleFonts.outfit(
      color: _DailyReportFilesScreenState._muted,
      fontSize: 14,
      fontWeight: strong ? FontWeight.w700 : FontWeight.w500,
    );
  }
}

class _Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '•',
      style: GoogleFonts.outfit(
        color: _DailyReportFilesScreenState._muted,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _CodePill extends StatelessWidget {
  const _CodePill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: _DailyReportFilesScreenState._border),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          color: const Color(0xFF60635F),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _NewPill extends StatelessWidget {
  const _NewPill({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? 24 : 28,
      padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _DailyReportFilesScreenState._green,
        borderRadius: BorderRadius.circular(compact ? 4 : 16),
      ),
      child: Text(
        'NEW',
        style: GoogleFonts.outfit(
          color: Colors.white,
          fontSize: compact ? 11 : 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.ready});

  final bool ready;

  @override
  Widget build(BuildContext context) {
    final color = ready
        ? _DailyReportFilesScreenState._green
        : _DailyReportFilesScreenState._muted;
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: ready
            ? _DailyReportFilesScreenState._greenSoft
            : const Color(0xFFF0EFEA),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Text(
            ready ? 'Ready' : 'Pending',
            style: GoogleFonts.outfit(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewOverlay extends StatelessWidget {
  const _PreviewOverlay({
    required this.file,
    required this.previewFuture,
    required this.onClose,
    required this.onDownload,
  });

  final DailyReportFile file;
  final Future<DailyReportPreviewResponse> previewFuture;
  final VoidCallback onClose;
  final VoidCallback? onDownload;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final panelWidth = width < 900 ? width : math.min(860.0, width * .47);

    return Positioned.fill(
      child: Row(
        children: [
          if (width >= 900)
            Expanded(
              child: GestureDetector(
                onTap: onClose,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(color: Colors.black.withValues(alpha: .34)),
                ),
              ),
            ),
          SizedBox(
            width: panelWidth,
            child: _PreviewPanel(
              file: file,
              previewFuture: previewFuture,
              onClose: onClose,
              onDownload: onDownload,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewPanel extends StatelessWidget {
  const _PreviewPanel({
    required this.file,
    required this.previewFuture,
    required this.onClose,
    required this.onDownload,
  });

  final DailyReportFile file;
  final Future<DailyReportPreviewResponse> previewFuture;
  final VoidCallback onClose;
  final VoidCallback? onDownload;

  static final _day = DateFormat('MMM dd, yyyy');
  static final _time = DateFormat.jm();

  @override
  Widget build(BuildContext context) {
    final created = file.createdAt?.toLocal();
    final meta = created == null
        ? 'REPORT FILE'
        : '${_day.format(created).toUpperCase()} · ${_time.format(created)}';

    return Material(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 98,
            padding: const EdgeInsets.symmetric(horizontal: 28),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: _DailyReportFilesScreenState._border),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Close preview',
                  onPressed: onClose,
                  icon: DashboardQuickAccessSvgs.assetIcon(
                    DashboardQuickAccessSvgs.x,
                    size: 22,
                    color: _DailyReportFilesScreenState._ink,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meta,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          color: _DailyReportFilesScreenState._muted,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _FileRow._displayName(file),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          color: _DailyReportFilesScreenState._ink,
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                          height: 1.05,
                        ),
                      ),
                    ],
                  ),
                ),
                _PreviewIconButton(
                  icon: DashboardQuickAccessSvgs.share,
                  tooltip: 'Share',
                  onTap: () {},
                ),
                const SizedBox(width: 10),
                _PreviewDownloadButton(onTap: onDownload),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<DailyReportPreviewResponse>(
              future: previewFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return _PreviewError(
                    message:
                        snapshot.error?.toString() ??
                        'Could not load workbook preview.',
                  );
                }
                return _PreviewBody(file: file, preview: snapshot.data!);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewIconButton extends StatelessWidget {
  const _PreviewIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final String icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _DailyReportFilesScreenState._border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Tooltip(
            message: tooltip,
            child: DashboardQuickAccessSvgs.assetIcon(
              icon,
              size: 21,
              color: _DailyReportFilesScreenState._ink,
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewDownloadButton extends StatelessWidget {
  const _PreviewDownloadButton({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _DailyReportFilesScreenState._ink,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DashboardQuickAccessSvgs.assetIcon(
                DashboardQuickAccessSvgs.download,
                size: 20,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                'Download',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewBody extends StatelessWidget {
  const _PreviewBody({required this.file, required this.preview});

  final DailyReportFile file;
  final DailyReportPreviewResponse preview;

  @override
  Widget build(BuildContext context) {
    final firstRows = math.max(0, preview.previewRows.length - 1);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 26, 28, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PreviewStatsGrid(file: file, preview: preview),
          const SizedBox(height: 28),
          Row(
            children: [
              Text(
                'PREVIEW',
                style: GoogleFonts.outfit(
                  color: _DailyReportFilesScreenState._muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                ),
              ),
              const Spacer(),
              Text(
                'FIRST $firstRows OF ${NumberFormat.decimalPattern().format(preview.rows)} ROWS',
                style: GoogleFonts.outfit(
                  color: _DailyReportFilesScreenState._muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SpreadsheetPreview(preview: preview),
          const SizedBox(height: 28),
          Text(
            'RAW FILENAME',
            style: GoogleFonts.outfit(
              color: _DailyReportFilesScreenState._muted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 54,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFBFCFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _DailyReportFilesScreenState._border),
            ),
            child: Text(
              preview.fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                color: const Color(0xFF4F524D),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewStatsGrid extends StatelessWidget {
  const _PreviewStatsGrid({required this.file, required this.preview});

  final DailyReportFile file;
  final DailyReportPreviewResponse preview;

  @override
  Widget build(BuildContext context) {
    final cells = [
      (
        'FILE ID',
        preview.fileId.isEmpty ? _FileRow._shortId(file) : preview.fileId,
      ),
      ('ROWS', NumberFormat.decimalPattern().format(preview.rows)),
      ('SIZE', _formatBytes(preview.sizeBytes)),
      ('STATUS', _FileRow._isNew(file) ? 'New' : 'Ready'),
      ('SHEET', preview.sheetName),
      ('FORMAT', preview.format),
    ];

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _DailyReportFilesScreenState._border),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cells.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 82,
        ),
        itemBuilder: (context, index) {
          final cell = cells[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                right: (index + 1) % 3 == 0
                    ? BorderSide.none
                    : const BorderSide(
                        color: _DailyReportFilesScreenState._border,
                      ),
                bottom: index >= 3
                    ? BorderSide.none
                    : const BorderSide(
                        color: _DailyReportFilesScreenState._border,
                      ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cell.$1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: _DailyReportFilesScreenState._muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cell.$2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    color: _DailyReportFilesScreenState._ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SpreadsheetPreview extends StatelessWidget {
  const _SpreadsheetPreview({required this.preview});

  final DailyReportPreviewResponse preview;

  @override
  Widget build(BuildContext context) {
    final rows = preview.previewRows.isEmpty
        ? <List<String>>[
            const [
              'Time',
              'Receipt #',
              'Cashier',
              'Items',
              'Subtotal',
              'Tax',
              'Total',
            ],
          ]
        : preview.previewRows;
    final header = rows.first;
    final dataRows = rows.skip(1).take(7).toList(growable: false);
    final columnCount = math.max(7, header.length);
    final letters = List.generate(
      columnCount,
      (i) => String.fromCharCode(65 + i),
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _DailyReportFilesScreenState._border),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: math.max(780, 78.0 + (columnCount * 118.0)),
          child: Column(
            children: [
              SizedBox(
                height: 46,
                child: Row(
                  children: [
                    Container(
                      width: 160,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: _DailyReportFilesScreenState._border,
                          ),
                        ),
                      ),
                      child: Text(
                        preview.sheetName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          color: _DailyReportFilesScreenState._ink,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: _DailyReportFilesScreenState._border,
                          ),
                        ),
                      ),
                      child: Text(
                        '+',
                        style: GoogleFonts.outfit(
                          color: _DailyReportFilesScreenState._muted,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _SheetRow(
                rowNumber: '',
                values: letters,
                isLetterRow: true,
                columnCount: columnCount,
              ),
              _SheetRow(
                rowNumber: '',
                values: header,
                isHeader: true,
                columnCount: columnCount,
              ),
              for (var i = 0; i < dataRows.length; i++)
                _SheetRow(
                  rowNumber: '${i + 1}',
                  values: dataRows[i],
                  columnCount: columnCount,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({
    required this.rowNumber,
    required this.values,
    required this.columnCount,
    this.isHeader = false,
    this.isLetterRow = false,
  });

  final String rowNumber;
  final List<String> values;
  final int columnCount;
  final bool isHeader;
  final bool isLetterRow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isLetterRow ? 30 : 46,
      child: Row(
        children: [
          Container(
            width: 46,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFFBFCFB),
              border: Border(
                top: BorderSide(color: _DailyReportFilesScreenState._border),
                right: BorderSide(color: _DailyReportFilesScreenState._border),
              ),
            ),
            child: Text(
              rowNumber,
              style: GoogleFonts.outfit(
                color: _DailyReportFilesScreenState._muted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          for (var i = 0; i < columnCount; i++)
            Container(
              width: 118,
              alignment: isHeader || isLetterRow
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isLetterRow ? const Color(0xFFFBFCFB) : Colors.white,
                border: const Border(
                  top: BorderSide(color: _DailyReportFilesScreenState._border),
                  right: BorderSide(
                    color: _DailyReportFilesScreenState._border,
                  ),
                ),
              ),
              child: Text(
                i < values.length ? values[i] : '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  color: isLetterRow
                      ? _DailyReportFilesScreenState._muted
                      : _DailyReportFilesScreenState._ink,
                  fontSize: isLetterRow ? 12 : 15,
                  fontWeight: isHeader ? FontWeight.w800 : FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PreviewError extends StatelessWidget {
  const _PreviewError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            color: _DailyReportFilesScreenState._muted,
            fontSize: 15,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  final kb = bytes / 1024;
  if (kb < 1024) return '${kb.toStringAsFixed(kb >= 10 ? 0 : 1)} KB';
  final mb = kb / 1024;
  return '${mb.toStringAsFixed(mb >= 10 ? 0 : 1)} MB';
}

class _SelectionBar extends StatelessWidget {
  const _SelectionBar({
    required this.selectedCount,
    required this.busy,
    required this.onDownload,
    required this.onMerge,
    required this.onClose,
  });

  final int selectedCount;
  final bool busy;
  final VoidCallback? onDownload;
  final VoidCallback? onMerge;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 24,
      child: Center(
        child: Container(
          height: 66,
          constraints: const BoxConstraints(maxWidth: 1120),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF121310),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF30312E)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .28),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(
                NumberFormat.decimalPattern().format(selectedCount),
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 29,
                  height: 1,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                selectedCount == 1 ? 'file selected' : 'files selected',
                style: GoogleFonts.outfit(
                  color: const Color(0xFFD0D0CC),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                height: 28,
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 26),
                color: const Color(0xFF3B3C38),
              ),
              Text(
                _selectedSizeLabel(selectedCount),
                style: GoogleFonts.outfit(
                  color: const Color(0xFFA8AAA3),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              _SelectionAction(
                icon: DashboardQuickAccessSvgs.archive,
                label: 'Archive',
                onTap: () {},
              ),
              const SizedBox(width: 8),
              _SelectionAction(
                icon: DashboardQuickAccessSvgs.share,
                label: 'Share',
                onTap: () {},
              ),
              const SizedBox(width: 8),
              _SelectionAction(
                icon: DashboardQuickAccessSvgs.download,
                label: 'Download',
                busy: busy,
                onTap: onDownload,
              ),
              if (selectedCount > 1) ...[
                const SizedBox(width: 8),
                _SelectionAction(
                  icon: DashboardQuickAccessSvgs.stack,
                  label: 'Merge into one workbook',
                  filled: true,
                  busy: busy,
                  onTap: onMerge,
                ),
              ],
              const SizedBox(width: 16),
              IconButton(
                tooltip: 'Close',
                onPressed: onClose,
                icon: DashboardQuickAccessSvgs.assetIcon(
                  DashboardQuickAccessSvgs.x,
                  size: 20,
                  color: const Color(0xFFB7B8B3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _selectedSizeLabel(int count) {
    final kb = count * 220;
    if (kb < 1024) return '$kb KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(mb >= 10 ? 0 : 1)} MB';
  }
}

class _SelectionAction extends StatelessWidget {
  const _SelectionAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
    this.busy = false,
  });

  final String icon;
  final String label;
  final VoidCallback? onTap;
  final bool filled;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? _DailyReportFilesScreenState._green : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: busy ? null : onTap,
        child: Container(
          height: 46,
          padding: EdgeInsets.symmetric(horizontal: filled ? 20 : 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: filled ? const Color(0xFF1F8054) : const Color(0xFF3D3E3A),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (busy && label.contains('Download'))
                const SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              else
                DashboardQuickAccessSvgs.assetIcon(
                  icon,
                  size: 18,
                  color: Colors.white,
                ),
              const SizedBox(width: 9),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
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
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _DailyReportFilesScreenState._border,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: DashboardQuickAccessSvgs.assetIcon(
                  DashboardQuickAccessSvgs.fileExcel,
                  size: 64,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: _DailyReportFilesScreenState._ink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  height: 1.38,
                  color: _DailyReportFilesScreenState._muted,
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onPrimary,
                style: FilledButton.styleFrom(
                  backgroundColor: _DailyReportFilesScreenState._ink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: DashboardQuickAccessSvgs.assetIcon(
                  DashboardQuickAccessSvgs.refresh,
                  size: 18,
                  color: Colors.white,
                ),
                label: Text(
                  primaryLabel,
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
