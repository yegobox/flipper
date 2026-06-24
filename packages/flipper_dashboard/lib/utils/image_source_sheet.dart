import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// User selection from [showImageSourceSheet]. When [browseWithFilePicker] is
/// true, use [FilePicker] (Files app, iCloud, etc.); otherwise use
/// [imageSource] with [ImagePicker].
class ImageSourceSheetResult {
  const ImageSourceSheetResult._({
    this.imageSource,
    this.browseWithFilePicker = false,
  });
  const ImageSourceSheetResult.gallery()
      : this._(imageSource: ImageSource.gallery);
  const ImageSourceSheetResult.camera()
      : this._(imageSource: ImageSource.camera);
  const ImageSourceSheetResult.browse() : this._(browseWithFilePicker: true);

  final ImageSource? imageSource;
  final bool browseWithFilePicker;
}

/// Resolves a sheet choice to a local file path, or null if cancelled.
///
/// When opening [ImagePicker] after another modal (e.g. add-variant sheet on
/// iOS), a short delay lets the first route finish dismissing so the system
/// photo UI can present correctly.
Future<String?> pickLocalImagePathForSheetResult(
  ImageSourceSheetResult? result,
) async {
  if (result == null) return null;
  if (result.browseWithFilePicker) {
    final r = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'gif',
        'webp',
        'heic',
        'heif',
        'bmp',
      ],
      withData: false,
    );
    if (r == null || r.files.isEmpty) return null;
    return r.files.single.path;
  }
  await Future<void>.delayed(const Duration(milliseconds: 200));
  final x = await ImagePicker().pickImage(source: result.imageSource!);
  return x?.path;
}

/// Shown for camera / gallery, and (when not web) "Browse" for Files / iCloud.
Future<ImageSourceSheetResult?> showImageSourceSheet(
  BuildContext context, {
  List<Widget> extraActions = const [],
}) {
  return showModalBottomSheet<ImageSourceSheetResult>(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _ImageSourceSheet(extraActions: extraActions),
  );
}

class _ImageSourceSheet extends StatelessWidget {
  const _ImageSourceSheet({this.extraActions = const []});

  final List<Widget> extraActions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final showBrowse = !kIsWeb;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Options row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: _ImageOptionTile(
                        icon: Icons.photo_library_outlined,
                        label: 'Gallery',
                        onTap: () => Navigator.of(context).pop(
                          const ImageSourceSheetResult.gallery(),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 18,
                      thickness: 0.5,
                      color: colorScheme.outlineVariant,
                    ),
                    Expanded(
                      child: _ImageOptionTile(
                        icon: Icons.camera_alt_outlined,
                        label: 'Camera',
                        onTap: () => Navigator.of(context).pop(
                          const ImageSourceSheetResult.camera(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (showBrowse) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
                child: Material(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(
                      const ImageSourceSheetResult.browse(),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.folder_open_outlined,
                            color: colorScheme.onSurfaceVariant,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Browse files',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: colorScheme.outline,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],

            if (extraActions.isNotEmpty) ...[
              Divider(
                height: 0.5,
                thickness: 0.5,
                color: colorScheme.outlineVariant,
                indent: 18,
                endIndent: 18,
              ),
              const SizedBox(height: 8),
              ...extraActions,
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _ImageOptionTile extends StatelessWidget {
  const _ImageOptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    width: 0.5,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
