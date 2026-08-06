import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/providers/auth_provider.dart';
import '../../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final AuthProvider _authProvider = AuthProvider();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;

  void register() async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill in all required fields', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;
      await _authProvider.registerCustomer(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone.isNotEmpty ? phone : null,
      );

      // Navigate to OTP verification page
      Get.toNamed(Routes.OTP_VERIFY, arguments: {'email': email});
    } catch (e) {
      Get.snackbar('Registration Failed', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    Get.back();
  }
}
