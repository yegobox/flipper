import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/ai_theme.dart';

/// A modern, animated input field for the AI chat.
class AiInputField extends StatefulWidget {
  final TextEditingController controller;
  final bool isLoading;
  final Function(String) onSend;
  final String? hintText;
  final bool enabled;

  const AiInputField({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onSend,
    this.hintText = 'Ask me anything about your business...',
    this.enabled = true,
  });

  @override
  State<AiInputField> createState() => _AiInputFieldState();
}

class _AiInputFieldState extends State<AiInputField>
    with TickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();

  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChange);
    _hasText = widget.controller.text.isNotEmpty;
    _focusNode.onKeyEvent = _handleKeyEvent;
  }

  @override
  void dispose() {
    _focusNode.onKeyEvent = null;
    widget.controller.removeListener(_handleTextChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final isModifierPressed = HardwareKeyboard.instance.isControlPressed ||
          HardwareKeyboard.instance.isMetaPressed;

      if (event.logicalKey == LogicalKeyboardKey.enter && isModifierPressed) {
        if (_canSend()) {
          _handleSubmit(widget.controller.text);
        }
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AiTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildAttachmentButton(),
            const SizedBox(width: 8),
            Expanded(child: _buildInputField()),
            const SizedBox(width: 12),
            _buildSendOrMicButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentButton() {
    return IconButton(
      onPressed: () {
        // TODO: Implement file picking logic.
      },
      icon: const Icon(Icons.attach_file),
      color: AiTheme.secondaryColor,
      iconSize: 28,
      splashRadius: 24,
    );
  }

  Widget _buildInputField() {
    return Container(
      decoration: BoxDecoration(
        color: AiTheme.inputBackgroundColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AiTheme.borderColor),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: AiTheme.hintColor,
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
        ),
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }

  Widget _buildSendOrMicButton() {
    final hasText = _hasText;
    final canSend = _canSend();

    return SizedBox(
      width: 52,
      height: 52,
      child: Material(
        color: hasText ? AiTheme.primaryColor : AiTheme.inputBackgroundColor,
        borderRadius: BorderRadius.circular(26),
        elevation: hasText ? 2 : 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: hasText
              ? (canSend ? () => _handleSubmit(widget.controller.text) : null)
              : () {/* TODO: Implement microphone action */},
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: widget.isLoading
                  ? const SizedBox(
                      key: ValueKey('loader'),
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Icon(
                      hasText ? Icons.send_rounded : Icons.mic,
                      key: ValueKey(hasText ? 'send' : 'mic'),
                      color: hasText ? Colors.white : AiTheme.secondaryColor,
                      size: 24,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  bool _canSend() {
    return widget.enabled &&
        !widget.isLoading &&
        widget.controller.text.trim().isNotEmpty;
  }

  void _handleSubmit(String text) {
    if (_canSend()) {
      HapticFeedback.lightImpact();
      widget.onSend(text.trim());
      widget.controller.clear();
      _focusNode.requestFocus();
    }
  }
}
