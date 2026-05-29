import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flipper_models/daily_report_download_client.dart';
import 'package:flipper_models/models/daily_report_file.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/daily_report_files_provider.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flipper_dashboard/widgets/dashboard_quick_access_svgs.dart';

// Aligned with shift history / embedded dashboard screens.
const Color _kBg = Color(0xFFF9FAFB);
const Color _kBlue = Color(0xFF3B82F6);
const Color _kGreen = Color(0xFF22C55E);
const Color _kTextPrimary = Color(0xFF111827);
const Color _kTextMuted = Color(0xFF6B7280);
const Color _kBorder = Color(0xFFE5E7EB);
const Color _kSelectedRow = Color(0xFFEFF6FF);
const Color _kGreenSoft = Color(0xFFECFDF5);
const Color _kSurfaceAlt = Color(0xFFF3F4F6);

class DailyReportFilesScreen extends ConsumerStatefulWidget {
  const DailyReportFilesScreen({super.key});

  @override
  ConsumerState<DailyReportFilesScreen> createState() =>
      _DailyReportFilesScreenState();
}

class _DailyReportFilesScreenState
    extends ConsumerState<DailyReportFilesScreen> {
  // Use a row-unique key (not only `id`) because some Ditto rows can share IDs
  // (e.g. migrated docs missing `_id`/`id`, or repeated exports).
  final Set<String> _selectedKeys = {};
  bool _batchBusy = false;
  String? _batchAction;
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

  Future<String?> _download(
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
      return null;
    }
    final key = file.s3ObjectKey?.trim();
    if (key == null || key.isEmpty) {
      showCustomSnackBarUtil(
        context,
        'This file has no storage key yet.',
        type: NotificationType.error,
      );
      return null;
    }

    final ebm = await ProxyService.strategy.ebm(
      branchId: branchId,
      fetchRemote: false,
    );

    return downloadDailyReportExcel(
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

    setState(() {
      _batchBusy = true;
      _batchAction = 'download';
    });
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
          _batchAction = null;
          _selectedKeys.clear();
        });
      }
    }
  }

  Future<void> _onShareSelected(List<DailyReportFile> all) async {
    if (kIsWeb) {
      showCustomSnackBarUtil(
        context,
        'Sharing is not supported in the browser.',
        type: NotificationType.error,
      );
      return;
    }

    final selected = all
        .where((f) => _selectedKeys.contains(_rowKey(f)))
        .toList(growable: false);
    if (selected.isEmpty) return;

    setState(() {
      _batchBusy = true;
      _batchAction = 'share';
    });
    try {
      final xFiles = <XFile>[];
      for (final file in selected) {
        final path = await _download(file, openAfterSave: false);
        if (path != null) {
          xFiles.add(XFile(path));
        }
      }
      if (xFiles.isEmpty) return;

      await Share.shareXFiles(xFiles, subject: 'Daily reports');
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          'Shared ${xFiles.length} file(s)',
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
          _batchAction = null;
        });
      }
    }
  }

  Future<void> _onArchiveSelected(List<DailyReportFile> all) async {
    final selected = all
        .where((f) => _selectedKeys.contains(_rowKey(f)))
        .toList(growable: false);
    if (selected.isEmpty) return;

    final withoutKey = selected
        .where((f) => (f.s3ObjectKey ?? '').trim().isEmpty)
        .length;
    if (withoutKey > 0) {
      showCustomSnackBarUtil(
        context,
        withoutKey == selected.length
            ? 'Selected files have no storage key yet.'
            : '$withoutKey selected file(s) have no storage key and cannot be archived.',
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

    setState(() {
      _batchBusy = true;
      _batchAction = 'archive';
    });
    try {
      final count = await ProxyService.getStrategy(Strategy.capella)
          .archiveDailyReportFiles(
            branchId: branchId,
            files: selected,
          );
      if (!mounted) return;
      if (count == 0) {
        showCustomSnackBarUtil(
          context,
          'No files could be archived.',
          type: NotificationType.error,
        );
      } else {
        showCustomSnackBarUtil(
          context,
          count == 1 ? 'Archived 1 file' : 'Archived $count files',
          type: NotificationType.success,
        );
        setState(() => _selectedKeys.clear());
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
          _batchAction = null;
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

    setState(() {
      _batchBusy = true;
      _batchAction = 'merge';
    });
    try {
      final ebm = await ProxyService.strategy.ebm(
        branchId: branchId,
        fetchRemote: false,
      );
      await createMergedDailyReportExcel(
        branchId: branchId,
        objectKeys: objectKeys,
        dataConnectorUrl: ebm?.dataConnectorUrl,
      );
      ref.invalidate(dailyReportFilesProvider(branchId));
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          'Merged ${selected.length} reports. New workbook added to the list.',
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
          _batchAction = null;
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
      backgroundColor: _kBg,
      body: SafeArea(
        child: branchId.isEmpty
            ? _Shell(
                branchName: branchName,
                files: const <DailyReportFile>[],
                visibleFiles: const <DailyReportFile>[],
                selectedKeys: _selectedKeys,
                batchBusy: _batchBusy,
                batchAction: _batchAction,
                search: _search,
                onSearchChanged: (_) => setState(() {}),
                onSelectAll: () {},
                onClearSelection: () {},
                onRefresh: () =>
                    ref.invalidate(dailyReportFilesProvider(branchId)),
                onDownloadSelected: null,
                onMergeSelected: null,
                onArchiveSelected: null,
                onShareSelected: null,
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
                  batchAction: _batchAction,
                  search: _search,
                  onSearchChanged: (_) => setState(() {}),
                  onSelectAll: () {},
                  onClearSelection: () {},
                  onRefresh: () =>
                      ref.invalidate(dailyReportFilesProvider(branchId)),
                  onDownloadSelected: null,
                  onMergeSelected: null,
                  onArchiveSelected: null,
                  onShareSelected: null,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => _Shell(
                  branchName: branchName,
                  files: const <DailyReportFile>[],
                  visibleFiles: const <DailyReportFile>[],
                  selectedKeys: _selectedKeys,
                  batchBusy: _batchBusy,
                  batchAction: _batchAction,
                  search: _search,
                  onSearchChanged: (_) => setState(() {}),
                  onSelectAll: () {},
                  onClearSelection: () {},
                  onRefresh: () =>
                      ref.invalidate(dailyReportFilesProvider(branchId)),
                  onDownloadSelected: null,
                  onMergeSelected: null,
                  onArchiveSelected: null,
                  onShareSelected: null,
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
                    batchAction: _batchAction,
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
                    onArchiveSelected: _selectedKeys.isEmpty
                        ? null
                        : () => _onArchiveSelected(files),
                    onShareSelected: _selectedKeys.isEmpty
                        ? null
                        : () => _onShareSelected(files),
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
    required this.batchAction,
    required this.search,
    required this.onSearchChanged,
    required this.onSelectAll,
    required this.onClearSelection,
    required this.onRefresh,
    required this.onDownloadSelected,
    required this.onMergeSelected,
    required this.onArchiveSelected,
    required this.onShareSelected,
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
  final String? batchAction;
  final TextEditingController search;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSelectAll;
  final VoidCallback onClearSelection;
  final VoidCallback onRefresh;
  final VoidCallback? onDownloadSelected;
  final VoidCallback? onMergeSelected;
  final VoidCallback? onArchiveSelected;
  final VoidCallback? onShareSelected;
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
            busyAction: batchAction,
            onArchive: onArchiveSelected,
            onShare: onShareSelected,
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
            color: _kTextPrimary,
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
              color: _kTextMuted,
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
      color: filled ? _kBlue : Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: filled ? _kBlue : _kBorder),
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
                color: filled ? Colors.white : _kTextPrimary,
              ),
              const SizedBox(width: 9),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: filled ? Colors.white : _kTextPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                DashboardQuickAccessSvgs.assetIcon(
                  trailing!,
                  size: 18,
                  color: filled ? Colors.white : _kTextPrimary,
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
        border: Border.all(color: _kBorder),
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
              color: _kTextMuted,
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
              color: _kTextPrimary,
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
              color: _kTextMuted,
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
      child: VerticalDivider(width: 1, thickness: 1, color: _kBorder),
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
          border: Border.all(color: _kBorder),
        ),
        child: Column(
          children: [
            Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: _kBorder)),
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
                      activeColor: _kBlue,
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
                      color: _kTextPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  if (selectedCount > 0)
                    TextButton(
                      onPressed: onClearSelection,
                      style: TextButton.styleFrom(
                        foregroundColor: _kTextMuted,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 36),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Clear selection',
                        style: GoogleFonts.outfit(
                          decoration: TextDecoration.underline,
                          decorationColor: _kTextMuted,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(width: 18),
                  DashboardQuickAccessSvgs.assetIcon(
                    DashboardQuickAccessSvgs.clock,
                    size: 17,
                    color: _kTextMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Auto-syncs every 5 min',
                    style: GoogleFonts.outfit(
                      color: _kTextMuted,
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
                color: _kSurfaceAlt,
                border: Border(bottom: BorderSide(color: _kBorder)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: search,
                      onChanged: onSearchChanged,
                      style: GoogleFonts.outfit(
                        color: _kTextPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search by report name, date, or ID...',
                        hintStyle: GoogleFonts.outfit(
                          color: _kTextMuted,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(13),
                          child: DashboardQuickAccessSvgs.assetIcon(
                            DashboardQuickAccessSvgs.search,
                            size: 20,
                            color: _kTextMuted,
                          ),
                        ),
                        suffixIcon: Container(
                          width: 42,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: _kSurfaceAlt,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: _kBorder),
                          ),
                          child: Text(
                            '#K',
                            style: GoogleFonts.outfit(
                              color: _kTextMuted,
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
                        focusedBorder: _outline(color: _kBlue),
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
                      color: _kTextPrimary,
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

  OutlineInputBorder _outline({Color color = _kBorder}) {
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
        color: filled ? _kBlue : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: filled ? _kBlue : _kBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DashboardQuickAccessSvgs.assetIcon(
            icon,
            size: 18,
            color: filled ? Colors.white : _kTextPrimary,
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: _kTextMuted,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(width: 5),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: filled ? Colors.white : _kTextPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (!filled) ...[
            const SizedBox(width: 5),
            DashboardQuickAccessSvgs.assetIcon(
              DashboardQuickAccessSvgs.chevronDown,
              size: 18,
              color: _kTextPrimary,
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
        border: Border(bottom: BorderSide(color: _kBorder)),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              color: _kTextMuted,
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
              color: _kSurfaceAlt,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _kBorder),
            ),
            child: Text(
              'Today',
              style: GoogleFonts.outfit(
                color: _kTextMuted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Spacer(),
          Text(
            '$count ${count == 1 ? 'file' : 'files'}',
            style: GoogleFonts.outfit(
              color: _kTextMuted,
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
    final category = _categoryLabel(file);

    return Material(
      color: selected ? _kSelectedRow : Colors.white,
      child: InkWell(
        onTap: busy ? null : onPreview,
        child: Container(
          height: 104,
          decoration: BoxDecoration(
            border: selected
                ? const Border(
                    left: BorderSide(color: _kBlue, width: 3),
                    bottom: BorderSide(color: _kBorder),
                  )
                : const Border(bottom: BorderSide(color: _kBorder)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              Checkbox(
                value: selected,
                onChanged: busy ? null : (_) => onToggle(),
                activeColor: _kBlue,
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
                  border: Border.all(color: _kBorder),
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
                              color: _kTextPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '.xlsx',
                          style: GoogleFonts.outfit(
                            color: _kTextMuted,
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
                        if (category != null) ...[
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
                  color: _kTextPrimary,
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
                        color: _kGreen,
                      ),
              ),
              IconButton(
                tooltip: 'More',
                onPressed: () {},
                icon: DashboardQuickAccessSvgs.assetIcon(
                  DashboardQuickAccessSvgs.more,
                  size: 22,
                  color: _kTextPrimary,
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
    if (lower.contains('merged')) {
      return _mergedDisplayName(raw);
    }
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

  static String _mergedDisplayName(String raw) {
    final withoutExtension = raw.replaceAll(
      RegExp(r'\.xlsx$', caseSensitive: false),
      '',
    );
    final dates = RegExp(
      r'\d{4}-\d{2}-\d{2}',
    ).allMatches(withoutExtension).map((m) => m.group(0)!).toList();
    if (dates.length >= 2) {
      return '${dates.first} - ${dates.last} (merged)';
    }
    if (dates.length == 1) {
      return '${dates.first} (merged)';
    }
    return withoutExtension
        .replaceAll(
          RegExp(r'^daily[-_\s]*transactions[-_\s]*', caseSensitive: false),
          '',
        )
        .replaceAll(RegExp(r'[-_]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static String _shortId(DailyReportFile file) {
    final source = (file.runId ?? file.id).replaceAll('-', '').trim();
    if (source.isEmpty) return 'report';
    return source.length <= 8 ? source : source.substring(0, 8);
  }

  static String? _categoryLabel(DailyReportFile file) {
    if ((file.fileName ?? '').toLowerCase().contains('merged')) {
      return 'Merged workbook';
    }
    return null;
  }

  static bool _isNew(DailyReportFile file) {
    final created = file.createdAt;
    if (created == null) return false;
    return DateTime.now().difference(created.toLocal()).inHours < 24;
  }

  static TextStyle _metaStyle(BuildContext context, {bool strong = false}) {
    return GoogleFonts.outfit(
      color: _kTextMuted,
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
        color: _kTextMuted,
        fontSize: 14,
        fontWeight: FontWeight.w700,
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
        color: _kGreen,
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
    final color = ready ? _kGreen : _kTextMuted;
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: ready ? _kGreenSoft : _kSurfaceAlt,
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
              border: Border(bottom: BorderSide(color: _kBorder)),
            ),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Close preview',
                  onPressed: onClose,
                  icon: DashboardQuickAccessSvgs.assetIcon(
                    DashboardQuickAccessSvgs.x,
                    size: 22,
                    color: _kTextPrimary,
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
                          color: _kTextMuted,
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
                          color: _kTextPrimary,
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
            border: Border.all(color: _kBorder),
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
              color: _kTextPrimary,
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
      color: _kTextPrimary,
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
                  color: _kTextMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                ),
              ),
              const Spacer(),
              Text(
                'FIRST $firstRows OF ${NumberFormat.decimalPattern().format(preview.rows)} ROWS',
                style: GoogleFonts.outfit(
                  color: _kTextMuted,
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
              color: _kTextMuted,
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
              color: _kSurfaceAlt,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _kBorder),
            ),
            child: Text(
              preview.fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                color: _kTextMuted,
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
        border: Border.all(color: _kBorder),
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
                    : const BorderSide(color: _kBorder),
                bottom: index >= 3
                    ? BorderSide.none
                    : const BorderSide(color: _kBorder),
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
                    color: _kTextMuted,
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
                    color: _kTextPrimary,
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
        border: Border.all(color: _kBorder),
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
                        border: Border(right: BorderSide(color: _kBorder)),
                      ),
                      child: Text(
                        preview.sheetName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          color: _kTextPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        border: Border(right: BorderSide(color: _kBorder)),
                      ),
                      child: Text(
                        '+',
                        style: GoogleFonts.outfit(
                          color: _kTextMuted,
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
              color: _kSurfaceAlt,
              border: Border(
                top: BorderSide(color: _kBorder),
                right: BorderSide(color: _kBorder),
              ),
            ),
            child: Text(
              rowNumber,
              style: GoogleFonts.outfit(
                color: _kTextMuted,
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
                color: isLetterRow ? _kSurfaceAlt : Colors.white,
                border: const Border(
                  top: BorderSide(color: _kBorder),
                  right: BorderSide(color: _kBorder),
                ),
              ),
              child: Text(
                i < values.length ? values[i] : '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  color: isLetterRow ? _kTextMuted : _kTextPrimary,
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
            color: _kTextMuted,
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
    required this.busyAction,
    required this.onArchive,
    required this.onShare,
    required this.onDownload,
    required this.onMerge,
    required this.onClose,
  });

  final int selectedCount;
  final bool busy;
  final String? busyAction;
  final VoidCallback? onArchive;
  final VoidCallback? onShare;
  final VoidCallback? onDownload;
  final VoidCallback? onMerge;
  final VoidCallback onClose;

  static final _buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final iconOnly = width < 720;
    final canMerge = selectedCount > 1 && onMerge != null;

    return Positioned(
      left: 16,
      right: 16,
      bottom: 20,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          elevation: 6,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 960),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _kBorder),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
                  child: Row(
                    children: [
                      Text(
                        NumberFormat.decimalPattern().format(selectedCount),
                        style: GoogleFonts.outfit(
                          color: _kTextPrimary,
                          fontSize: 24,
                          height: 1,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              selectedCount == 1
                                  ? 'file selected'
                                  : 'files selected',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _kTextPrimary,
                                height: 1.2,
                              ),
                            ),
                            Text(
                              _selectedSizeLabel(selectedCount),
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: _kTextMuted,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _SelectionBarButton(
                                icon: DashboardQuickAccessSvgs.archive,
                                label: 'Archive',
                                iconOnly: iconOnly,
                                busy: busy && busyAction == 'archive',
                                onPressed: busy ? null : onArchive,
                              ),
                              const SizedBox(width: 8),
                              _SelectionBarButton(
                                icon: DashboardQuickAccessSvgs.share,
                                label: 'Share',
                                iconOnly: iconOnly,
                                busy: busy && busyAction == 'share',
                                onPressed: busy ? null : onShare,
                              ),
                              const SizedBox(width: 8),
                              _SelectionBarButton(
                                icon: DashboardQuickAccessSvgs.download,
                                label: 'Download',
                                iconOnly: iconOnly,
                                busy: busy && busyAction == 'download',
                                onPressed: busy ? null : onDownload,
                              ),
                              if (canMerge) ...[
                                const SizedBox(width: 8),
                                _SelectionBarButton(
                                  icon: DashboardQuickAccessSvgs.stack,
                                  label: 'Merge into one workbook',
                                  iconOnly: iconOnly,
                                  filled: true,
                                  busy: busy && busyAction == 'merge',
                                  onPressed: busy ? null : onMerge,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Close',
                        onPressed: busy ? null : onClose,
                        icon: DashboardQuickAccessSvgs.assetIcon(
                          DashboardQuickAccessSvgs.x,
                          size: 20,
                          color: _kTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (busy)
                  const LinearProgressIndicator(
                    minHeight: 2,
                    backgroundColor: _kBorder,
                    color: _kBlue,
                  ),
              ],
            ),
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

class _SelectionBarButton extends StatelessWidget {
  const _SelectionBarButton({
    required this.icon,
    required this.label,
    required this.iconOnly,
    required this.onPressed,
    this.filled = false,
    this.busy = false,
  });

  final String icon;
  final String label;
  final bool iconOnly;
  final VoidCallback? onPressed;
  final bool filled;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final fg = filled ? Colors.white : _kTextPrimary;
    final iconWidget = busy
        ? SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: fg),
          )
        : DashboardQuickAccessSvgs.assetIcon(icon, size: 18, color: fg);

    if (filled) {
      return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: _kBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _kBlue.withValues(alpha: 0.5),
          padding: EdgeInsets.symmetric(
            horizontal: iconOnly ? 12 : 16,
            vertical: 10,
          ),
          minimumSize: const Size(0, 40),
          shape: _SelectionBar._buttonShape,
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            if (!iconOnly) ...[const SizedBox(width: 8), Text(label)],
          ],
        ),
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: _kTextPrimary,
        side: const BorderSide(color: _kBorder),
        padding: EdgeInsets.symmetric(
          horizontal: iconOnly ? 12 : 16,
          vertical: 10,
        ),
        minimumSize: const Size(0, 40),
        shape: _SelectionBar._buttonShape,
        textStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          if (!iconOnly) ...[const SizedBox(width: 8), Text(label)],
        ],
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
                  border: Border.all(color: _kBorder),
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
                  color: _kTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  height: 1.38,
                  color: _kTextMuted,
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onPrimary,
                style: FilledButton.styleFrom(
                  backgroundColor: _kBlue,
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
