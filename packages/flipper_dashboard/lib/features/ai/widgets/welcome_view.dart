import 'package:flutter/material.dart';
import '../theme/ai_theme.dart';

class WelcomeView extends StatelessWidget {
  final Function(String) onSend;

  const WelcomeView({super.key, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final sampleQuestions = [
      'What were my total sales last week?',
      'Show me a breakdown of my top-selling products this month.',
      'Generate a tax summary for the last quarter.',
    ];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AiTheme.primaryColor.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: AiTheme.primaryColor,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Business AI Assistant',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AiTheme.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Ready to help you with insights about your business. Try asking one of the questions below.',
              style: TextStyle(
                fontSize: 16,
                color: AiTheme.hintColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ...sampleQuestions.map((q) => _buildSampleQuestion(context, q)),
          ],
        ),
      ),
    );
  }

  Widget _buildSampleQuestion(BuildContext context, String question) {
    return GestureDetector(
      onTap: () => onSend(question),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AiTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AiTheme.borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                question,
                style: const TextStyle(
                  fontSize: 14,
                  color: AiTheme.textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AiTheme.hintColor,
            ),
          ],
        ),
      ),
    );
  }
}
