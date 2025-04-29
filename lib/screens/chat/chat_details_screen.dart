import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';

import '../../controllers/chat_controller.dart';
import '../../models/chat_model.dart';
import '../../models/product_model.dart';

class ChatDetailScreen extends GetView<ChatController> {
  final String userId;
  final String adminId;
  final User user;
  final ScrollController _scrollController = ScrollController();

  ChatDetailScreen({
    Key? key,
    required this.userId,
    required this.adminId,
    required this.user,
  }) : super(key: key) {
    Get.put(ChatController());
    controller.fetchChat(userId, adminId);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildMessageList(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return Expanded(
      child: GetX<ChatController>(
        builder: (controller) {
          final messages = controller.getAllMessages();
          if (messages.isEmpty) {
            return const Center(
              child: Text('No messages yet. Start a conversation!'),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: messages.length,
            itemBuilder: (context, index) => _buildMessageItem(messages[index])
                .animate()
                .fadeIn(
              duration: Duration(milliseconds: 1400),
              delay: Duration(milliseconds: 100 * index),
              curve: Curves.easeOutQuart,
            )
                .slideY(
              begin: 0.3,
              end: 0,
              duration: Duration(milliseconds: 1400),
              delay: Duration(milliseconds: 100 * index),
              curve: Curves.easeOutQuart,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageItem(Datum message) {
    final isMe = message.user.sId == userId;
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            _buildAvatar(message.user),
            SizedBox(width: 8),
          ],
          _buildMessageBubble(message, isMe),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: _handleSendMessage,
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.send),
              color: Colors.blue,
              onPressed: () => _handleSendMessage(controller.messageController.text),
            ),
          ],
        ),
      ),
    ).animate()
        .fadeIn(
      duration: Duration(milliseconds: 1400),
      curve: Curves.easeOutQuart,
    )
        .slideY(
      begin: 1,
      end: 0,
      duration: Duration(milliseconds: 1200),
      curve: Curves.easeOutQuart,
    );
  }
  void _handleSendMessage(String message) {
    if (message.trim().isNotEmpty) {
      controller.sendMessage(
        replyToId: adminId,
        message: message,
      ).then((_) => _scrollToBottom());
    }
  }

  // Helper widgets
  PreferredSizeWidget _buildAppBar() => AppBar(
    leadingWidth: 30,
    title: Row(
      children: [
        _buildAvatar(user),
        SizedBox(width: 12),
        _buildUserInfo(),
      ],
    ),
  );


  Widget _buildAvatar(User user) => CircleAvatar(
    radius: 20,
    backgroundImage: (user.avatar?.secureUrl != null &&
        user.avatar!.secureUrl!.isNotEmpty)
        ? NetworkImage('https://readyhow.com/${user.avatar!.secureUrl}')
        : const AssetImage('assets/images/content/user.png') as ImageProvider,
  );

  Widget _buildUserInfo() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        user.name ?? '',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red, width: 1),
        ),
        child: Text(
          user.role?.toUpperCase() ?? '',
          style: TextStyle(
            color: Colors.red,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );

  Widget _buildMessageBubble(Datum message, bool isMe) => Container(
    constraints: BoxConstraints(
      maxWidth: Get.width * 0.7,
    ),
    padding: EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    decoration: BoxDecoration(
      color: isMe ? Colors.blue[100] : Colors.grey[200],
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomLeft: isMe ? Radius.circular(20) : Radius.circular(0),
        bottomRight: isMe ? Radius.circular(0) : Radius.circular(20),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message.message,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4),
        Text(
          DateFormat('hh:mm a').format(message.createdAt),
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    ),
  );
}

