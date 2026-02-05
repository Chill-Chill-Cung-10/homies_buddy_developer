# Auth Models Documentation

## 📁 Cấu trúc Models

Các models được tạo cho authentication flow trong app Homies Buddy:

```
lib/features/auth/data/models/
├── user_model.dart                    # Thông tin user
├── login_request.dart                 # Request đăng nhập
├── login_response.dart                # Response sau khi đăng nhập
├── register_request.dart              # Request đăng ký
├── forgot_password_request.dart       # Request quên mật khẩu
├── change_password_request.dart       # Request đổi mật khẩu
├── auth_state.dart                    # State cho Riverpod
└── models.dart                        # Barrel export
```

## 📚 Models Chi Tiết

### 1. UserModel

Model chứa thông tin người dùng:

```dart
import 'package:homies_buddy_developer/features/auth/data/models/models.dart';

// Tạo user
final user = UserModel(
  id: '123',
  email: 'user@example.com',
  fullName: 'Nguyễn Văn A',
  avatarUrl: 'https://...',
  phoneNumber: '+84901234567',
  isEmailVerified: true,
);

// Sử dụng extensions
print(user.displayName);    // "Nguyễn Văn A"
print(user.initials);       // "NA"
print(user.isProfileComplete); // true/false

// JSON serialization
final json = user.toJson();
final userFromJson = UserModel.fromJson(json);

// CopyWith (từ Freezed)
final updatedUser = user.copyWith(
  fullName: 'Trần Văn B',
);
```

### 2. LoginRequest

Model cho request đăng nhập:

```dart
// Tạo request
final request = LoginRequest(
  email: 'user@example.com',
  password: 'password123',
  rememberMe: true,
);

// Validate
final emailError = request.validateEmail();    // null nếu hợp lệ
final passwordError = request.validatePassword(); // null nếu hợp lệ
final isValid = request.isValid;              // true/false

// JSON
final json = request.toJson();
```

**Validation rules:**
- Email: Không rỗng, định dạng email hợp lệ
- Password: Không rỗng, ít nhất 6 ký tự

### 3. LoginResponse

Model cho response sau khi đăng nhập thành công:

```dart
final response = LoginResponse(
  accessToken: 'eyJhbGc...',
  refreshToken: 'eyJhbGc...',
  user: user,
  tokenType: 'Bearer',
  expiresIn: 3600, // seconds
);

// Sử dụng extensions
final authHeader = response.authorizationHeader; // "Bearer eyJhbGc..."
final isExpiring = response.isTokenExpiringSoon; // true nếu còn < 5 phút
final expiryDate = response.expiryDate;         // DateTime
```

### 4. RegisterRequest

Model cho request đăng ký tài khoản:

```dart
final request = RegisterRequest(
  email: 'user@example.com',
  password: 'Password123',
  confirmPassword: 'Password123',
  fullName: 'Nguyễn Văn A',
  phoneNumber: '+84901234567',
  acceptTerms: true,
);

// Validate từng field
final emailError = request.validateEmail();
final nameError = request.validateFullName();
final passwordError = request.validatePassword();
final confirmError = request.validateConfirmPassword();
final phoneError = request.validatePhoneNumber();
final termsError = request.validateTerms();
final isValid = request.isValid;

// Lấy password requirements (để hiển thị UI)
final requirements = request.passwordRequirements;
// [
//   PasswordRequirement(label: 'Ít nhất 8 ký tự', isMet: true),
//   PasswordRequirement(label: 'Có chữ hoa', isMet: true),
//   PasswordRequirement(label: 'Có chữ số', isMet: true),
//   PasswordRequirement(label: 'Mật khẩu khớp', isMet: true),
// ]
```

**Validation rules:**
- Email: Định dạng hợp lệ
- Full Name: Ít nhất 2 ký tự
- Password: 
  - Ít nhất 8 ký tự
  - Có ít nhất 1 chữ hoa
  - Có ít nhất 1 chữ số
- Confirm Password: Phải khớp với password
- Phone: Định dạng Việt Nam (+84 hoặc 0 + 9 số)
- Accept Terms: Phải = true

### 5. ForgotPasswordRequest

Model cho request quên mật khẩu:

```dart
final request = ForgotPasswordRequest(
  email: 'user@example.com',
);

final error = request.validateEmail();
final isValid = request.isValid;
```

### 6. ChangePasswordRequest

Model cho request đổi mật khẩu:

```dart
final request = ChangePasswordRequest(
  currentPassword: 'oldPassword123',
  newPassword: 'NewPassword123',
  confirmNewPassword: 'NewPassword123',
);

// Validate
final currentError = request.validateCurrentPassword();
final newError = request.validateNewPassword();
final confirmError = request.validateConfirmNewPassword();
final isValid = request.isValid;

// Password requirements
final requirements = request.passwordRequirements;
```

**Validation rules:**
- Current Password: Không rỗng
- New Password: Giống RegisterRequest + phải khác current password
- Confirm New Password: Phải khớp với new password

### 7. AuthState

State model cho Riverpod state management:

```dart
// Các trạng thái
AuthState.initial();                          // Khởi tạo
AuthState.loading();                         // Đang xử lý
AuthState.authenticated(                      // Đã đăng nhập
  user: user,
  accessToken: 'token',
  refreshToken: 'refresh',
);
AuthState.unauthenticated();                 // Chưa đăng nhập
AuthState.error(                             // Có lỗi
  message: 'Invalid credentials',
  code: 'AUTH_ERROR',
);

// Sử dụng extensions
final state = AuthState.authenticated(...);
print(state.isAuthenticated);  // true
print(state.isLoading);        // false
print(state.user);             // UserModel hoặc null
print(state.accessToken);      // String hoặc null
print(state.errorMessage);     // String hoặc null

// Pattern matching với when
state.when(
  initial: () => print('Initial'),
  loading: () => print('Loading...'),
  authenticated: (user, token, refresh) => print('Logged in: ${user.email}'),
  unauthenticated: () => print('Not logged in'),
  error: (message, code) => print('Error: $message'),
);

// Hoặc maybeWhen
state.maybeWhen(
  authenticated: (user, _, __) => showHome(),
  orElse: () => showLogin(),
);
```

## 🎯 Cách Sử Dụng Trong Login Screen

### Ví dụ trong LoginScreen:

```dart
import 'package:homies_buddy_developer/features/auth/data/models/models.dart';

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Tạo login request
      final request = LoginRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );

      // Validate
      if (!request.isValid) {
        // Show error
        return;
      }

      // TODO: Call API hoặc use Riverpod provider
      // ref.read(authProvider.notifier).login(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            validator: (value) {
              final request = LoginRequest(
                email: value ?? '',
                password: '',
              );
              return request.validateEmail();
            },
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            validator: (value) {
              final request = LoginRequest(
                email: '',
                password: value ?? '',
              );
              return request.validatePassword();
            },
          ),
          ElevatedButton(
            onPressed: _handleLogin,
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

## 🔧 Build & Generate Code

Models sử dụng **Freezed** và **json_serializable** để tự động generate code.

### Khi thay đổi models, chạy:

```bash
# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Hoặc watch mode (tự động generate khi có thay đổi)
flutter pub run build_runner watch --delete-conflicting-outputs
```

## ✅ Features

### Freezed cung cấp:
- ✅ **Immutability**: Tất cả properties là final
- ✅ **copyWith()**: Clone object với một số properties thay đổi
- ✅ **==** và **hashCode**: So sánh objects
- ✅ **toString()**: Debug friendly
- ✅ **Union types**: AuthState với nhiều trạng thái
- ✅ **Pattern matching**: when(), maybeWhen()

### json_serializable cung cấp:
- ✅ **toJson()**: Convert object → Map
- ✅ **fromJson()**: Convert Map → object
- ✅ Type safety cho JSON serialization

### Custom Extensions cung cấp:
- ✅ Validation methods cho từng field
- ✅ Helper methods (displayName, initials, etc.)
- ✅ Business logic helpers

## 📝 Notes

- Models này CHỈ cho UI layer (theo UI_INSTRUCTIONS.md)
- Chưa có API integration (sẽ làm sau)
- Chưa có Riverpod providers (sẽ làm sau)
- Tất cả validation là client-side, server-side validation sẽ khác

## 🔜 Next Steps

Để sử dụng models này:
1. ✅ Models đã được tạo
2. ✅ Code đã được generate
3. 🔲 Tạo Riverpod providers cho AuthState
4. 🔲 Tạo mock API service
5. 🔲 Integrate vào Login/Register screens

## 📚 Import

```dart
// Import tất cả models
import 'package:homies_buddy_developer/features/auth/data/models/models.dart';

// Hoặc import riêng lẻ
import 'package:homies_buddy_developer/features/auth/data/models/user_model.dart';
import 'package:homies_buddy_developer/features/auth/data/models/login_request.dart';
```
