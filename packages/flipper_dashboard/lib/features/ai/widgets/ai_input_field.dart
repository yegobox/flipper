import 'package:flutter/material.dart';
import '../theme/ai_theme.dart';

/// Input field widget for the AI feature that handles:
/// - Message input with send button
/// - Loading state during AI response
/// - Submit on Enter key
class AiInputField extends StatelessWidget {
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
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Type your message...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
              maxLines: null,
              onSubmitted: _handleSubmit,
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
      icon: isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AiTheme.primaryColor),
              ),
            )
          : Icon(Icons.send, color: AiTheme.primaryColor),
      onPressed: isLoading ? null : () => _handleSubmit(controller.text),
    );
  }

  void _handleSubmit(String text) {
    if (text.isNotEmpty && !isLoading) {
      onSend(text);
    }
  }
}
