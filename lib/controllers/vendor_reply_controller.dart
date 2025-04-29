import 'package:get/get.dart';

class VendorReplyController extends GetxController {
  var replyText = ''.obs;

  void updateReply(String text) {
    replyText.value = text;
  }

  void clearReply() {
    replyText.value = '';
  }
}
