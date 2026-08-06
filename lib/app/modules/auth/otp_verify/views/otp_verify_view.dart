import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../core/widgets/gm_button.dart';
import '../controllers/otp_verify_controller.dart';

class OtpVerifyView extends GetView<OtpVerifyController> {
  const OtpVerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(R.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Enter Verification Code',
                style: TextStyle(
                  fontSize: R.sp(22),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We have sent a 6-digit OTP code to ${controller.email}',
                style: TextStyle(
                  fontSize: R.sp(14),
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 36),

              // OTP Code Field
              TextField(
                controller: controller.otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: R.sp(24),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 12,
                ),
                decoration: const InputDecoration(
                  hintText: '──────',
                  counterText: '',
                ),
              ),
              const SizedBox(height: 24),

              // Countdown Timer
              Center(
                child: Obx(
                  () => Text(
                    'Code expires in: ${controller.formattedTimer}',
                    style: TextStyle(
                      fontSize: R.sp(14),
                      fontWeight: FontWeight.w600,
                      color: controller.timerSeconds.value > 0 ? theme.primaryColor : Colors.red,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Verify Button
              Obx(
                () => GMButton(
                  text: 'Verify & Continue',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.verifyOtp,
                ),
              ),
              const SizedBox(height: 24),

              // Resend Code
              Center(
                child: Obx(
                  () => TextButton(
                    onPressed: controller.timerSeconds.value > 240 ? null : controller.resendOtp,
                    child: Text(
                      controller.isResending.value ? 'Sending...' : 'Resend Code',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
