import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karmalab_assignment/widgets/custom_input.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomForm extends StatelessWidget {
  final dynamic controller;
  final bool isLogin;
  final bool isEmailLogin;

  const CustomForm({
    super.key,
    required this.controller,
    required this.isLogin,
    required this.isEmailLogin,
  });

  Widget _buildNameField() {
    return CustomInputFelid(
      hint: "Business Name",
      controller: controller.nameTextController,
      decoration: _getInputDecoration(),
    );
  }

  Widget _buildLoginField() {
    return CustomInputFelid(
      hint: isEmailLogin ? "Email/Phone" : "Phone Number",
      controller: isEmailLogin ? controller.emailController : controller.phoneController,
      keyboardType: isEmailLogin ? TextInputType.emailAddress : TextInputType.phone,
      decoration: _getInputDecoration(),
    );
  }
  Widget _buildEmailField() {
    return CustomInputFelid(
      hint: "Email",
      controller: controller.emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: _getInputDecoration(),
    );
  }

  Widget _buildPasswordField() {
    return Obx(() => CustomInputFelid(
      hint: "Password",
      controller: controller.passwordController,
      isPassWord: true,
      secure: !controller.isPasswordVisible,
      toggle: controller.togglePasswordVisibility,
      decoration: _getInputDecoration(),
    ));
  }

  Widget _buildConfirmPasswordField() {
    return Obx(() => CustomInputFelid(
      hint: "Confirm Password",
      controller: controller.conformPasswordController,
      isPassWord: true,
      secure: !controller.isConformPasswordVisible,
      lowerMargin: true,
      toggle: controller.toggleConformPasswordVisibility,
      decoration: _getInputDecoration(),
    ));
  }

  InputDecoration _getInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 1),
      ),
    );
  }

  Widget _buildOtpField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: PinCodeTextField(
        appContext: context,
        length: 4,
        obscureText: false,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          activeFillColor: Colors.white,
          inactiveFillColor: Colors.grey[100],
          selectedFillColor: Colors.white,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
          selectedColor: Colors.blue,
        ),
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.transparent,
        enableActiveFill: true,
        onCompleted: controller.updateOtpValue,
        onChanged: controller.updateOtpValue,
        beforeTextPaste: (_) => true,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        keyboardType: TextInputType.number,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isLogin) _buildNameField(),
        if (isLogin)
          _buildLoginField()
        else
          _buildEmailField(),
        if (isEmailLogin && isLogin) _buildPasswordField(),
        if (isLogin && !isEmailLogin) _buildOtpField(context),
        if (!isLogin) ...[
          _buildPasswordField(),
          _buildConfirmPasswordField(),
        ],
      ],
    );
  }
}
