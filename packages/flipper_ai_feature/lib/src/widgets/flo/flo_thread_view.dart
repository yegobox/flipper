import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/message.model.dart';

import '../../models/flo_models.dart';
import '../../theme/flo_theme.dart';
import '../message_bubble.dart';
import 'flo_block_renderer.dart';
import 'flo_mark.dart';
import 'flo_thinking_steps.dart';

class FloThreadView extends StatelessWidget {
  const FloThreadView({
    super.key,
    required this.messages,
    this.thinkingSteps = const [],
    this.thinkingActiveIndex,
    this.isLoading = false,
    this.isMobile = false,
    this.onAsk,
    this.scrollController,
  });

  final List<Message> messages;
  final List<String> thinkingSteps;
  final int? thinkingActiveIndex;
  final bool isLoading;
  final bool isMobile;
  final void Function(String q)? onAsk;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 28,
        vertical: isMobile ? 16 : 26,
      ),
      itemCount: messages.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: FloTheme.contentMaxWidth),
            child: _buildRow(context, index),
          ),
        );
      },
    );
  }

  Widget _buildRow(BuildContext context, int index) {
    if (isLoading && index == messages.length) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FloMark(size: 30, small: true),
            const SizedBox(width: 12),
            Expanded(
              child: FloThinkingSteps(
                steps: thinkingSteps.isEmpty
                    ? const [
                        'Understanding question',
                        'Querying MiniData',
                        'Composing answer',
                      ]
                    : thinkingSteps,
                activeIndex: thinkingActiveIndex,
              ),
            ),
          ],
        ),
      );
    }

    final msg = messages[index];
    final isUser = msg.role == 'user';
    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 22),
          padding: const EdgeInsets.fromLTRB(15, 11, 15, 11),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.78,
          ),
          decoration: BoxDecoration(
            gradient: FloTheme.gradBtn,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(FloTheme.bubbleRadius),
              topRight: Radius.circular(FloTheme.bubbleRadius),
              bottomLeft: Radius.circular(FloTheme.bubbleRadius),
              bottomRight: Radius.circular(6),
            ),
            boxShadow: const [FloTheme.shBlue],
          ),
          child: Text(
            msg.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    if (FloMessagePayload.isFloMessage(msg.text)) {
      final payload = FloMessagePayload.tryParse(msg.text);
      return Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: FloMark(size: 30, small: true),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FloBlockRenderer(
                blocks: payload.blocks,
                onAsk: onAsk,
                isMobile: isMobile,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: MessageBubble(message: msg, isUser: false),
    );
  }
}
