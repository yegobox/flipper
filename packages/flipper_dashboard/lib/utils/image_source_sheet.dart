import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageSource?> showImageSourceSheet(
  BuildContext context, {
  List<Widget> extraActions = const [],
}) {
  return showModalBottomSheet<ImageSource>(
    context: context,
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
                        onTap: () =>
                            Navigator.of(context).pop(ImageSource.gallery),
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
                        onTap: () =>
                            Navigator.of(context).pop(ImageSource.camera),
                      ),
                    ),
                  ],
                ),
              ),
            ),

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
