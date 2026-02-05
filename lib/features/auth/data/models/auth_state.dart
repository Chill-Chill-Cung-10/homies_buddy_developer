import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'auth_state.freezed.dart';

/// Auth State Model - Trạng thái authentication cho Riverpod
/// 
/// Sử dụng Freezed Union types để handle các trạng thái khác nhau:
/// - initial: Chưa có gì
/// - loading: Đang xử lý (login, register, etc.)
/// - authenticated: Đã đăng nhập
/// - unauthenticated: Chưa đăng nhập hoặc đã logout
/// - error: Có lỗi xảy ra
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  
  const factory AuthState.loading() = _Loading;
  
  const factory AuthState.authenticated({
    required UserModel user,
    required String accessToken,
    required String refreshToken,
  }) = _Authenticated;
  
  const factory AuthState.unauthenticated() = _Unauthenticated;
  
  const factory AuthState.error({
    required String message,
    String? code,
  }) = _Error;
} 

/// Extension để kiểm tra trạng thái
extension AuthStateX on AuthState {
  bool get isLoading => this is _Loading;
  bool get isAuthenticated => this is _Authenticated;
  bool get isUnauthenticated => this is _Unauthenticated;
  bool get isError => this is _Error;
  bool get isInitial => this is _Initial;
  
  /// Lấy user nếu đang authenticated
  UserModel? get user => maybeWhen(
        authenticated: (user, _, _) => user,
        orElse: () => null,
      );
  
  /// Lấy access token nếu đang authenticated
  String? get accessToken => maybeWhen(
        authenticated: (_, token, _) => token,
        orElse: () => null,
      );
  
  /// Lấy error message nếu có lỗi
  String? get errorMessage => maybeWhen(
        error: (message, _) => message,
        orElse: () => null,
      );
}
