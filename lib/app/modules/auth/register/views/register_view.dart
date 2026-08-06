import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../core/widgets/gm_button.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    R.init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(R.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Join Grandmart',
                style: TextStyle(
                  fontSize: R.sp(24),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create an account to start shopping',
                style: TextStyle(
                  fontSize: R.sp(14),
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),

              // Full Name
              Text('Full Name *', style: TextStyle(fontSize: R.sp(14), fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.fullNameController,
                decoration: const InputDecoration(
                  hintText: 'John Doe',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),

              // Email
              Text('Email Address *', style: TextStyle(fontSize: R.sp(14), fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'name@example.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // Phone
              Text('Phone Number (Optional)', style: TextStyle(fontSize: R.sp(14), fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: '+880 1700 000000',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // Password
              Text('Password *', style: TextStyle(fontSize: R.sp(14), fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'at least 6 characters',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              Obx(
                () => GMButton(
                  text: 'Create Account',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.register,
                ),
              ),
              const SizedBox(height: 24),

              // Already have an account? Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: controller.goToLogin,
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
