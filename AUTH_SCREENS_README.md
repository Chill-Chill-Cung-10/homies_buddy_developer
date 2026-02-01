# 🔐 Auth Screens UI - Homies Buddy

## 📋 Tổng quan

Đã tạo UI cho 2 màn hình authentication:
1. **Forgot Password Screen** - Màn hình quên mật khẩu
2. **Change Password Screen** - Màn hình đổi mật khẩu

## 📁 Cấu trúc files đã tạo

```
lib/
├── features/
│   └── auth/
│       └── presentation/
│           └── screens/
│               ├── forgot_password_screen.dart    # Màn Forgot Password
│               └── change_password_screen.dart    # Màn Change Password
├── core/
│   └── widgets/
│       └── common_widgets.dart                    # Common widgets tái sử dụng
└── demo_auth_screens.dart                         # Demo app để test
```

## 🎨 Tính năng đã implement

### 1. Forgot Password Screen

**Features:**
- ✅ Form validation cho email
- ✅ Loading state khi gửi request
- ✅ Success dialog sau khi gửi email
- ✅ Back button về login
- ✅ Info card hướng dẫn người dùng
- ✅ Responsive design
- ✅ Material 3 components

**UI Elements:**
- AppBar với back button
- Icon illustration
- Title và subtitle
- Email text field với validation
- Send reset link button với loading
- Back to login link
- Help info card

### 2. Change Password Screen

**Features:**
- ✅ 3 password fields: current, new, confirm
- ✅ Real-time password requirements checking
- ✅ Password visibility toggle cho mỗi field
- ✅ Form validation
- ✅ Loading state
- ✅ Success dialog
- ✅ Security tips
- ✅ Material 3 components

**Password Requirements:**
- Tối thiểu 8 ký tự
- Ít nhất 1 chữ hoa (A-Z)
- Ít nhất 1 chữ thường (a-z)
- Ít nhất 1 số (0-9)
- Ít nhất 1 ký tự đặc biệt (!@#$%^&*)

**UI Elements:**
- AppBar với back button
- Current password field
- New password field
- Confirm password field
- Real-time requirements checker
- Update button với loading
- Security tip card

### 3. Common Widgets Library

**Widgets đã tạo:**

1. **CustomButton**
   - Hỗ trợ 4 loại: primary, secondary, outlined, text
   - Loading state
   - Optional icon
   - Full width / auto width

2. **CustomTextField**
   - Custom styling theo design system
   - Validation support
   - Prefix/suffix icons
   - Enabled/disabled states

3. **PasswordTextField**
   - TextField chuyên cho password
   - Auto có visibility toggle
   - Validation support

4. **LoadingOverlay**
   - Overlay loading toàn màn hình
   - Optional loading text

5. **EmptyStateWidget**
   - Widget cho empty states
   - Icon, title, message
   - Optional action button

6. **InfoCard**
   - Card hiển thị thông tin
   - Customizable icon và colors

7. **CustomDialog**
   - Success dialog
   - Error dialog
   - Confirmation dialog

## 🚀 Cách chạy demo

### Option 1: Chạy demo app

```bash
flutter run lib/demo_auth_screens.dart
```

Demo app sẽ hiển thị menu với 2 buttons để test từng screen.

### Option 2: Integrate vào main app

Thêm vào file routing của bạn:

```dart
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/auth/presentation/screens/change_password_screen.dart';

// Với go_router
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordScreen(),
    ),
  ],
);

// Hoặc với Navigator thông thường
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ForgotPasswordScreen(),
  ),
);
```

## 🔧 Tích hợp Services (TODO)

Các screens đã có placeholders để tích hợp services sau:

### Forgot Password Screen

```dart
Future<void> _handleSendResetLink() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });

    // TODO: Replace với service call thật
    // try {
    //   await authService.sendPasswordResetEmail(
    //     email: _emailController.text,
    //   );
    //   _showSuccessDialog();
    // } catch (e) {
    //   _showErrorDialog(e.message);
    // }

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      _showSuccessDialog();
    }
  }
}
```

### Change Password Screen

```dart
Future<void> _handleUpdatePassword() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });

    // TODO: Replace với service call thật
    // try {
    //   await authService.changePassword(
    //     currentPassword: _currentPasswordController.text,
    //     newPassword: _newPasswordController.text,
    //   );
    //   _showSuccessDialog();
    // } catch (e) {
    //   _showErrorDialog(e.message);
    // }

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      _showSuccessDialog();
    }
  }
}
```

## 🎯 Sử dụng Common Widgets

### CustomButton

```dart
CustomButton(
  text: 'Submit',
  onPressed: () {},
  isLoading: false,
  type: ButtonType.primary,
  icon: Icons.check,
)
```

### PasswordTextField

```dart
PasswordTextField(
  controller: _passwordController,
  label: 'Password',
  hint: 'Enter password',
  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
)
```

### CustomDialog

```dart
CustomDialog.showSuccess(
  context,
  title: 'Success',
  message: 'Operation completed',
  onConfirm: () {
    // Handle confirm
  },
);
```

## 📱 Screenshots

### Forgot Password Screen
- Icon illustration ở giữa
- Title "Forgot Password?"
- Subtitle hướng dẫn
- Email field
- Send reset link button
- Back to login link
- Help info ở dưới

### Change Password Screen
- 3 password fields với visibility toggles
- Real-time requirements checker (màu xanh khi đạt)
- Update password button
- Security tip ở dưới

## 🎨 Design System

Screens sử dụng design system từ `core/constants/`:
- **Colors**: `AppColors` (primaryPeach, primaryGreen, textPrimary, etc.)
- **Text Styles**: `AppTextStyles` (h1, h2, bodyLarge, etc.)
- **Shapes**: `AppShapes` (button radius, card radius, padding)
- **Spacing**: `AppSpacing` (xs, s, m, l, xl)

## ✅ Checklist

- [x] Forgot Password Screen UI
- [x] Change Password Screen UI
- [x] Form validation
- [x] Loading states
- [x] Success/Error dialogs
- [x] Password visibility toggles
- [x] Real-time password requirements
- [x] Common widgets library
- [x] Demo app
- [x] Documentation
- [ ] Service integration (TODO sau)
- [ ] Unit tests (TODO sau)
- [ ] Integration tests (TODO sau)

## 📝 Notes

### Validation Rules

**Email (Forgot Password):**
- Required field
- Valid email format (regex)

**Passwords (Change Password):**
- Current password: minimum 6 characters
- New password: must be different from current
- New password: must meet all 5 requirements
- Confirm password: must match new password

### UX Features

- Loading indicators prevent double submissions
- Success dialogs auto-navigate back
- Real-time feedback cho password requirements
- Help text và info cards hướng dẫn người dùng
- Responsive padding và spacing
- Material 3 animations và transitions

## 🔮 Next Steps

1. **Tích hợp Services**
   - Connect với Auth API
   - Error handling
   - Token management

2. **State Management**
   - Thêm Riverpod providers
   - Loading/error states
   - Form state management

3. **Testing**
   - Widget tests
   - Integration tests
   - E2E tests

4. **Enhancements**
   - Biometric authentication support
   - Remember me functionality
   - Multi-language support
   - Dark mode support

## 📞 Support

Nếu cần hỗ trợ hoặc có câu hỏi:
1. Check documentation trong code (comments)
2. Xem UI_INSTRUCTIONS.md
3. Test với demo app
4. Check Flutter logs: `flutter logs`

---

**Created with ❤️ for Homies Buddy App**
