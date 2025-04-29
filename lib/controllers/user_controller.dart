import 'package:get/get.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  var user = Rxn<UserModel>();

  void setUser(UserModel newUser) {
    user.value = newUser;
  }
  void clearUser() {
    user.value = null;
  }

  Map<String, dynamic> getProfileCompletionStatus() {
    if (user.value == null) {
      return {
        'percentage': 0.0,
        'missingFields': [
          'Name',
          'Email',
          'Cover Photo',
          'Phone Number',
          'ID Card Front',
          'ID Card Back',
          'Bank Statement',
          'Gender'
        ]
      };
    }

    final userData = user.value!;
    final List<String> missingFields = [];
    int completedFields = 0;
    int totalFields = 8;

    if (userData.name.isNotEmpty) {
      completedFields++;
    } else {
      missingFields.add('Name');
    }

    if (userData.email.isNotEmpty) {
      completedFields++;
    } else {
      missingFields.add('Email');
    }

    if (userData.avatar.isNotEmpty) {
      completedFields++;
    } else {
      missingFields.add('Cover Photo');
    }

    if (userData.phoneNumber?.isNotEmpty == true) {
      completedFields++;
    } else {
      missingFields.add('Phone Number');
    }

    if (userData.idCardFrontPageImage?.isNotEmpty == true) {
      completedFields++;
    } else {
      missingFields.add('ID Card Front');
    }
    if (userData.idCardBackPageImage?.isNotEmpty == true) {
      completedFields++;
    } else {
      missingFields.add('ID Card Back');
    }
    if (userData.bankStatementImage?.isNotEmpty == true) {
      completedFields++;
    } else {
      missingFields.add('Bank Statement');
    }

    if (userData.gender?.isNotEmpty == true) {
      completedFields++;
    } else {
      missingFields.add('Gender');
    }
    return {
      'percentage': (completedFields / totalFields) * 100,
      'missingFields': missingFields
    };
  }
}
