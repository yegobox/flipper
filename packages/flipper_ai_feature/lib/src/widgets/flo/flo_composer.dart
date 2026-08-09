import 'package:flutter/material.dart';

import '../../services/speech_dictation.dart';
import '../../theme/flo_theme.dart';
import 'flo_icons.dart';
import 'flo_mark.dart';

class FloComposer extends StatefulWidget {
  const FloComposer({
    super.key,
    required this.controller,
    required this.onSend,
    this.onAttach,
    this.enabled = true,
    this.showQuickPrompts = false,
    this.isMobile = false,
    this.dictation,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onAttach;
  final bool enabled;
  final bool showQuickPrompts;
  final bool isMobile;

  /// Injectable for tests; a private instance is created when omitted.
  final SpeechDictation? dictation;

  static const quickPrompts = [
    {'icon': 'bolt', 'label': 'Summarize today', 'q': "Summarize today's business performance"},
    {'icon': 'coins', 'label': 'Top products', 'q': 'Which products are most profitable this week?'},
    {'icon': 'users', 'label': 'User count', 'q': 'How many users do we have in MiniData?'},
    {'icon': 'trend', 'label': 'Sales trend', 'q': "Show this week's sales trend"},
  ];

  @override
  State<FloComposer> createState() => _FloComposerState();
}

class _FloComposerState extends State<FloComposer> {
  late final SpeechDictation _dictation =
      widget.dictation ?? SpeechDictation();
  late final bool _ownsDictation = widget.dictation == null;

  @override
  void initState() {
    super.initState();
    _dictation.addListener(_onDictationChanged);
  }

  @override
  void dispose() {
    _dictation.removeListener(_onDictationChanged);
    if (_ownsDictation) _dictation.dispose();
    super.dispose();
  }

  void _onDictationChanged() {
    if (!mounted) return;
    setState(() {});
    final error = _dictation.consumeError();
    if (error != null) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(error),
          behavior: SnackBarBehavior.floating,
          backgroundColor: FloTheme.lossInk,
        ),
      );
    }
  }

  void _toggleDictation() {
    if (!widget.enabled) return;
    _dictation.toggle(widget.controller);
  }

  /// Recognised words are still streaming in when send fires, so end the
  /// session first — otherwise the field keeps filling after it is cleared.
  void _handleSend() {
    if (_dictation.isListening) _dictation.stop();
    widget.onSend();
  }

  Widget _quickIcon(String name) => switch (name) {
        'bolt' => FloIcons.bolt(size: 14, color: FloTheme.ink3),
        'coins' => FloIcons.coins(size: 14, color: FloTheme.ink3),
        'users' => FloIcons.users(size: 14, color: FloTheme.ink3),
        'trend' => FloIcons.trend(size: 14, color: FloTheme.ink3),
        _ => FloIcons.bolt(size: 14, color: FloTheme.ink3),
      };

  @override
  Widget build(BuildContext context) {
    final isMobile = widget.isMobile;
    final enabled = widget.enabled;
    final controller = widget.controller;
    return Container(
      padding: EdgeInsets.fromLTRB(isMobile ? 14 : 20, 12, isMobile ? 14 : 20, isMobile ? 22 : 16),
      decoration: BoxDecoration(
        border: const Border(top: BorderSide(color: FloTheme.line)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            FloTheme.chatBg.withValues(alpha: 0),
            FloTheme.chatBg,
          ],
          stops: const [0.0, 0.26],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: FloTheme.contentMaxWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showQuickPrompts)
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: FloComposer.quickPrompts.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final p = FloComposer.quickPrompts[i];
                      return _QuickPromptChip(
                        icon: _quickIcon(p['icon'] as String),
                        label: p['label'] as String,
                        onTap: enabled
                            ? () {
                                controller.text = p['q'] as String;
                                _handleSend();
                              }
                            : null,
                      );
                    },
                  ),
                ),
              if (widget.showQuickPrompts) const SizedBox(height: 10),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, _) {
                  final canSend = enabled && value.text.trim().isNotEmpty;
                  final dictating = _dictation.isListening || _dictation.isBusy;
                  return Container(
                    decoration: BoxDecoration(
                      color: FloTheme.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: FloTheme.line, width: 1.5),
                      boxShadow: const [FloTheme.sh2],
                    ),
                    padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _CompBtn(
                          icon: FloIcons.plus(size: 19, color: FloTheme.ink2),
                          onTap: widget.onAttach,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 4, bottom: 2),
                                    padding: const EdgeInsets.fromLTRB(7, 3, 9, 3),
                                    decoration: BoxDecoration(
                                      color: FloTheme.surface2,
                                      borderRadius: BorderRadius.circular(FloTheme.radiusPill),
                                      border: Border.all(color: FloTheme.line),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const FloLiveDot(
                                          color: FloTheme.gain,
                                          glow: FloTheme.gainTint,
                                        ),
                                        const SizedBox(width: 6),
                                        FloIcons.database(size: 12, color: FloTheme.ink2),
                                        const SizedBox(width: 4),
                                        const Text(
                                          'MiniData',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: FloTheme.ink2,
                                          ),
                                        ),
                                        FloIcons.chevDown(size: 12, color: FloTheme.ink4),
                                      ],
                                    ),
                                  ),
                                  if (dictating)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6, bottom: 2),
                                      child: _ListeningPill(busy: _dictation.isBusy),
                                    ),
                                ],
                              ),
                              TextField(
                                controller: controller,
                                enabled: enabled,
                                maxLines: 4,
                                minLines: 1,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  height: 1.5,
                                  color: FloTheme.ink1,
                                ),
                                decoration: const InputDecoration(
                                  hintText:
                                      'Ask about sales, stock, customers or tax…',
                                  hintStyle: TextStyle(color: FloTheme.ink4),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 9,
                                  ),
                                ),
                                onSubmitted: (_) {
                                  if (canSend) _handleSend();
                                },
                              ),
                            ],
                          ),
                        ),
                        // Semantics rather than Tooltip: Tooltip is an
                        // OverlayPortal, which asserts when it first mounts
                        // during a DevicePreview-driven rebuild.
                        Semantics(
                          button: true,
                          label: dictating
                              ? 'Stop dictating'
                              : 'Dictate — speak and Flo types it',
                          child: _CompBtn(
                            icon: FloIcons.mic(
                              size: 19,
                              color: dictating ? FloTheme.loss : FloTheme.ink2,
                            ),
                            background:
                                dictating ? FloTheme.lossTint : FloTheme.surface2,
                            borderColor: dictating ? FloTheme.loss : FloTheme.line,
                            onTap: enabled ? _toggleDictation : null,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: canSend ? _handleSend : null,
                            borderRadius: BorderRadius.circular(12),
                            child: Ink(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: canSend ? FloTheme.gradBtn : null,
                                color: canSend ? null : FloTheme.ink4.withValues(alpha: 0.45),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: canSend ? const [FloTheme.shBlue] : null,
                              ),
                              child: Center(
                                child: FloIcons.send(
                                  size: 19,
                                  color: Colors.white.withValues(alpha: canSend ? 1 : 0.7),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              const Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 11, color: FloTheme.ink4),
                  children: [
                    TextSpan(
                      text: 'Flo can make mistakes — check important figures. ',
                    ),
                    TextSpan(
                      text: 'Grounded in MiniData.',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: FloTheme.ink3,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompBtn extends StatelessWidget {
  const _CompBtn({
    required this.icon,
    this.onTap,
    this.background = FloTheme.surface2,
    this.borderColor = FloTheme.line,
  });
  final Widget icon;
  final VoidCallback? onTap;
  final Color background;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Ink(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: borderColor),
          ),
          child: Center(child: icon),
        ),
      ),
    );
  }
}

/// Shown beside the source chip while dictation is live, so it is obvious the
/// microphone is open and where the words are going.
class _ListeningPill extends StatelessWidget {
  const _ListeningPill({required this.busy});

  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(7, 3, 9, 3),
      decoration: BoxDecoration(
        color: FloTheme.lossTint,
        borderRadius: BorderRadius.circular(FloTheme.radiusPill),
        border: Border.all(color: FloTheme.loss.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FloLiveDot(color: FloTheme.loss, glow: FloTheme.lossTint),
          const SizedBox(width: 6),
          Text(
            busy ? 'Starting…' : 'Listening…',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: FloTheme.lossInk,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickPromptChip extends StatelessWidget {
  const _QuickPromptChip({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final Widget icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FloTheme.surface,
      borderRadius: BorderRadius.circular(FloTheme.radiusPill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FloTheme.radiusPill),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(FloTheme.radiusPill),
            border: Border.all(color: FloTheme.line),
            boxShadow: const [FloTheme.sh1],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(width: 7),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: FloTheme.ink2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
