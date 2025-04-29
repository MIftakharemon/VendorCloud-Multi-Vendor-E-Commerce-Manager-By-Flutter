
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/controllers/user_controller.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../models/chat_model.dart';
import '../services/chat_service.dart';
class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  final UserController userController = Get.find<UserController>();
  RxBool isLoading = false.obs;  // Add this back
  RxList<User> chatUsers = <User>[].obs;
  Rx<Chat?> currentChat = Rx<Chat?>(null);
  RxList<Chat?> currentChats = <Chat?>[].obs;
  final messageController = TextEditingController();
  String? currentUserId;
  String? currentAdminId;

  @override
  void onInit() {
    super.onInit();
    fetchChatUsers();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }



  void refreshChatList() {
    fetchChatUsers();
  }
  Future<void> fetchChatUsers() async {
    final users = await _chatService.getChatUsers();
    chatUsers.assignAll(users);
  }

  Future<void> fetchChat(String userId, String adminId) async {
    currentUserId = userId;
    currentAdminId = adminId;
    final chats = await _chatService.fetchChat(userId, adminId);
    if (chats != null && chats.isNotEmpty) {
      currentChats.assignAll(chats);
    }
  }

  List<Datum> getAllMessages() {
    List<Datum> allMessages = [];
    if (currentChats.isNotEmpty) {
      for (var chat in currentChats) {
        if (chat != null && chat.data != null) {
          allMessages.addAll(chat.data);
        }
      }
    }
    return allMessages..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future<bool> sendMessage({
    required String replyToId,
    required String message,
  }) async {
    if (message.trim().isEmpty) return false;

    final requestBody = {
      "user": userController.user.value!.id,
      "replyTo": replyToId,
      "title": "1",
      "message": message
    };

    final success = await _chatService.createChat(requestBody);
    if (success) {
      messageController.clear();
      fetchChat(currentUserId!, currentAdminId!);
    }
    return success;
  }
}
