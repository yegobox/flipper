import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../theme/flo_theme.dart';
import 'flo_support_controller.dart';
import 'flo_support_repository.dart';

/// Opens the chat with Flipper Support: a bottom sheet on phones, a dialog
/// on wider screens. Messages land in the support team's Flo Team board and
/// their replies show up here.
///
/// [topic] (`payment` or `general`) and [screenContext] (what the screen
/// shows, see [FloSupportRepository.send]) travel with every message.
/// [onFallback], when given, is offered if support chat cannot be reached,
/// for example to open WhatsApp.
Future<void> showFloSupportSheet(
  BuildContext context, {
  String topic = 'general',
  Map<String, String>? screenContext,
  VoidCallback? onFallback,
}) {
  final chat = FloSupportChat(
    topic: topic,
    screenContext: screenContext,
    onFallback: onFallback,
  );
  if (MediaQuery.sizeOf(context).width < FloTheme.mobileBreakpoint) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: FloTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(FloTheme.radiusLg),
        ),
      ),
      // The sheet sits above the keyboard rather than under it, so the
      // composer never has to fit the keyboard inside the sheet.
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: FractionallySizedBox(heightFactor: 0.85, child: chat),
      ),
    );
  }
  return showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: FloTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FloTheme.radiusLg),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 620),
        child: chat,
      ),
    ),
  );
}

/// The conversation with Flipper Support and a composer.
class FloSupportChat extends ConsumerStatefulWidget {
  const FloSupportChat({
    super.key,
    this.topic = 'general',
    this.screenContext,
    this.onFallback,
  });

  final String topic;
  final Map<String, String>? screenContext;
  final VoidCallback? onFallback;

  @override
  ConsumerState<FloSupportChat> createState() => _FloSupportChatState();
}

class _FloSupportChatState extends ConsumerState<FloSupportChat> {
  final _message = TextEditingController();

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  /// Below this the chat scrolls as a whole (a phone on its side with the
  /// keyboard up), so the composer is never pushed off the sheet.
  static const _minHeight = 300.0;

  Future<void> _send() async {
    final body = _message.text;
    final sent = await ref.read(floSupportControllerProvider.notifier).send(
          body,
          topic: widget.topic,
          context: widget.screenContext,
        );
    // Text typed while it was sending is a new message: keep it.
    if (sent && mounted && _message.text == body) _message.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(floSupportControllerProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        final chat = _chat(context, state);
        if (constraints.maxHeight >= _minHeight) return chat;
        return SingleChildScrollView(
          reverse: true,
          child: SizedBox(height: _minHeight, child: chat),
        );
      },
    );
  }

  Widget _chat(BuildContext context, FloSupportState state) {
    final l10n = context.flipperL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 8, 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: FloTheme.blueTint,
                  borderRadius: BorderRadius.circular(FloTheme.radiusSm),
                ),
                child: const Icon(Icons.support_agent, color: FloTheme.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.floSupportTitle,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: FloTheme.ink1,
                      ),
                    ),
                    Text(
                      l10n.floSupportSubtitle,
                      style:
                          const TextStyle(fontSize: 13, color: FloTheme.ink3),
                    ),
                  ],
                ),
              ),
              IconButton(
                key: const Key('flo-support-close'),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close, color: FloTheme.ink3),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: FloTheme.line),
        Expanded(
          child: state.loading
              ? const Center(
                  child: CircularProgressIndicator(color: FloTheme.blue),
                )
              : state.posts.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          l10n.floSupportEmpty,
                          key: const Key('flo-support-empty'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: FloTheme.ink3,
                          ),
                        ),
                      ),
                    )
                  : ListView(
                      reverse: true,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      children: [
                        if (state.resolved)
                          Padding(
                            key: const Key('flo-support-resolved'),
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              l10n.floSupportResolved,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: FloTheme.gainInk,
                              ),
                            ),
                          ),
                        for (final post in state.posts.reversed)
                          _Bubble(post: post),
                      ],
                    ),
        ),
        if (state.error != null)
          Container(
            key: const Key('flo-support-error'),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
            decoration: BoxDecoration(
              color: FloTheme.lossTint,
              borderRadius: BorderRadius.circular(FloTheme.radiusSm),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.floSupportError,
                    style: const TextStyle(
                      fontSize: 13,
                      color: FloTheme.lossInk,
                    ),
                  ),
                ),
                if (widget.onFallback != null)
                  TextButton(
                    key: const Key('flo-support-fallback'),
                    onPressed: widget.onFallback,
                    child: Text(l10n.floSupportFallback),
                  ),
              ],
            ),
          ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('flo-support-message'),
                    controller: _message,
                    enabled: !state.unavailable,
                    minLines: 1,
                    maxLines: 5,
                    maxLength: 4000,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: l10n.floSupportHint,
                      counterText: '',
                      filled: true,
                      fillColor: FloTheme.surface2,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(FloTheme.radiusMd),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  key: const Key('flo-support-send'),
                  tooltip: l10n.floSupportSend,
                  style: IconButton.styleFrom(
                    backgroundColor: FloTheme.blue,
                    foregroundColor: Colors.white,
                    fixedSize: const Size(46, 46),
                  ),
                  onPressed: state.sending || state.unavailable ? null : _send,
                  icon: state.sending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send_rounded, size: 20),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.post});

  final FloSupportPost post;

  @override
  Widget build(BuildContext context) {
    final mine = post.mine;
    final created = post.createdAt;
    final name = mine ? context.flipperL10n.floTeamYou : post.authorName;
    return Align(
      alignment:
          post.fromSupport ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            crossAxisAlignment: post.fromSupport
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Text(
                [
                  name,
                  if (created != null)
                    DateFormat('d MMM, HH:mm').format(created),
                ].join(' · '),
                style: const TextStyle(fontSize: 11.5, color: FloTheme.ink3),
              ),
              const SizedBox(height: 3),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: post.fromSupport ? FloTheme.surface2 : FloTheme.blue,
                  borderRadius: BorderRadius.circular(FloTheme.radiusMd),
                ),
                child: Text(
                  post.body,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: post.fromSupport ? FloTheme.ink1 : Colors.white,
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
