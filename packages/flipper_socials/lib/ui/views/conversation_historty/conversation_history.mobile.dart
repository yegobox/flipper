import 'package:flutter/material.dart';

class ConversationHistory extends StatefulWidget {
  const ConversationHistory({super.key, required this.conversationId});
  final String conversationId;

  @override
  State<ConversationHistory> createState() => _ConversationHistoryState();
}

class _ConversationHistoryState extends State<ConversationHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation History'),
      ),
      body: const Center(
        child: Text('Conversation History'),
      ),
    );
  }
}
