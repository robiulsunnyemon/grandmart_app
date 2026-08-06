import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/providers/auth_provider.dart';
import '../../../../routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  final AuthProvider _authProvider = AuthProvider();

  // Step 1: Email, Step 2: OTP, Step 3: New Password
  final currentStep = 1.obs;

  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();

  final isLoading = false.obs;
  String resetToken = '';

  void submitEmail() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar('Error', 'Please enter your registered email address', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;
      await _authProvider.forgotPassword(email);
      currentStep.value = 2;
      Get.snackbar('OTP Sent', 'A 6-digit password reset OTP code has been sent to your email', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Failed', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void submitOtp() async {
    final otp = otpController.text.trim();
    if (otp.length != 6) {
      Get.snackbar('Error', 'Please enter valid 6-digit OTP code', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;
      resetToken = await _authProvider.verifyResetOtp(
        email: emailController.text.trim(),
        otpCode: otp,
      );
      currentStep.value = 3;
      Get.snackbar('OTP Verified', 'Please enter your new password', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Verification Failed', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void submitNewPassword() async {
    final newPassword = newPasswordController.text.trim();
    if (newPassword.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;
      await _authProvider.resetPassword(
        resetToken: resetToken,
        newPassword: newPassword,
      );
      Get.snackbar('Success', 'Password has been reset successfully. Please sign in.', snackPosition: SnackPosition.BOTTOM);
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar('Reset Failed', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
