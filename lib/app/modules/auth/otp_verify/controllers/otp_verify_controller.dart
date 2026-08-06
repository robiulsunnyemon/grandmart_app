import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../data/providers/auth_provider.dart';
import '../../../../routes/app_pages.dart';

class OtpVerifyController extends GetxController {
  final AuthProvider _authProvider = AuthProvider();

  final otpController = TextEditingController();
  final isLoading = false.obs;
  final isResending = false.obs;

  String email = '';

  final timerSeconds = 300.obs; // 5-min TTL timer
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args.containsKey('email')) {
      email = args['email'];
    }
    _startTimer();
  }

  void _startTimer() {
    timerSeconds.value = 300;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  String get formattedTimer {
    final minutes = (timerSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (timerSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void verifyOtp() async {
    final otpCode = otpController.text.trim();
    if (otpCode.length != 6) {
      Get.snackbar('Error', 'Please enter valid 6-digit OTP code', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;
      final tokenModel = await _authProvider.verifyOtp(email: email, otpCode: otpCode);
      await StorageService.to.saveTokens(
        access: tokenModel.accessToken,
        refresh: tokenModel.refreshToken,
      );
      await StorageService.to.saveUserData(tokenModel.user.toJson());

      Get.offAllNamed(Routes.MAIN_WRAPPER);
    } catch (e) {
      Get.snackbar('Verification Failed', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void resendOtp() async {
    if (timerSeconds.value > 240) return; // Prevent spam

    try {
      isResending.value = true;
      await _authProvider.resendOtp(email);
      _startTimer();
      Get.snackbar('Success', 'A new 6-digit OTP code has been sent to your email', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Resend Failed', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isResending.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
