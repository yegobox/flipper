import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/providers/ai_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

class Ai extends ConsumerStatefulWidget {
  @override
  ConsumerState<Ai> createState() => _AiState();
}

class _AiState extends ConsumerState<Ai> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  bool _showSidebar = true;

  // Custom colors
  static const primaryColor = Color(0xFF4355B7);
  static const secondaryColor = Color(0xFF6B7280);
  static const backgroundColor = Color(0xFFF9FAFB);
  static const surfaceColor = Color(0xFFFFFFFF);
  static const inputBackgroundColor = Color(0xFFF3F4F6);

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: inputBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          _buildChipButton(
            icon: Icons.psychology,
            label: 'DeepThink (R1)',
            onPressed: () {}, // Add model selection logic
          ),
          SizedBox(width: 8),
          _buildChipButton(
            icon: Icons.language,
            label: 'Search',
            onPressed: () {}, // Add search functionality
          ),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: Colors.grey[800]),
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Type your message...",
                hintStyle: TextStyle(color: secondaryColor),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) sendMessage(value);
              },
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildChipButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: secondaryColor),
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.lightbulb_outline, color: secondaryColor),
          onPressed: () {}, // Add suggestions functionality
          tooltip: 'Get suggestions',
          padding: EdgeInsets.all(8),
          constraints: BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        IconButton(
          icon: Icon(Icons.refresh, color: secondaryColor),
          onPressed: () {}, // Add reset functionality
          tooltip: 'Reset conversation',
          padding: EdgeInsets.all(8),
          constraints: BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        Container(
          margin: EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_upward, color: Colors.white),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                sendMessage(_controller.text);
              }
            },
            tooltip: 'Send message',
            padding: EdgeInsets.all(8),
            constraints: BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      color: surfaceColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _messages.clear();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'New Chat',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          _buildSidebarHeader('Recent Chats'),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              children: [
                // Add chat history items here
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: secondaryColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, String> message) {
    final isUser = message["role"] == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? primaryColor : surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: isUser ? null : Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: isUser
                          ? primaryColor.withValues(alpha: 0.8)
                          : Colors.grey[100],
                      radius: 16,
                      child: Icon(
                        isUser ? Icons.person : Icons.smart_toy,
                        size: 20,
                        color: isUser ? Colors.white : primaryColor,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      isUser ? 'You' : 'Aurora AI',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isUser ? Colors.white : Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                if (!isUser)
                  Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(Icons.copy,
                          color: isUser ? Colors.white : primaryColor),
                      tooltip: 'Copy message',
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: message["text"]!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Message copied to clipboard'),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12),
            SelectableText(
              message["text"]!,
              style: TextStyle(
                fontSize: 15,
                color: isUser ? Colors.white : Colors.grey[800],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Row(
        children: [
          if (_showSidebar && MediaQuery.of(context).size.width > 768)
            _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _buildMessageList(),
                ),
                if (_isLoading)
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  ),
                _buildInputArea(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          if (MediaQuery.of(context).size.width <= 768)
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                setState(() {
                  _showSidebar = !_showSidebar;
                });
              },
            ),
          Text(
            'AI Assistant',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return Container(
      color: backgroundColor,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(vertical: 16),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          return _buildMessageBubble(_messages[index]);
        },
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: _buildInputField(),
    );
  }

  Future<void> sendMessage(String message) async {
    setState(() {
      _messages.add({"role": "user", "text": message});
      _isLoading = true;
    });

    _scrollToBottom();

    final geminiResponse =
        await ref.read(geminiBusinessAnalyticsResponseProvider(
      ProxyService.box.getBranchId()!,
      message,
    ).future);

    setState(() {
      _messages.add({"role": "bot", "text": geminiResponse});
      _isLoading = false;
    });

    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
