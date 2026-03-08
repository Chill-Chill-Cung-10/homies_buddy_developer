import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

/// Login Response Model - Dữ liệu trả về từ server sau khi đăng nhập thành công
@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String accessToken,
    required String refreshToken,
    required UserModel user,
    required String tokenType,
    required int expiresIn, // seconds
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

/// Extension để xử lý token
extension LoginResponseX on LoginResponse {
  /// Lấy Authorization header value
  String get authorizationHeader {
    return '$tokenType $accessToken';
  }

  /// Kiểm tra token có sắp hết hạn không (còn < 5 phút)
  bool get isTokenExpiringSoon {
    return expiresIn < 300; // 5 minutes
  }

  /// Tính thời gian hết hạn
  DateTime get expiryDate {
    return DateTime.now().add(Duration(seconds: expiresIn));
  }
}
