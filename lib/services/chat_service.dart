import 'package:get/get.dart';
import 'package:karmalab_assignment/models/user_model.dart';
import '../constants/network_constants.dart';
import '../models/chat_model.dart';
import '../models/product_model.dart';
import '../services/base/auth_client.dart';

class ChatService extends GetxController {
  final BaseClient _baseClient = BaseClient();

  Future<List<User>> getChatUsers() async {
    try {
      var response = await _baseClient.get(
        NetworkConstants.getChatUsers,
        header: {'Content-Type': "application/json"},
      ).catchError((error) => print(error));

      if (response != null) {
        List<User> users = (response['body']['data'] as List)
            .map((user) => User.fromJson(user))
            .toList();
        return users;
      }
    } catch (e) {
      Get.snackbar('Error', 'Fetching data $e');
    }
    return [];
  }

  Future<List<Chat?>> fetchChat(String userId, String adminId) async {
    try {
      // Get both chat directions
      var userToAdmin = await _baseClient.get(
        NetworkConstants.getChats(userId, adminId),
        header: {'Content-Type': "application/json"},
      ).catchError((error) => Get.snackbar('Error', 'Failed to create chat: $error'));

      var adminToUser = await _baseClient.get(
        NetworkConstants.getChats(adminId, userId),
        header: {'Content-Type': "application/json"},
      ).catchError((error) => Get.snackbar('Error', 'Failed to create chat: $error'));

      return [
        if (userToAdmin != null) Chat.fromJson(userToAdmin['body']),
        if (adminToUser != null) Chat.fromJson(adminToUser['body'])
      ];
    } catch (e) {
      print('Error fetching chat: $e');
      return [];
    }
  }

  Future<bool> createChat(dynamic object) async {
    try {
      var response = await _baseClient.post(
        NetworkConstants.createChat,
        object,
        header: {'Content-Type': "application/json"},
      ).catchError((error) => Get.snackbar('Error', 'Failed to create chat: $error'));

      return response['body'] != null && response['body'].containsKey('data');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create chat: $e');
    }
    return false;
  }
}
