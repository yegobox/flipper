import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_models/brick/models/message.model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:pasteboard/pasteboard.dart';

import '../theme/ai_theme.dart';
import 'data_visualization.dart';

/// A chat message bubble with a modern and clean design.
class MessageBubble extends StatefulWidget {
  final Message message;
  final bool isUser;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isUser,
  }) : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _isHovering = false;
  bool _showCopied = false;
  final GlobalKey _visualizationKey = GlobalKey();

  Future<void> _copyToClipboard() async {
    if (_shouldShowDataVisualization(widget.message.text)) {
      // If it's a visualization, capture and copy the image
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          RenderRepaintBoundary? boundary = _visualizationKey.currentContext
              ?.findRenderObject() as RenderRepaintBoundary?;
          if (boundary == null) {
            _showSnackBar('Error: Could not find render object.');
            return;
          }

          ui.Image image = await boundary.toImage(pixelRatio: 3.0);
          ByteData? byteData =
              await image.toByteData(format: ui.ImageByteFormat.png);
          if (byteData == null) {
            _showSnackBar('Error: Could not convert image to bytes.');
            return;
          }

          await Pasteboard.writeImage(byteData.buffer.asUint8List());

          _showSnackBar('Graph copied to clipboard!');
        } catch (e) {
          _showSnackBar('Failed to copy graph: $e');
        }
      });
    } else {
      // If it's plain text, copy the text
      final text = widget.message.text;
      await Clipboard.setData(ClipboardData(text: text));
      _showSnackBar('Text copied to clipboard!');
    }

    setState(() {
      _showCopied = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showCopied = false;
        });
      }
    });
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasVisualization = _shouldShowDataVisualization(widget.message.text);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
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
                                : AiTheme.assistantMessageColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: hasVisualization
                              ? DataVisualization(
                                  data: widget.message.text,
                                  currency: ProxyService.box.defaultCurrency(),
                                  cardKey: _visualizationKey,
                                  onCopyGraph: _copyToClipboard,
                                )
                              : Text(
                                  widget.message.text,
                                  style: TextStyle(
                                    color: widget.isUser
                                        ? AiTheme.onPrimaryColor
                                        : AiTheme.onAssistantMessageColor,
                                    fontSize: 16,
                                    height: 1.4,
                                  ),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4, right: 4),
                    child: Text(
                      _formatTimestamp(widget.message.timestamp),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AiTheme.hintColor,
                      ),
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
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
            )
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
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                        ),
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
            ? AiTheme.primaryColor.withOpacity(0.1)
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