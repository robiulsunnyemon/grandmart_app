import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../data/providers/auth_provider.dart';
import '../../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthProvider _authProvider = AuthProvider();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;
      final tokenModel = await _authProvider.login(email: email, password: password);
      await StorageService.to.saveTokens(
        access: tokenModel.accessToken,
        refresh: tokenModel.refreshToken,
      );
      await StorageService.to.saveUserData(tokenModel.user.toJson());

      Get.offAllNamed(Routes.MAIN_WRAPPER);
    } catch (e) {
      Get.snackbar('Login Failed', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  void goToForgotPassword() {
    Get.toNamed(Routes.FORGOT_PASSWORD);
  }
}
