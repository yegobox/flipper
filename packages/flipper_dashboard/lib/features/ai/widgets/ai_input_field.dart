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
  late AnimationController _buttonAnimationController;

  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    widget.controller.addListener(_handleTextChange);
    _hasText = widget.controller.text.isNotEmpty;
    if (_hasText) {
      _buttonAnimationController.value = 1.0;
    }
    _focusNode.onKey = _handleKeyEvent;
  }

  @override
  void dispose() {
    _focusNode.onKey = null;
    widget.controller.removeListener(_handleTextChange);
    _focusNode.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
      if (hasText) {
        _buttonAnimationController.forward();
      } else {
        _buttonAnimationController.reverse();
      }
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter &&
          (event.isControlPressed || event.isMetaPressed)) {
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
            Expanded(child: _buildInputField()),
            const SizedBox(width: 12),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      decoration: BoxDecoration(
        color: AiTheme.inputBackgroundColor,
        borderRadius: BorderRadius.circular(16),
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
        ),
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }

  Widget _buildSendButton() {
    final canSend = _canSend();
    return ScaleTransition(
      scale:
          _buttonAnimationController.drive(CurveTween(curve: Curves.easeOut)),
      child: SizedBox(
        width: 52,
        height: 48,
        child: Material(
          color: canSend ? AiTheme.primaryColor : AiTheme.inputBackgroundColor,
          borderRadius: BorderRadius.circular(26),
          elevation: canSend ? 2 : 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(26),
            onTap: canSend ? () => _handleSubmit(widget.controller.text) : null,
            child: Center(
              child: widget.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Icon(
                      Icons.send_rounded,
                      color: canSend ? Colors.white : AiTheme.hintColor,
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
