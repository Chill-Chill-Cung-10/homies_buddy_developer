# UI IMPLEMENTATION GUIDE - HOMIES BUDDY APP
## Hướng dẫn triển khai giao diện cho người chuyển từ Python sang Flutter

> **Lưu ý**: Tài liệu này tập trung vào VIEW layer, tạm thời bỏ qua services và business logic.

---

## 📋 MỤC LỤC
1. [STEP 1: Kiểm tra Assets và Khai báo](#step-1)
2. [STEP 2: Hướng dẫn Implementation Flow](#step-2)
3. [STEP 3: Material 3 và Package Analysis](#step-3)
4. [Implementation Roadmap](#implementation-roadmap)
5. [Best Practices cho người từ Python](#best-practices)

---

<a id="step-1"></a>
## 🎨 STEP 1: KIỂM TRA VÀ LIỆT KÊ TÀI NGUYÊN

### 1.1. Assets cần chuẩn bị

#### 📁 Cấu trúc thư mục assets cần tạo:
```
assets/
├── images/
│   ├── home/
│   │   ├── garden_background.png          # Nền màn Home (vườn)
│   │   ├── house.png                      # Ngôi nhà trong vườn
│   │   ├── sheep.png                      # Con cừu
│   │   ├── cat.png                        # Con mèo
│   │   ├── plant_pot.png                  # Chậu cây
│   │   ├── watering_can_icon.png          # Icon bình tưới
│   │   ├── flower_bed.png                 # Luống hoa
│   │   └── fence.png                      # Hàng rào
│   ├── community/
│   │   ├── harvest_basket.png             # Giỏ rau củ (Harvest Day)
│   │   ├── community_garden.png           # Vườn cộng đồng
│   │   └── avatar_placeholder.png         # Avatar mặc định
│   ├── help/
│   │   ├── mascot_onion.png               # Nhân vật củ hành dễ thương
│   │   ├── icon_plant.png                 # Icon chậu cây (Watering Fern)
│   │   ├── icon_water.png                 # Icon giọt nước
│   │   ├── icon_sheep.png                 # Icon cừu (Brushing Sheep)
│   │   ├── icon_brush.png                 # Icon chải lông
│   │   └── help_card_bg.png               # Background các card help
│   ├── auth/
│   │   ├── logo.png                       # Logo app
│   │   ├── auth_background.png            # Background màn auth
│   │   └── welcome_illustration.png       # Hình minh họa welcome
│   ├── icons/
│   │   ├── home_nav_icon.png              # Icon Home trong bottom nav
│   │   ├── community_nav_icon.png         # Icon Community
│   │   ├── help_nav_icon.png              # Icon Help
│   │   ├── profile_nav_icon.png           # Icon Profile
│   │   ├── settings_icon.png              # Icon Settings
│   │   └── back_arrow.png                 # Icon mũi tên quay lại
│   └── common/
│       ├── splash_screen.png              # Splash screen
│       └── placeholder_image.png          # Hình placeholder chung
├── fonts/
│   ├── Poppins-Regular.ttf               # Font chính (nếu dùng custom font)
│   ├── Poppins-Bold.ttf
│   ├── Poppins-SemiBold.ttf
│   └── Poppins-Light.ttf
└── animations/                            # Optional: Lottie animations
    ├── loading.json
    └── success.json
```

### 1.2. Cập nhật pubspec.yaml

Thêm vào file `pubspec.yaml` (sau dòng `uses-material-design: true`):

```yaml
flutter:
  uses-material-design: true

  # Khai báo assets
  assets:
    - assets/images/home/
    - assets/images/community/
    - assets/images/help/
    - assets/images/auth/
    - assets/images/icons/
    - assets/images/common/
    - assets/animations/

  # Khai báo fonts (nếu dùng custom font)
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
        - asset: assets/fonts/Poppins-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Poppins-Light.ttf
          weight: 300
```

### 1.3. File Constants cần tạo

#### Tạo file: `lib/core/constants/app_assets.dart`
```dart
class AppAssets {
  // Home Assets
  static const String gardenBackground = 'assets/images/home/garden_background.png';
  static const String house = 'assets/images/home/house.png';
  static const String sheep = 'assets/images/home/sheep.png';
  static const String cat = 'assets/images/home/cat.png';
  
  // Community Assets
  static const String harvestBasket = 'assets/images/community/harvest_basket.png';
  static const String avatarPlaceholder = 'assets/images/community/avatar_placeholder.png';
  
  // Help Assets
  static const String mascotOnion = 'assets/images/help/mascot_onion.png';
  static const String iconPlant = 'assets/images/help/icon_plant.png';
  static const String iconWater = 'assets/images/help/icon_water.png';
  
  // Navigation Icons
  static const String homeNavIcon = 'assets/images/icons/home_nav_icon.png';
  static const String communityNavIcon = 'assets/images/icons/community_nav_icon.png';
  static const String helpNavIcon = 'assets/images/icons/help_nav_icon.png';
  
  // Auth Assets
  static const String logo = 'assets/images/auth/logo.png';
  static const String authBackground = 'assets/images/auth/auth_background.png';
}
```

#### Tạo file: `lib/core/constants/app_colors.dart`
```dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (từ hình - tông màu pastel nhẹ nhàng)
  static const Color primaryPeach = Color(0xFFF5D5C8);      // Màu nền chính
  static const Color primaryGreen = Color(0xFFB5D4A8);      // Màu xanh lá nhẹ
  static const Color primaryPink = Color(0xFFFFE0E6);       // Màu hồng nhạt
  static const Color accentOrange = Color(0xFFFFB88C);      // Màu cam nhấn
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFFFF8F5);
  static const Color cardBackground = Color(0xFFFFF5EE);
  static const Color surfaceColor = Color(0xFFFAF0E6);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF5D4E37);       // Màu nâu cho text chính
  static const Color textSecondary = Color(0xFF8B7355);     // Màu nâu nhạt
  static const Color textHint = Color(0xFFBDA88F);
  
  // UI Element Colors
  static const Color buttonPrimary = Color(0xFFE8C4A7);
  static const Color buttonSecondary = Color(0xFFD4E5C9);
  static const Color iconColor = Color(0xFF9C8672);
  
  // Status Colors
  static const Color successGreen = Color(0xFF8BC34A);
  static const Color errorRed = Color(0xFFEF5350);
  static const Color warningYellow = Color(0xFFFFEB3B);
  
  // Navigation Bar
  static const Color navBarBackground = Color(0xFFFFF8F5);
  static const Color navBarSelected = Color(0xFF6B5D4F);
  static const Color navBarUnselected = Color(0xFFBDA88F);
}
```

#### Tạo file: `lib/core/constants/app_text_styles.dart`
```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Heading Styles
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
  
  // Button Styles
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  // Caption & Labels
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textHint,
  );
  
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
}
```

#### Tạo file: `lib/core/constants/app_dimensions.dart`
```dart
import 'package:flutter/material.dart';

class AppShapes {
  static const double cardRadius = 24;
  static const double buttonRadius = 18;
  static const double iconRadius = 14;
  static const double fullRadius = 999; // pill

  static BorderRadius card = BorderRadius.circular(cardRadius);
  static BorderRadius button = BorderRadius.circular(buttonRadius);
  static BorderRadius icon = BorderRadius.circular(iconRadius);
  static BorderRadius full = BorderRadius.circular(fullRadius);

  // Padding
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  // Icon Sizes
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL  = 32.0;
  static const double iconXL = 48.0;
  
  // Card Dimensions
  static const double cardElevation = 2.0;
  static const double cardHeight = 200.0;
  
  // Bottom Navigation
  static const double navBarHeight = 60.0;
  static const double navIconSize = 28.0;
}

```

### 1.4. Checklist Assets

- [ ] Tạo thư mục `assets/` trong root project
- [ ] Tạo các subfolder: images, fonts, animations
- [ ] Chuẩn bị tất cả hình ảnh theo list ở trên
- [ ] Download fonts (hoặc dùng Google Fonts package)
- [ ] Cập nhật pubspec.yaml với assets và fonts
- [ ] Chạy `flutter pub get` để load assets
- [ ] Tạo các file constants (app_assets.dart, app_colors.dart, app_text_styles.dart, app_dimensions.dart)

---

<a id="step-2"></a>
## 🎯 STEP 2: HƯỚNG DẪN UI IMPLEMENTATION FLOW

### 2.1. Overview Architecture

```
User Journey Flow:
┌─────────────────────────────────────────────────────────────────┐
│  AUTHENTICATION FLOW                                            │
│  Login → Register → Forgot Password → Change Password           │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
/// ┌─────────────────────────────────────────────────────────────────┐
│  MAIN NAVIGATION (Bottom Navigation Bar)                        │
│  ┌─────────┬──────────────┬────────────┬──────────────────┐   │
│  │  Home   │  Community   │    Help    │  Profile/Setting │   │
│  └─────────┴──────────────┴────────────┴──────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2. Implementation Flow Chi tiết

#### PHASE 1: AUTHENTICATION SCREENS (Auth Flow)

##### 📱 Screen 1: Login Screen
**Location**: `lib/features/auth/presentation/screens/login_screen.dart`

**Layout Description**:
```
┌─────────────────────────────┐
│     [Logo/Illustration]     │  ← AppAssets.logo
│                             │
│   Welcome Back!             │  ← Heading
│   Log in to your account    │  ← Subtitle
│                             │
│   [Email TextField]         │  ← TextFormField với Icon
│   [Password TextField]      │  ← TextFormField với visibility toggle
│                             │
│   [Forgot Password?]   →    │  ← TextButton
│                             │
│   [Login Button]            │  ← ElevatedButton (full width)
│                             │
│   Don't have an account?    │
│   [Sign Up]                 │  ← TextButton
│                             │
│   ─────── OR ───────        │
│                             │
│   [Google Sign In]          │  ← OutlinedButton với Google icon
│   [Apple Sign In]           │  ← OutlinedButton với Apple icon
└─────────────────────────────┘
```

**Key Widgets**:
- `Scaffold` với `AppBar` hoặc không
- `SingleChildScrollView` để scroll khi keyboard mở
- `Form` với `GlobalKey<FormState>` để validate
- `TextFormField` với validator
- `ElevatedButton` cho primary action
- `TextButton` và `OutlinedButton` cho secondary actions

**Code Structure**:
```dart
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                // Title
                // TextFields
                // Buttons
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

##### 📱 Screen 2: Register Screen
**Location**: `lib/features/auth/presentation/screens/register_screen.dart`

**Layout**: Tương tự Login nhưng có thêm:
- Full Name field
- Confirm Password field
- Terms & Conditions checkbox
- "Already have account?" link

##### 📱 Screen 3: Forgot Password Screen
**Location**: `lib/features/auth/presentation/screens/forgot_password_screen.dart`

**Layout**:
```
┌─────────────────────────────┐
│     ← Back                  │  ← AppBar with back button
│                             │
│   Forgot Password?          │  ← Heading
│   Enter your email to       │
│   reset password            │
│                             │
│   [Email TextField]         │
│                             │
│   [Send Reset Link]         │  ← ElevatedButton
│                             │
│   Remember password?        │
│   [Back to Login]           │  ← TextButton
└─────────────────────────────┘
```

##### 📱 Screen 4: Change Password Screen
**Location**: `lib/features/auth/presentation/screens/change_password_screen.dart`

**Layout**:
```
┌─────────────────────────────┐
│     ← Change Password       │  ← AppBar
│                             │
│   [Current Password]        │
│   [New Password]            │
│   [Confirm New Password]    │
│                             │
│   Password Requirements:    │
│   • At least 8 characters   │
│   • One uppercase letter    │
│   • One number              │
│                             │
│   [Update Password]         │  ← ElevatedButton
└─────────────────────────────┘
```

---

#### PHASE 2: MAIN NAVIGATION STRUCTURE

##### 📱 Main Shell: Navigation Bar
**Location**: `lib/features/navigation/presentation/screens/main_navigation_screen.dart`

**Structure**:
```dart
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);
  
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    HomeScreen(),
    CommunityScreen(),
    HelpScreen(),
    ProfileScreen(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar( // Material 3 NavigationBar
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: AppColors.navBarBackground,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Community',
          ),
          NavigationDestination(
            icon: Icon(Icons.help_outline),
            selectedIcon: Icon(Icons.help),
            label: 'Help',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
```

**Note về Material 3**:
- `NavigationBar` thay thế cho `BottomNavigationBar` cũ
- Dùng `NavigationDestination` thay vì `BottomNavigationBarItem`
- Tự động apply Material 3 design với animation

---

#### PHASE 3: HOME SCREEN

##### 📱 Screen: Home (Garden View)
**Location**: `lib/features/home/presentation/screens/home_screen.dart`

**Layout Description** (từ hình):
```
┌─────────────────────────────────────┐
│  ← [Back]              [Settings] ⚙ │  ← AppBar (transparent)
│                                     │
│  ╔═══════════════════════════════╗ │
│  ║   [Garden Background]          ║ │  ← Stack với background image
│  ║                                ║ │
│  ║   🏠 [House]                   ║ │  ← Positioned widgets
│  ║                                ║ │
│  ║   🐑 [Sheep]      🐱 [Cat]     ║ │  ← Interactive elements
│  ║                                ║ │
│  ║   🌸 [Flower Bed]  🪴 [Plants] ║ │
│  ║                                ║ │
│  ║   [Watering Icon]              ║ │  ← Action button (Float)
│  ╚═══════════════════════════════╝ │
│                                     │
│  [Bottom Navigation Bar]            │
└─────────────────────────────────────┘
```

**Implementation Strategy**:
```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // AppBar trong suốt phủ lên content
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Garden
          Positioned.fill(
            child: Image.asset(
              AppAssets.gardenBackground,
              fit: BoxFit.cover,
            ),
          ),
          
          // Interactive Elements
          Positioned(
            top: 150,
            right: 100,
            child: _buildHouse(),
          ),
          Positioned(
            bottom: 200,
            left: 50,
            child: _buildSheep(),
          ),
          Positioned(
            bottom: 220,
            right: 80,
            child: _buildCat(),
          ),
          
          // Watering Can Button (Floating)
          Positioned(
            top: 100,
            left: 40,
            child: _buildWateringButton(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHouse() {
    return GestureDetector(
      onTap: () {
        // Handle house tap
      },
      child: Image.asset(
        AppAssets.house,
        width: 120,
        height: 120,
      ),
    );
  }
  
  Widget _buildWateringButton() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Image.asset(AppAssets.iconWater),
        onPressed: () {
          // Handle watering action
        },
      ),
    );
  }
}
```

---

#### PHASE 4: COMMUNITY SCREEN

##### 📱 Screen: Community Neighbors
**Location**: `lib/features/community/presentation/screens/community_screen.dart`

**Layout Description**:
```
┌─────────────────────────────────────┐
│  ← Community Neighbors              │  ← AppBar
│                                     │
│  ┌───────────────────────────────┐ │
│  │ 👤 Avatars              ⋯     │ │  ← Header section
│  │                               │ │
│  │ ┌───────────────────────────┐ │ │
│  │ │  [Harvest Basket Image]   │ │ │  ← Card Image
│  │ └───────────────────────────┘ │ │
│  │                               │ │
│  │ Harvest Day                   │ │  ← Card Title
│  │ Have a positive and hustcups  │ │  ← Card Description
│  │ has a virtual heathof your    │ │
│  │ lomensu 🌱...                 │ │
│  │                               │ │
│  │ ❤️ 🥰                      🌱  │ │  ← Reaction & Action Icons
│  └───────────────────────────────┘ │
│                                     │
│  ┌───────────────────────────────┐ │  ← Another Card
│  │ 👤 Avatars              ⋯     │ │
│  │ [Image]                       │ │
│  │ ...                           │ │
│  └───────────────────────────────┘ │
│                                     │
│  [Bottom Navigation Bar]            │
└─────────────────────────────────────┘
```

**Implementation**:
```dart
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Community Neighbors',
          style: AppTextStyles.h2,
        ),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        itemCount: 10, // Temporary: sẽ thay bằng data từ state
        itemBuilder: (context, index) {
          return _buildCommunityCard();
        },
      ),
    );
  }
  
  Widget _buildCommunityCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      color: AppColors.cardBackground,
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar + More Button
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(AppAssets.avatarPlaceholder),
                ),
                const SizedBox(width: AppDimensions.paddingS),
                Text('Avatars', style: AppTextStyles.label),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {},
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.paddingM),
            
            // Card Image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              child: Image.asset(
                AppAssets.harvestBasket,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            
            const SizedBox(height: AppDimensions.paddingM),
            
            // Title
            Text(
              'Harvest Day',
              style: AppTextStyles.h3,
            ),
            
            const SizedBox(height: AppDimensions.paddingS),
            
            // Description
            Text(
              'Have a positive and hustcups has a virtual heathof your lomensu 🌱...',
              style: AppTextStyles.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: AppDimensions.paddingM),
            
            // Reactions Row
            Row(
              children: [
                _buildReactionButton('❤️', 12),
                const SizedBox(width: AppDimensions.paddingS),
                _buildReactionButton('🥰', 5),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.eco, color: AppColors.successGreen),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildReactionButton(String emoji, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text('$count', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
```

---

#### PHASE 5: HELP SCREEN

##### 📱 Screen: Ask For Help
**Location**: `lib/features/help/presentation/screens/help_screen.dart`

**Layout Description**:
```
┌─────────────────────────────────────┐
│  ← Ask For Help                     │  ← AppBar
│                                     │
│         🧅                          │  ← Mascot (Cute Onion)
│       (◕‿◕)                         │
│                                     │
│  Hi there! How can I help           │  ← Welcome Message
│  you grow today?                    │
│                                     │
│  🗨️ [Chat Input Field] →           │  ← Input (optional)
│                                     │
│  ┌──────────────┐  ┌──────────────┐│
│  │    🪴       │  │    💧       ││  ← Help Cards (Grid)
│  │             │  │             ││
│  │  Watering   │  │             ││
│  │  Your Fern  │  │             ││
│  │  Every 3    │  │             ││
│  │  Days       │  │             ││
│  └──────────────┘  └──────────────┘│
│  ┌──────────────┐  ┌──────────────┐│
│  │    🐑       │  │             ││
│  │             │  │             ││
│  │  Brushing   │  │             ││
│  │  Your Sheep │  │             ││
│  │  Daily      │  │             ││
│  │  Connection │  │             ││
│  └──────────────┘  └──────────────┘│
│                                     │
│  [Bottom Navigation Bar]            │
└─────────────────────────────────────┘
```

**Implementation**:
```dart
class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text('Ask For Help', style: AppTextStyles.h2),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          children: [
            // Mascot
            Image.asset(
              AppAssets.mascotOnion,
              width: 120,
              height: 120,
            ),
            
            const SizedBox(height: AppDimensions.paddingM),
            
            // Welcome Message
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
              child: Row(
                children: [
                  Image.asset(
                    AppAssets.mascotOnion,
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: AppDimensions.paddingM),
                  Expanded(
                    child: Text(
                      'Hi there! How can I help\nyou grow today?',
                      style: AppTextStyles.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppDimensions.paddingL),
            
            // Help Cards Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppDimensions.paddingM,
              crossAxisSpacing: AppDimensions.paddingM,
              childAspectRatio: 0.85,
              children: [
                _buildHelpCard(
                  icon: AppAssets.iconPlant,
                  title: 'Watering Your Fern',
                  subtitle: 'Every 3 Days',
                  backgroundColor: const Color(0xFFD4E5C9),
                ),
                _buildHelpCard(
                  icon: AppAssets.iconWater,
                  title: '',
                  subtitle: '',
                  backgroundColor: const Color(0xFFB8D4E8),
                ),
                _buildHelpCard(
                  icon: AppAssets.iconSheep,
                  title: 'Brushing Your Sheep',
                  subtitle: 'Daily Connection',
                  backgroundColor: const Color(0xFFFFE0C9),
                ),
                _buildHelpCard(
                  icon: AppAssets.iconBrush,
                  title: '',
                  subtitle: '',
                  backgroundColor: const Color(0xFFFFF4C9),
                ),
              ],
            ),
            
            const SizedBox(height: AppDimensions.paddingXL),
            
            // Floating Action Button (Send Message)
            FloatingActionButton.extended(
              onPressed: () {
                // Navigate to chat or help form
              },
              backgroundColor: AppColors.buttonPrimary,
              icon: const Icon(Icons.chat_bubble_outline),
              label: Text('Start Chat', style: AppTextStyles.buttonMedium),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHelpCard({
    required String icon,
    required String title,
    required String subtitle,
    required Color backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              width: 60,
              height: 60,
            ),
            if (title.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.paddingM),
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.paddingS),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

---

#### PHASE 6: PROFILE/SETTINGS SCREEN

##### 📱 Screen: Personal Settings
**Location**: `lib/features/profile/presentation/screens/profile_screen.dart`

**Layout**:
```
┌─────────────────────────────────────┐
│  Personal Settings                  │  ← AppBar
│                                     │
│  ┌─────────────────────────────┐   │
│  │   👤                        │   │  ← Profile Header Card
│  │   User Name                 │   │
│  │   user@email.com            │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📱 Account Settings         │   │  ← Settings List
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ 🔔 Notifications            │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ 🔒 Privacy                  │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ ℹ️  About                   │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ 🚪 Logout                   │   │
│  └─────────────────────────────┘   │
│                                     │
│  [Bottom Navigation Bar]            │
└─────────────────────────────────────┘
```

**Implementation**: Use `ListView` with `ListTile` widgets

---

<a id="step-3"></a>
## 🎨 STEP 3: MATERIAL 3 VÀ PACKAGE ANALYSIS

### 3.1. Packages Có Sẵn trong pubspec.yaml

#### ✅ Packages Sử Dụng cho UI:

1. **flutter_riverpod** (^2.5.1)
   - **Công dụng**: State management
   - **Sử dụng cho**: Quản lý state của UI (loading, data, errors)
   - **Ví dụ**:
   ```dart
   final counterProvider = StateProvider<int>((ref) => 0);
   
   class MyWidget extends ConsumerWidget {
     @override
     Widget build(BuildContext context, WidgetRef ref) {
       final count = ref.watch(counterProvider);
       return Text('$count');
     }
   }
   ```

2. **go_router** (^13.2.0)
   - **Công dụng**: Navigation và routing
   - **Sử dụng cho**: Navigate giữa các màn hình
   - **Ví dụ**:
   ```dart
   final router = GoRouter(
     routes: [
       GoRoute(
         path: '/',
         builder: (context, state) => LoginScreen(),
       ),
       GoRoute(
         path: '/home',
         builder: (context, state) => MainNavigationScreen(),
       ),
     ],
   );
   
   // Navigate
   context.go('/home');
   context.push('/profile');
   ```

3. **cached_network_image** (^3.3.1)
   - **Công dụng**: Load và cache images từ network
   - **Sử dụng cho**: Avatar, community images
   - **Ví dụ**:
   ```dart
   CachedNetworkImage(
     imageUrl: 'https://example.com/image.jpg',
     placeholder: (context, url) => CircularProgressIndicator(),
     errorWidget: (context, url, error) => Icon(Icons.error),
   )
   ```

4. **photo_view** (^0.15.0)
   - **Công dụng**: Xem ảnh full screen với zoom
   - **Sử dụng cho**: Xem ảnh trong community
   - **Ví dụ**:
   ```dart
   PhotoView(
     imageProvider: AssetImage(AppAssets.harvestBasket),
   )
   ```

5. **image_picker** (^1.0.7)
   - **Công dụng**: Chọn ảnh từ gallery/camera
   - **Sử dụng cho**: Upload avatar, community posts
   - **Ví dụ**:
   ```dart
   final picker = ImagePicker();
   final image = await picker.pickImage(source: ImageSource.gallery);
   ```

6. **flutter_chat_ui** (^1.6.10) & **flutter_chat_types** (^3.6.2)
   - **Công dụng**: UI components cho chat
   - **Sử dụng cho**: Community chat, help chat
   - **Ví dụ**: Sẽ dùng sau khi implement service layer

7. **cupertino_icons** (^1.0.8)
   - **Công dụng**: iOS style icons
   - **Sử dụng cho**: Icons trong UI

### 3.2. Material 3 Features Sử Dụng

#### Widget Mapping (Material 2 → Material 3):

| Material 2 | Material 3 | Use Case |
|------------|------------|----------|
| `BottomNavigationBar` | `NavigationBar` | Bottom navigation |
| `BottomNavigationBarItem` | `NavigationDestination` | Nav items |
| `AppBar` | `AppBar` (với Material 3 style) | Top bar |
| `RaisedButton` / `FlatButton` | `ElevatedButton` / `TextButton` | Buttons |
| `OutlineButton` | `OutlinedButton` | Secondary buttons |
| `Card` | `Card` (Material 3 style) | Cards |
| `TextField` | `TextFormField` | Input fields |

#### Material 3 Theme Configuration:

**Tạo file**: `lib/core/theme/app_theme.dart`

```dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true, // ← QUAN TRỌNG: Enable Material 3
    
    // Color Scheme
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryPeach,
      secondary: AppColors.primaryGreen,
      tertiary: AppColors.primaryPink,
      surface: AppColors.surfaceColor,
      background: AppColors.backgroundLight,
      error: AppColors.errorRed,
      onPrimary: AppColors.textPrimary,
      onSecondary: AppColors.textSecondary,
      onSurface: AppColors.textPrimary,
      onBackground: AppColors.textPrimary,
    ),
    
    // Typography
    textTheme: TextTheme(
      displayLarge: AppTextStyles.h1,
      displayMedium: AppTextStyles.h2,
      displaySmall: AppTextStyles.h3,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.buttonLarge,
      labelMedium: AppTextStyles.buttonMedium,
    ),
    
    // Component Themes
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.h2,
    ),
    
    cardTheme: CardTheme(
      color: AppColors.cardBackground,
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonPrimary,
        foregroundColor: AppColors.textPrimary,
        elevation: 2,
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        textStyle: AppTextStyles.buttonLarge,
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        textStyle: AppTextStyles.buttonMedium,
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: BorderSide(color: AppColors.textSecondary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: BorderSide(color: AppColors.errorRed, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingM,
      ),
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textHint,
      ),
    ),
    
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.navBarBackground,
      indicatorColor: AppColors.primaryGreen.withOpacity(0.3),
      height: AppDimensions.navBarHeight,
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppTextStyles.label.copyWith(
            color: AppColors.navBarSelected,
          );
        }
        return AppTextStyles.label.copyWith(
          color: AppColors.navBarUnselected,
        );
      }),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return IconThemeData(
            color: AppColors.navBarSelected,
            size: AppDimensions.navIconSize,
          );
        }
        return IconThemeData(
          color: AppColors.navBarUnselected,
          size: AppDimensions.navIconSize,
        );
      }),
    ),
  );
}
```

### 3.3. Common Widgets Library

**Tạo file**: `lib/core/widgets/common_widgets.dart`

```dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_dimensions.dart';

// Custom Button với loading state
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final ButtonType type;
  
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.type = ButtonType.primary,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    Widget button;
    
    switch (type) {
      case ButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(text),
        );
        break;
      case ButtonType.secondary:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: Text(text),
        );
        break;
      case ButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          child: Text(text),
        );
        break;
    }
    
    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}

enum ButtonType { primary, secondary, text }

// Custom TextField với validation
class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  
  const CustomTextField({
    Key? key,
    this.controller,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

// Loading Overlay
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  
  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}

// Empty State Widget
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;
  
  const EmptyStateWidget({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
    this.onAction,
    this.actionLabel,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.textHint,
            ),
            const SizedBox(height: AppDimensions.paddingL),
            Text(
              title,
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingM),
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: AppDimensions.paddingL),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

---

<a id="implementation-roadmap"></a>
## 🗓️ IMPLEMENTATION ROADMAP

### Thứ tự triển khai đề xuất:

#### WEEK 1: Setup & Authentication
- [ ] Day 1-2: Setup assets, constants, theme
- [ ] Day 3-4: Implement Login Screen
- [ ] Day 5-6: Implement Register Screen
- [ ] Day 7: Implement Forgot Password & Change Password

#### WEEK 2: Main Navigation & Home
- [ ] Day 1-2: Setup Navigation structure với go_router
- [ ] Day 3-5: Implement Home Screen (Garden view)
- [ ] Day 6-7: Polish Home interactions và animations

#### WEEK 3: Community & Help
- [ ] Day 1-3: Implement Community Screen
- [ ] Day 4-6: Implement Help Screen
- [ ] Day 7: Testing và bug fixes

#### WEEK 4: Profile & Polish
- [ ] Day 1-2: Implement Profile/Settings Screen
- [ ] Day 3-5: Polish all screens, animations
- [ ] Day 6-7: Final testing và documentation

---

<a id="best-practices"></a>
## 💡 BEST PRACTICES CHO NGƯỜI TỪ PYTHON

### 1. So sánh Python vs Flutter/Dart

| Concept | Python | Flutter/Dart |
|---------|--------|--------------|
| Class | `class MyClass:` | `class MyClass {` |
| Constructor | `def __init__(self):` | `MyClass({Key? key}) : super(key: key);` |
| Properties | `self.name = "John"` | `final String name;` hoặc `String name;` |
| Methods | `def my_method(self):` | `void myMethod() {` |
| String interpolation | `f"Hello {name}"` | `"Hello $name"` hoặc `"Hello ${name}"` |
| List | `my_list = [1, 2, 3]` | `List<int> myList = [1, 2, 3];` |
| Dict/Map | `my_dict = {"key": "value"}` | `Map<String, String> myMap = {"key": "value"};` |
| Null handling | `value = None` | `String? value;` (nullable) |
| Conditionals | `if condition:` | `if (condition) {` |
| Loops | `for item in list:` | `for (var item in list) {` |

### 2. Widget Tree Concept (Khác với HTML/Python)

```dart
// Widget tree là cấu trúc lồng nhau (như HTML nhưng bằng code)
Column(  // ← Như <div> vertical
  children: [
    Text('Hello'),      // ← Element con 1
    Container(          // ← Element con 2
      child: Text('World'),
    ),
  ],
)

// Tương đương Python (concept)
# column = {
#     'type': 'Column',
#     'children': [
#         {'type': 'Text', 'data': 'Hello'},
#         {'type': 'Container', 'child': {'type': 'Text', 'data': 'World'}}
#     ]
# }
```

### 3. State Management (Quan trọng!)

```dart
// StatelessWidget: Widget KHÔNG thay đổi (như pure function)
class MyStatelessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('I never change');
  }
}

// StatefulWidget: Widget CÓ state (như class với instance variables)
class MyStatefulWidget extends StatefulWidget {
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int counter = 0;  // ← State variable
  
  void increment() {
    setState(() {  // ← Như self.notify() để re-render
      counter++;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Text('Counter: $counter');
  }
}
```

### 4. Layout Widgets Chính

```dart
// Column: Stack theo chiều dọc (vertical)
Column(
  children: [Widget1(), Widget2()],
)

// Row: Stack theo chiều ngang (horizontal)
Row(
  children: [Widget1(), Widget2()],
)

// Stack: Chồng lên nhau (z-index)
Stack(
  children: [
    BackgroundWidget(),
    ForegroundWidget(),
  ],
)

// Container: Như <div> với styling
Container(
  width: 100,
  height: 100,
  color: Colors.blue,
  padding: EdgeInsets.all(16),
  child: Text('Content'),
)

// ListView: Scrollable list
ListView(
  children: [Item1(), Item2(), Item3()],
)

// GridView: Grid layout
GridView.count(
  crossAxisCount: 2,  // 2 columns
  children: [Item1(), Item2(), Item3(), Item4()],
)
```

### 5. Navigation Tips

```dart
// Push (đi tới màn mới)
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);

// Pop (quay lại)
Navigator.pop(context);

// Với go_router (khuyến nghị)
context.go('/home');       // Replace
context.push('/profile');  // Push
context.pop();             // Back
```

### 6. Async/Await (Giống Python!)

```dart
// Python
async def fetch_data():
    response = await http.get('url')
    return response.json()

// Dart (gần như giống hệt!)
Future<Map> fetchData() async {
  final response = await http.get('url');
  return response.json();
}
```

### 7. Common Pitfalls

❌ **AVOID**:
```dart
// Không dùng setState() ngoài StatefulWidget
Text('${myVariable}'); // Widget không tự update khi biến đổi

// Không quên const để optimize performance
Container(); // ← Không const

// Không dùng print() nhiều quá (dùng debugPrint hoặc logger)
print('Debug message');
```

✅ **DO**:
```dart
// Dùng const khi có thể
const Container();

// Dùng debugPrint hoặc logger
debugPrint('Debug message');
logger.d('Debug message');

// Extract widgets thành methods hoặc classes riêng
Widget _buildHeader() {
  return Container(...);
}
```

---

## 🚀 QUICK START GUIDE

### 1. Chạy lệnh setup:
```bash
# Tạo thư mục assets
mkdir -p assets/images/home assets/images/community assets/images/help assets/images/auth assets/images/icons assets/images/common assets/fonts

# Cập nhật dependencies
flutter pub get

# Kiểm tra
flutter doctor
```

### 2. Tạo file constants (theo hướng dẫn ở STEP 1)

### 3. Update main.dart:
```dart
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homies Buddy',
      theme: AppTheme.lightTheme, // ← Apply theme
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
```

### 4. Bắt đầu implement từ Login Screen

### 5. Test trên emulator/device:
```bash
flutter run
```

---

## 📚 TÀI LIỆU THAM KHẢO

### Official Docs:
- Flutter Widget Catalog: https://docs.flutter.dev/ui/widgets
- Material 3 Design: https://m3.material.io/
- Dart Language Tour: https://dart.dev/guides/language/language-tour

### Tutorials cho người Python:
- Flutter for Python Developers: https://docs.flutter.dev/get-started/flutter-for/python-devs
- Widget của tuần (Video): https://www.youtube.com/playlist?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG

---

## ✅ CHECKLIST CUỐI CÙNG

Trước khi bắt đầu code, đảm bảo:
- [ ] Đã đọc và hiểu STEP 1 (Assets setup)
- [ ] Đã đọc và hiểu STEP 2 (UI Flow)
- [ ] Đã đọc và hiểu STEP 3 (Material 3 packages)
- [ ] Đã tạo tất cả file constants
- [ ] Đã setup theme
- [ ] Đã chuẩn bị assets (hoặc dùng placeholder tạm)
- [ ] Hiểu concept StatelessWidget vs StatefulWidget
- [ ] Hiểu Navigation và Routing
- [ ] Đã chạy `flutter pub get` thành công

---

## 📞 SUPPORT & QUESTIONS

Nếu gặp vấn đề khi implement:
1. Check Flutter Doctor: `flutter doctor -v`
2. Clean và rebuild: `flutter clean && flutter pub get`
3. Hot reload: Press `r` trong terminal (hoặc Save file)
4. Hot restart: Press `R` trong terminal
5. Check logs: `flutter logs`

**Chúc bạn implement thành công! 🎉**

> Ghi nhớ: Tập trung vào VIEW trước, services sau. Dùng mock data để test UI.
