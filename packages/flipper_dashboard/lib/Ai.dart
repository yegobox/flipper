import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/providers/ai_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

class Ai extends ConsumerStatefulWidget {
  // Changed to ConsumerStatefulWidget
  @override
  ConsumerState<Ai> createState() => _AiState(); // Changed to ConsumerState
}

class _AiState extends ConsumerState<Ai> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  bool _showSidebar = true;
  // Default branch ID, replace with your logic to select the branch

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF2D2D2D), // Dark background color
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Model selector button
          Container(
            margin: EdgeInsets.only(right: 8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF3D3D3D),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.psychology, size: 16, color: Colors.white70),
                SizedBox(width: 6),
                Text(
                  'DeepThink (R1)',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Search/Web button
          Container(
            margin: EdgeInsets.only(right: 8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF3D3D3D),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.language, size: 16, color: Colors.white70),
                SizedBox(width: 6),
                Text(
                  'Search',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Text input
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          // Right side icons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.lightbulb_outline, color: Colors.white70),
                onPressed: () {},
                padding: EdgeInsets.all(8),
                constraints: BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.white70),
                onPressed: () {},
                padding: EdgeInsets.all(8),
                constraints: BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              Container(
                margin: EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF4355B7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_upward, color: Colors.white),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      sendMessage(_controller.text);
                    }
                  },
                  padding: EdgeInsets.all(8),
                  constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> sendMessage(String message) async {
    setState(() {
      _messages.add({"role": "user", "text": message});
      _isLoading = true;
    });

    _scrollToBottom();

    // Construct the prompt using the user's message and get gemini ai response
    final geminiResponse =
        await ref.read(geminiBusinessAnalyticsResponseProvider(
      ProxyService.box.getBranchId()!, // Pass branchId from widget in here
      message,
    ).future);

    // Add the bot's reply to the messages
    setState(() {
      _messages.add({"role": "bot", "text": geminiResponse});
    });

    setState(() {
      _isLoading = false;
    });

    _controller.clear();

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      color: Colors.white,
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
                backgroundColor: Colors.blue[600],
                minimumSize: Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'New Chat',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Chats',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // Add your chat history items here
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, String> message) {
    final isUser = message["role"] == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[600] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isUser ? null : Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Added to push the copy icon to the end
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          isUser ? Colors.blue[700] : Colors.grey[100],
                      radius: 16,
                      child: Icon(
                        isUser ? Icons.person : Icons.smart_toy,
                        size: 20,
                        color: isUser ? Colors.white : Colors.blue[600],
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      isUser ? 'You' : 'Aurora Ai',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                if (!isUser) // Show copy icon for bot messages only
                  IconButton(
                    icon: Icon(Icons.copy,
                        color: isUser ? Colors.white : Colors.blue[600]),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () {
                      // Copy the message to the clipboard
                      Clipboard.setData(ClipboardData(text: message["text"]!));
                      // Show a snackbar to indicate that the text has been copied
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                  ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              message["text"]!,
              style: TextStyle(
                fontSize: 15,
                color: isUser ? Colors.white : Colors.black87,
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
      body: Row(
        children: [
          if (_showSidebar && MediaQuery.of(context).size.width > 768)
            _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                // Header
                Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!),
                    ),
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
                        'Ai',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Messages
                Expanded(
                  child: Container(
                    color: Colors.grey[50],
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessageBubble(_messages[index]);
                      },
                    ),
                  ),
                ),
                // Loading indicator
                if (_isLoading)
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  ),
                // Input area
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildInputField(),
                      ),
                      SizedBox(width: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
