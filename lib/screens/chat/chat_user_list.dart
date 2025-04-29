import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/user_controller.dart';
import '../../utils/constants/colors.dart';
import 'chat_details_screen.dart';

class ChatListScreen extends StatelessWidget {
  static const routeName = "/chat_user_list_screen";
  final ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: Obx(() {
        if (chatController.chatUsers.isEmpty) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: AppColors.primary,
              size: 40,
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          itemCount: chatController.chatUsers.length,
          itemBuilder: (context, index) {
            final user = chatController.chatUsers[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => ChatDetailScreen(
                    userId: Get.find<UserController>().user.value!.id??'',
                    adminId: user.sId??'',
                    user: user,
                  ));
                },
                child: Card(
                  elevation: 0.5,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundImage: (user.avatar?.secureUrl != null &&
                            user.avatar!.secureUrl!.isNotEmpty)
                            ? NetworkImage('https://readyhow.com/${user.avatar!.secureUrl}')
                            : const AssetImage('assets/images/content/user.png') as ImageProvider,
                        onBackgroundImageError: (_, __) {},
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            user.name ?? '',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Admin',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        'See the conversations',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
            ).animate()
                .fadeIn(
              duration: Duration(milliseconds: 1400),
              delay: Duration(milliseconds: 300 * index),
              curve: Curves.easeOutQuart,
            )
                .slideY(
              begin: 0.5,
              end: 0,
              duration: Duration(milliseconds: 1400),
              delay: Duration(milliseconds: 300 * index),
              curve: Curves.easeOutQuart,
            );
          },
        );
      }),
    );
  }
}
