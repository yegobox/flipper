import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmering placeholder bars for mobile loading states.
///
/// Placeholders keep the final layout's shape while data loads, so content
/// doesn't jump in when it arrives (a bare spinner collapses then expands).
class MposSkeleton extends StatelessWidget {
  const MposSkeleton({super.key, required this.child});

  /// Layout of grey blocks to shimmer; build it from [MposSkeleton.bar].
  final Widget child;

  static Widget bar({double? width, double height = 12, double radius = 6}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return ColorFiltered(
        colorFilter: const ColorFilter.mode(PosTokens.line, BlendMode.srcIn),
        child: child,
      );
    }
    return Shimmer.fromColors(
      baseColor: PosTokens.line,
      highlightColor: PosTokens.surface2,
      child: child,
    );
  }
}

/// A white mobile card holding skeleton lines, sized like the card it stands
/// in for.
class MposSkeletonCard extends StatelessWidget {
  const MposSkeletonCard({super.key, required this.height, this.lines = 3});

  final double height;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PosTokens.surface,
        borderRadius: BorderRadius.circular(MposTokens.radiusLg),
        border: Border.all(color: PosTokens.line),
      ),
      child: MposSkeleton(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MposSkeleton.bar(width: 120, height: 14),
            for (var i = 1; i < lines; i++) ...[
              const SizedBox(height: 12),
              MposSkeleton.bar(width: i.isOdd ? double.infinity : 180),
            ],
          ],
        ),
      ),
    );
  }
}

/// Placeholder rows for a list that is loading: an icon tile and two lines.
class MposSkeletonList extends StatelessWidget {
  const MposSkeletonList({super.key, this.rows = 6, this.rowHeight = 80});

  final int rows;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    return MposSkeleton(
      child: Column(
        children: [
          for (var i = 0; i < rows; i++)
            SizedBox(
              height: rowHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    MposSkeleton.bar(width: 48, height: 48, radius: 12),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MposSkeleton.bar(height: 14),
                          const SizedBox(height: 8),
                          MposSkeleton.bar(width: 120),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Error card with a retry button, for mobile screens whose data failed to
/// load. Shows a plain-language message; the raw error belongs in the log,
/// not in front of the user.
class MposErrorState extends StatelessWidget {
  const MposErrorState({
    super.key,
    required this.onRetry,
    this.title,
    this.message,
    this.compact = false,
  });

  final VoidCallback onRetry;
  final String? title;
  final String? message;

  /// Inline version for use inside a card: no icon tile, smaller type.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final retry = TextButton.icon(
      onPressed: onRetry,
      style: TextButton.styleFrom(foregroundColor: PosTokens.blue),
      icon: const Icon(FluentIcons.arrow_clockwise_24_regular, size: 18),
      label: Text(
        l10n.retry,
        style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
      ),
    );

    if (compact) {
      return Row(
        children: [
          const Icon(
            FluentIcons.error_circle_24_regular,
            size: 18,
            color: PosTokens.ink3,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title ?? l10n.mposLoadFailedTitle,
              style: GoogleFonts.outfit(fontSize: 14, color: PosTokens.ink2),
            ),
          ),
          retry,
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: MposTokens.lossTint,
              borderRadius: BorderRadius.circular(MposTokens.radiusMd),
            ),
            child: const Icon(
              FluentIcons.cloud_off_24_regular,
              color: PosTokens.lossInk,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title ?? l10n.mposLoadFailedTitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: PosTokens.ink1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message ?? l10n.mposLoadFailedBody,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(fontSize: 14, color: PosTokens.ink2),
          ),
          const SizedBox(height: 12),
          retry,
        ],
      ),
    );
  }
}

/// Keeps a pull-to-refresh spinner up until [reload] produces data (or fails),
/// instead of closing at once. Errors are swallowed because the screen's own
/// error state shows them; the timeout stops a provider that keeps retrying
/// from holding the spinner forever.
Future<void> mposAwaitRefresh(Future<Object?> reload) async {
  try {
    await reload.timeout(const Duration(seconds: 15));
  } catch (_) {}
}
