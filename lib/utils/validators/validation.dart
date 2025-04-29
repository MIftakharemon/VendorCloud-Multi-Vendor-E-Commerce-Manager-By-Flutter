import 'package:email_validator/email_validator.dart';

class Validator {
  static String validateEmptyText(String fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return '';
  }
  static String validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }

    if (!EmailValidator.validate(value.trim())) {
      return 'Invalid email address.';
    }


    return '';
  }
  static String validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }


    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }


    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }


    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }


    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }

    return '';
  }
  static String? validateEmailForLogin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }


    if (!EmailValidator.validate(value.trim())) {
      return 'Invalid email address.';
    }


    return null;
  }
  static String validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }


    final phoneRegExp = RegExp(r'^\d{9}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (9 digits required).';
    }

    return '';
  }
}
