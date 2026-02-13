import 'dart:async';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_models/brick/models/message.model.dart';
import 'package:intl/intl.dart';
import 'package:markdown_widget/markdown_widget.dart';

import '../utils/visualization_utils.dart';

import '../theme/ai_theme.dart';
import 'data_visualization.dart';
import 'package:flipper_dashboard/features/credits/dialogs/credit_purchase_dialog.dart';

/// A chat message bubble with a modern and clean design.
class MessageBubble extends StatefulWidget {
  final Message message;
  final bool isUser;

  const MessageBubble({Key? key, required this.message, required this.isUser})
    : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _isHovering = false;
  bool _showCopied = false;
  final GlobalKey _visualizationKey = GlobalKey();
  Timer? _copiedTimer;

  Future<void> _copyToClipboard() async {
    if (_shouldShowDataVisualization(widget.message.text)) {
      // If it's a visualization, capture and copy the image
      VisualizationUtils.copyToClipboard(
        context,
        _visualizationKey,
        onSuccess: _handleCopySuccess,
      );
    } else {
      // If it's plain text, copy the text
      final text = widget.message.text;
      await Clipboard.setData(ClipboardData(text: text));
      _handleCopySuccess();
    }
  }

  void _handleCopySuccess() {
    if (!mounted) return;
    setState(() {
      _showCopied = true;
    });

    // Cancel any existing timer before creating a new one
    _copiedTimer?.cancel();
    _copiedTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showCopied = false;
        });
      }
    });
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _copiedTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasVisualization = _shouldShowDataVisualization(widget.message.text);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: widget.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!widget.isUser) _buildAvatar(Icons.smart_toy_rounded),
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: widget.isUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  MouseRegion(
                    onEnter: (_) => setState(() => _isHovering = true),
                    onExit: (_) => setState(() => _isHovering = false),
                    child: Stack(
                      alignment: widget.isUser
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      children: [
                        Container(
                          padding: EdgeInsets.all(hasVisualization ? 0 : 14),
                          decoration: BoxDecoration(
                            color: widget.isUser
                                ? AiTheme.userMessageColor
                                : (widget.message.messageSource == 'whatsapp'
                                      ? AiTheme.whatsAppBubbleColor
                                      : AiTheme.assistantMessageColor),
                            borderRadius: BorderRadius.circular(16),
                            border:
                                (!widget.isUser &&
                                    widget.message.messageSource == 'whatsapp')
                                ? Border(
                                    left: BorderSide(
                                      color: AiTheme.whatsAppGreen,
                                      width: 3,
                                    ),
                                  )
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              hasVisualization
                                  ? DataVisualization(
                                      data: widget.message.text,
                                      currency: ProxyService.box
                                          .defaultCurrency(),
                                      cardKey: _visualizationKey,
                                      onCopyGraph: _copyToClipboard,
                                    )
                                  : MarkdownWidget(
                                      data: widget.message.text,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      config: MarkdownConfig(
                                        configs: [
                                          PConfig(
                                            textStyle: TextStyle(
                                              color: widget.isUser
                                                  ? AiTheme.onPrimaryColor
                                                  : AiTheme
                                                        .onAssistantMessageColor,
                                              fontSize: 16,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              if (widget.message.text.contains(
                                "purchase credits",
                              ))
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => CreditPurchaseDialog(
                                          onPaymentSuccess: () {
                                            Navigator.pop(
                                              context,
                                            ); // Close dialog
                                            _showSnackBar(
                                              "Payment successful! You can now retry your request.",
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AiTheme.primaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text("Purchase Credits"),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (_isHovering && !hasVisualization)
                          Positioned(
                            top: -10,
                            right: widget.isUser ? 0 : null,
                            left: widget.isUser ? null : 0,
                            child: _buildCopyButton(),
                          ),
                      ],
                    ),
                  ),
                  // WhatsApp indicator and contact name
                  if (widget.message.messageSource == 'whatsapp')
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 4, right: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AiTheme.whatsAppGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AiTheme.whatsAppGreen.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_rounded,
                              size: 12,
                              color: AiTheme.whatsAppGreen,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.message.contactName ??
                                  widget.message.phoneNumber,
                              style: TextStyle(
                                fontSize: 11,
                                color: AiTheme.whatsAppDarkGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTimestamp(widget.message.timestamp),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AiTheme.hintColor,
                          ),
                        ),
                        // Delivery status for WhatsApp user messages
                        if (widget.message.messageSource == 'whatsapp' &&
                            widget.isUser) ...[
                          const SizedBox(width: 4),
                          Icon(
                            widget.message.delivered
                                ? Icons.done_all_rounded
                                : Icons.check_rounded,
                            size: 14,
                            color: widget.message.delivered
                                ? AiTheme.whatsAppGreen
                                : AiTheme.hintColor,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.isUser) _buildAvatar(Icons.person_rounded),
        ],
      ),
    );
  }

  Widget _buildCopyButton() {
    return AnimatedOpacity(
      opacity: _isHovering ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        decoration: BoxDecoration(
          color: AiTheme.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 5,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: _copyToClipboard,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _showCopied ? Icons.check_rounded : Icons.copy_outlined,
                    size: 16,
                    color: _showCopied ? Colors.green : AiTheme.secondaryColor,
                  ),
                  if (_showCopied)
                    const Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Text(
                        'Copied',
                        style: TextStyle(fontSize: 12, color: Colors.green),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _shouldShowDataVisualization(String messageText) {
    return messageText.contains('{{VISUALIZATION_DATA}}');
  }

  Widget _buildAvatar(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: widget.isUser
            ? AiTheme.primaryColor.withValues(alpha: 0.1)
            : AiTheme.inputBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          icon,
          size: 20,
          color: widget.isUser ? AiTheme.primaryColor : AiTheme.secondaryColor,
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';
    return DateFormat('h:mm a').format(timestamp);
  }
}
