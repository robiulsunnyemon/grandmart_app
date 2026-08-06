import 'package:dio/dio.dart';
import '../../core/config/api_config.dart';
import '../../core/network/dio_client.dart';
import '../models/user_model.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Authentication Provider
// ════════════════════════════════════════════════════════════════════════════

class AuthProvider {
  final DioClient _client = DioClient();

  Future<UserModel> registerCustomer({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    final response = await _client.instance.post(
      ApiConfig.register,
      data: {
        'full_name': fullName,
        'email': email,
        'password': password,

        'phone': phone,
      },
    );
    return UserModel.fromJson(response.data);
  }

  Future<AuthTokenModel> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    final response = await _client.instance.post(
      ApiConfig.verifyOtp,
      data: {
        'email': email,
        'otp_code': otpCode,
      },
    );
    return AuthTokenModel.fromJson(response.data);
  }

  Future<void> resendOtp(String email) async {
    await _client.instance.post(
      ApiConfig.resendOtp,
      data: {'email': email},
    );
  }

  Future<AuthTokenModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.instance.post(
      ApiConfig.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    return AuthTokenModel.fromJson(response.data);
  }

  Future<void> forgotPassword(String email) async {
    await _client.instance.post(
      ApiConfig.forgotPassword,
      data: {'email': email},
    );
  }

  Future<String> verifyResetOtp({
    required String email,
    required String otpCode,
  }) async {
    final response = await _client.instance.post(
      ApiConfig.verifyResetOtp,
      data: {
        'email': email,
        'otp_code': otpCode,
      },
    );
    return response.data['reset_token'] ?? '';
  }

  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    await _client.instance.post(
      ApiConfig.resetPassword,
      data: {
        'reset_token': resetToken,
        'new_password': newPassword,
      },
    );
  }

  Future<UserModel> getMe() async {
    final response = await _client.instance.get(ApiConfig.me);
    return UserModel.fromJson(response.data);
  }
}
