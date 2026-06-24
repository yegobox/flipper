// ignore_for_file: unused_result

import 'dart:io';

import 'package:flipper_dashboard/utils/image_source_sheet.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/upload_providers.dart';
import 'package:flipper_services/abstractions/upload.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';

String? _variantAssetName(Variant v) {
  final direct = v.imageUrl;
  if (direct != null && direct.isNotEmpty) return direct;
  final raw = v.addInfo;
  if (raw == null || raw.isEmpty) return null;
  return raw.startsWith('asset:') ? raw.substring('asset:'.length) : null;
}

/// Picker + thumbnail for a variant row (desktop / wide table) — same upload
/// path as the mobile [ProductEntryScreen] bottom sheet.
class VariantTableImageCell extends ConsumerStatefulWidget {
  const VariantTableImageCell({
    super.key,
    required this.productId,
    required this.variant,
    required this.model,
  });

  final String productId;
  final Variant variant;
  final ScannViewModel model;

  @override
  ConsumerState<VariantTableImageCell> createState() =>
      _VariantTableImageCellState();
}

class _VariantTableImageCellState extends ConsumerState<VariantTableImageCell> {
  static final Map<String, Future<void>> _downloadCache = {};

  String? _localPath;
  bool _uploading = false;
  String? _lastAssetName;

  @override
  void initState() {
    super.initState();
    _lastAssetName = _variantAssetName(widget.variant);
    _syncLocalPath();
  }

  @override
  void didUpdateWidget(covariant VariantTableImageCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = _variantAssetName(widget.variant);
    if (oldWidget.variant.id != widget.variant.id || next != _lastAssetName) {
      _lastAssetName = next;
      _localPath = null;
      _syncLocalPath();
    }
  }

  Future<void> _syncLocalPath() async {
    final assetName = _variantAssetName(widget.variant);
    if (assetName == null || assetName.isEmpty) {
      if (mounted) setState(() => _localPath = null);
      return;
    }

    final dir = await getApplicationSupportDirectory();
    final candidate = '${dir.path}/$assetName';
    if (File(candidate).existsSync()) {
      if (mounted) setState(() => _localPath = candidate);
      return;
    }

    _downloadCache[assetName] ??= () async {
      try {
        final stream = await ProxyService.strategy.downloadAssetSave(
          assetName: assetName,
          subPath: 'branch',
        );
        await for (final p in stream) {
          if (p >= 100) break;
        }
      } catch (_) {}
    }();

    await _downloadCache[assetName];
    if (!mounted) return;
    if (File(candidate).existsSync()) {
      setState(() => _localPath = candidate);
    }
  }

  Future<void> _pickAndUpload() async {
    if (widget.productId.isEmpty || widget.variant.id.isEmpty) {
      toast('Save the product and try again');
      return;
    }

    final sourceResult = await showImageSourceSheet(context);
    if (sourceResult == null) return;

    setState(() => _uploading = true);
    try {
      ref.read(uploadProgressProvider.notifier).setProgress(0);
      final pickedPath = await pickLocalImagePathForSheetResult(sourceResult);
      if (pickedPath == null) return;
      final uploader = UploadViewModel()..setRef(ref);
      final fileName = await uploader.uploadPickedImagePath(
        pickedPath: pickedPath,
        id: widget.productId,
        urlType: URLTYPE.PRODUCT,
        updateProductImage: false,
        persistAssetRecord: true,
        variantId: widget.variant.id,
      );
      _applyFileName(fileName);
    } catch (e, st) {
      talker.error('Variant image upload failed: $e', e, st);
      toast('Could not upload image. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _uploading = false);
        ref.read(uploadProgressProvider.notifier).setProgress(0);
      }
    }
  }

  void _applyFileName(String fileName) {
    widget.variant.imageUrl = fileName;
    widget.variant.addInfo = 'asset:$fileName';
    _lastAssetName = fileName;
    setState(() {
      _localPath = null;
    });
    widget.model.notifyListeners();
    _syncLocalPath();
  }

  @override
  Widget build(BuildContext context) {
    final name = _variantAssetName(widget.variant);
    final hasImage = name != null && name.isNotEmpty;
    return Tooltip(
      message: hasImage ? 'Change variant image' : 'Add variant image',
      child: InkWell(
        onTap: _uploading ? null : _pickAndUpload,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 52,
          height: 40,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (hasImage && _localPath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.file(
                    File(_localPath!),
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image_outlined,
                      size: 22,
                    ),
                  ),
                )
              else if (hasImage)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(
                  Icons.add_a_photo_outlined,
                  size: 22,
                  color: Theme.of(context).colorScheme.primary,
                ),
              if (_uploading)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
