import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../core/widgets/gm_button.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    R.init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(R.pagePadding),
          child: Obx(() {
            switch (controller.currentStep.value) {
              case 1:
                return _buildStep1(context);
              case 2:
                return _buildStep2(context);
              case 3:
                return _buildStep3(context);
              default:
                return _buildStep1(context);
            }
          }),
        ),
      ),
    );
  }

  Widget _buildStep1(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Forgot Password?',
          style: TextStyle(fontSize: R.sp(22), fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your email address to receive a 6-digit verification code.',
          style: TextStyle(fontSize: R.sp(14), color: Colors.grey),
        ),
        const SizedBox(height: 32),
        Text('Email Address', style: TextStyle(fontSize: R.sp(14), fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'name@example.com',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: 32),
        Obx(
          () => GMButton(
            text: 'Send OTP Code',
            isLoading: controller.isLoading.value,
            onPressed: controller.submitEmail,
          ),
        ),
      ],
    );
  }

  Widget _buildStep2(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verify OTP Code',
          style: TextStyle(fontSize: R.sp(22), fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter the 6-digit code sent to ${controller.emailController.text}',
          style: TextStyle(fontSize: R.sp(14), color: Colors.grey),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: controller.otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: R.sp(24), fontWeight: FontWeight.bold, letterSpacing: 12),
          decoration: const InputDecoration(hintText: '──────', counterText: ''),
        ),
        const SizedBox(height: 32),
        Obx(
          () => GMButton(
            text: 'Verify Code',
            isLoading: controller.isLoading.value,
            onPressed: controller.submitOtp,
          ),
        ),
      ],
    );
  }

  Widget _buildStep3(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set New Password',
          style: TextStyle(fontSize: R.sp(22), fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Create a strong password for your account.',
          style: TextStyle(fontSize: R.sp(14), color: Colors.grey),
        ),
        const SizedBox(height: 32),
        Text('New Password', style: TextStyle(fontSize: R.sp(14), fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.newPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'at least 6 characters',
            prefixIcon: Icon(Icons.lock_outline),
          ),
        ),
        const SizedBox(height: 32),
        Obx(
          () => GMButton(
            text: 'Reset Password',
            isLoading: controller.isLoading.value,
            onPressed: controller.submitNewPassword,
          ),
        ),
      ],
    );
  }
}
