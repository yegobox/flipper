import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/ai_theme.dart';
import 'package:flipper_services/keyboard_service.dart';

class AiInputField extends StatefulWidget {
  final TextEditingController controller;
  final bool isLoading;
  final Function(String) onSend;

  const AiInputField({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  @override
  State<AiInputField> createState() => _AiInputFieldState();
}

class _AiInputFieldState extends State<AiInputField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  /// Handles focus change to listen to keyboard events
  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    } else {
      HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    }
  }

  /// Handles keyboard events
  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      KeyboardService.handleKeyDown(event);
      if (KeyboardService.shouldSendMessage()) {
        _handleSubmit(widget.controller.text);
      }
    } else if (event is KeyUpEvent) {
      KeyboardService.handleKeyUp(event);
    }

    return false; // Returning false allows other handlers to process the event.
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AiTheme.inputBackgroundColor,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Focus(
              focusNode: _focusNode,
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                decoration: const InputDecoration(
                  hintText: 'Type your message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
            ),
          ),
          const SizedBox(width: 8),
          _buildSendButton(),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return IconButton(
      icon: widget.isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AiTheme.primaryColor),
              ),
            )
          : Icon(Icons.send, color: AiTheme.primaryColor),
      onPressed:
          widget.isLoading ? null : () => _handleSubmit(widget.controller.text),
    );
  }

  void _handleSubmit(String text) {
    if (text.trim().isNotEmpty && !widget.isLoading) {
      widget.onSend(text.trim());
      widget.controller.clear();
    }
  }
}
