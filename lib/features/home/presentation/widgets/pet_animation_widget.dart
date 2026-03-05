import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math' as math;

// ─────────────────────────────────────────────
// ENUM & CONFIG
// ─────────────────────────────────────────────

/// Các trạng thái ổn định của pet (loop animation)
enum PetState {
  happy,
  idle,
  sleep,
  sad,
  lookingOutside,
  walkingAway,
  walkingFront,
  walkingHorizontally,
}

/// Các animation chuyển đổi giữa các trạng thái (play once)
enum PetTransition {
  happyToWalkHorizontally,    // happy -> walkingHorizontally
  happyVsSmiling,             // transition giữa happy variants
  idleToSleep,                // idle -> sleep
  lookingToWalkFront,         // lookingOutside -> walkingFront
  lookFrontToBack,            // quay từ trước ra sau
  lookBackToFront,            // quay từ sau ra trước
}

/// Sealed class đại diện cho bất kỳ animation nào của pet
sealed class PetAnimation {
  const PetAnimation();
  
  /// Tạo animation từ state
  factory PetAnimation.state(PetState state) = _PetAnimationState;
  
  /// Tạo animation từ transition
  factory PetAnimation.transition(PetTransition transition) = _PetAnimationTransition;
  
  /// Lấy config tương ứng
  _SpriteConfig get config;
  
  /// Kiểm tra có phải là transition không (play once)
  bool get isTransition;
}

class _PetAnimationState extends PetAnimation {
  final PetState state;
  
  const _PetAnimationState(this.state);
  
  @override
  _SpriteConfig get config => _stateConfigs[state]!;
  
  @override
  bool get isTransition => false;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _PetAnimationState &&
          runtimeType == other.runtimeType &&
          state == other.state;
  
  @override
  int get hashCode => state.hashCode;
}

class _PetAnimationTransition extends PetAnimation {
  final PetTransition transition;
  
  const _PetAnimationTransition(this.transition);
  
  @override
  _SpriteConfig get config => _transitionConfigs[transition]!;
  
  @override
  bool get isTransition => true;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _PetAnimationTransition &&
          runtimeType == other.runtimeType &&
          transition == other.transition;
  
  @override
  int get hashCode => transition.hashCode;
}

class _SpriteConfig {
  final String assetPath;
  final int columns;
  final int rows;
  final int frameCount; // frame thực tế (bỏ ô trống)
  final double fps;

  const _SpriteConfig({
    required this.assetPath,
    required this.columns,
    required this.rows,
    required this.frameCount,
    required this.fps,
  });
}

// ── Cấu hình sprite cho các STATE (loop animation) ──
const Map<PetState, _SpriteConfig> _stateConfigs = {
  PetState.happy: _SpriteConfig(
    assetPath: 'assets/images/home/sprite_pets/lumni_happy.png',
    columns: 5,
    rows: 13,
    frameCount: 61,
    fps: 14,
  ),
  PetState.idle: _SpriteConfig(
    assetPath: 'assets/images/home/sprite_pets/lumni_idle.png',
    columns: 5,
    rows: 13,
    frameCount: 61,
    fps: 14,
  ),
  PetState.sleep: _SpriteConfig(
    assetPath: 'assets/images/home/sprite_pets/lumni_sleep.png',
    columns: 5,
    rows: 13,
    frameCount: 61,
    fps: 14,
  ),
  PetState.sad: _SpriteConfig(
    assetPath: 'assets/images/home/sprite_pets/lumn_sad.png',
    columns: 5,
    rows: 13,
    frameCount: 61,
    fps: 14,
  ),
  PetState.lookingOutside: _SpriteConfig(
    assetPath: 'assets/images/home/sprite_pets/lumni_looking_outside.png',
    columns: 5,
    rows: 13,
    frameCount: 61,
    fps: 14,
  ),
  PetState.walkingAway: _SpriteConfig(
    assetPath: 'assets/images/home/sprite_pets/lumni_walking_away.png',
    columns: 5,
    rows: 7,
    frameCount: 32,
    fps: 14,
  ),
  PetState.walkingFront: _SpriteConfig(
    assetPath: 'assets/images/home/sprite_pets/lumni_walking_front.png',
    columns: 5,
    rows: 13,
    frameCount: 61,
    fps: 14,
  ),
  PetState.walkingHorizontally: _SpriteConfig(
    assetPath: 'assets/images/home/sprite_pets/lumni_walking_horizontally.png',
    columns: 5,
    rows: 3,
    frameCount: 15,
    fps: 14,
  ),
};

// ── Cấu hình sprite cho các TRANSITION (play once) ──
const Map<PetTransition, _SpriteConfig> _transitionConfigs = {
  PetTransition.happyToWalkHorizontally: _SpriteConfig(
    assetPath: 'assets/images/home/sprite_pets/lumni_happy_to_walk_horizontally.png',
    columns: 5,
    rows: 13,
    frameCount: 61,
    fps: 14,
  ),
  PetTransition.happyVsSmiling: _SpriteConfig(
    assetPath: 'assets/images/home/sprite_pets/lumni_happy_vs_smiling.png',
    columns: 5,
    rows: 8,
    frameCount: 36,
    fps: 14,
  ),
  PetTransition.idleToSleep: _SpriteConfig(
    assetPath: 'assets/images/home/sprite_pets/lumni_idle_to_sleep.png',
    columns: 5,
    rows: 13,
    frameCount: 61,
    fps: 14,
  ),
  PetTransition.lookingToWalkFront: _SpriteConfig(
    assetPath: 'assets/images/home/sprite_pets/lumni_looking_to_walk_front.png',
    columns: 5,
    rows: 4,
    frameCount: 20,
    fps: 14,
  ),
  PetTransition.lookFrontToBack: _SpriteConfig(
    assetPath: 'assets/images/home/sprite_pets/lumni_look_front_to_back.png',
    columns: 5,
    rows: 13,
    frameCount: 61,
    fps: 14,
  ),
  PetTransition.lookBackToFront: _SpriteConfig(
    assetPath: 'assets/images/home/sprite_pets/lumni_look_back_to_front.png',
    columns: 5,
    rows: 13,
    frameCount: 61,
    fps: 14,
  ),
};

// ─────────────────────────────────────────────
// PET STATE MACHINE
// ─────────────────────────────────────────────

/// Finite State Machine để quản lý hành vi và chuyển đổi của pet
class PetFSM extends ChangeNotifier {
  PetAnimation _currentAnimation;
  PetState? _targetState; // State mục tiêu sau khi transition hoàn tất
  Timer? _stateTimer;
  final math.Random _random = math.Random();
  
  // Zone management
  PetZone _currentZone = HomeZones.zone3;
  PetZone? _targetZone;
  
  /// Animation hiện tại đang chạy
  PetAnimation get currentAnimation => _currentAnimation;
  
  /// State hiện tại (nếu đang trong state ổn định)
  PetState? get currentState {
    final anim = _currentAnimation;
    return anim is _PetAnimationState ? anim.state : null;
  }
  
  /// Kiểm tra có đang trong transition không
  bool get isInTransition => _currentAnimation.isTransition;
  
  /// Zone hiện tại của pet
  PetZone get currentZone => _currentZone;
  
  /// Target zone khi đang di chuyển
  PetZone? get targetZone => _targetZone;
  
  PetFSM({
    PetState initialState = PetState.idle,
    PetZone? initialZone,
  })  : _currentAnimation = PetAnimation.state(initialState),
        _currentZone = initialZone ?? HomeZones.zone3 {
    _scheduleNextBehavior();
  }
  
  @override
  void dispose() {
    _stateTimer?.cancel();
    super.dispose();
  }
  
  // ═══════════════════════════════════════════
  // PUBLIC API
  // ═══════════════════════════════════════════
  
  /// Chuyển đến state mới (tự động tìm transition phù hợp nếu có)
  void transitionTo(PetState newState) {
    final current = currentState;
    if (current == null) return; // Đang trong transition, bỏ qua
    if (current == newState) return; // Đã ở state này rồi
    
    // Tìm transition phù hợp
    final transition = _findTransition(current, newState);
    
    if (transition != null) {
      // Có transition -> play transition, sau đó chuyển sang newState
      _playTransition(transition, targetState: newState);
    } else {
      // Không có transition -> chuyển trực tiếp
      _changeToState(newState);
    }
  }
  
  /// Bắt đầu hành vi random tự động
  void startAutoBehavior() {
    _scheduleNextBehavior();
  }
  
  /// Dừng hành vi tự động
  void stopAutoBehavior() {
    _stateTimer?.cancel();
    _stateTimer = null;
  }
  
  /// Force chuyển sang state ngay lập tức (không qua transition)
  void forceState(PetState state) {
    _changeToState(state);
  }
  
  // ═══════════════════════════════════════════
  // PRIVATE METHODS
  // ═══════════════════════════════════════════
  
  /// Đổi sang state mới và schedule behavior tiếp theo
  void _changeToState(PetState newState) {
    _currentAnimation = PetAnimation.state(newState);
    _targetState = null;
    notifyListeners();
    _scheduleNextBehavior();
  }
  
  /// Play transition animation với target state sau khi xong
  void _playTransition(PetTransition transition, {required PetState targetState}) {
    _currentAnimation = PetAnimation.transition(transition);
    _targetState = targetState;
    notifyListeners();
    
    // Transition sẽ tự động gọi _onTransitionComplete qua callback
  }
  
  /// Callback khi transition hoàn tất
  void onTransitionComplete() {
    if (_targetState != null) {
      _changeToState(_targetState!);
    } else {
      // Nếu không có target state, chọn random
      _changeToState(_randomIdleState());
    }
  }
  
  /// Tìm transition phù hợp giữa 2 states
  PetTransition? _findTransition(PetState from, PetState to) {
    // Map các transitions có sẵn
    final transitionMap = {
      (PetState.happy, PetState.walkingHorizontally): 
          PetTransition.happyToWalkHorizontally,
      (PetState.idle, PetState.sleep): 
          PetTransition.idleToSleep,
      (PetState.lookingOutside, PetState.walkingFront): 
          PetTransition.lookingToWalkFront,
      // Có thể thêm nhiều transitions khác
    };
    
    return transitionMap[(from, to)];
  }
  
  /// Lên lịch hành vi tiếp theo
  void _scheduleNextBehavior() {
    _stateTimer?.cancel();
    
    // Random thời gian chờ: 3-8 giây
    final delaySeconds = 3 + _random.nextInt(6);
    
    _stateTimer = Timer(Duration(seconds: delaySeconds), () {
      _performRandomBehavior();
    });
  }
  
  /// Thực hiện hành vi ngẫu nhiên dựa trên state hiện tại
  void _performRandomBehavior() {
    final current = currentState;
    if (current == null) return; // Đang trong transition
    
    switch (current) {
      case PetState.idle:
        // Từ idle có thể: ngủ, nhìn ra ngoài, đi lại
        final behaviors = [
          PetState.sleep,
          PetState.lookingOutside,
          PetState.walkingHorizontally,
          PetState.happy,
        ];
        transitionTo(behaviors[_random.nextInt(behaviors.length)]);
        break;
        
      case PetState.happy:
        // Từ happy có thể: đi ngang, idle, smiling
        final rand = _random.nextDouble();
        if (rand < 0.4) {
          transitionTo(PetState.walkingHorizontally);
        } else if (rand < 0.7) {
          transitionTo(PetState.idle);
        } else {
          // Play happy vs smiling transition rồi về happy
          _playTransition(
            PetTransition.happyVsSmiling, 
            targetState: PetState.happy,
          );
        }
        break;
        
      case PetState.sleep:
        // Từ sleep thường về idle
        transitionTo(PetState.idle);
        break;
        
      case PetState.lookingOutside:
        // Từ lookingOutside có thể đi về phía trước hoặc về idle
        final rand = _random.nextDouble();
        if (rand < 0.6) {
          transitionTo(PetState.walkingFront);
        } else {
          transitionTo(PetState.idle);
        }
        break;
        
      case PetState.walkingHorizontally:
      case PetState.walkingFront:
      case PetState.walkingAway:
        // Sau khi đi, về idle hoặc happy
        transitionTo(_random.nextBool() ? PetState.idle : PetState.happy);
        break;
        
      case PetState.sad:
        // Sad có thể về idle hoặc tiếp tục sad
        if (_random.nextBool()) {
          transitionTo(PetState.idle);
        } else {
          _scheduleNextBehavior(); // Stay sad
        }
        break;
    }
  }
  
  /// Random một state idle (idle, happy, lookingOutside)
  PetState _randomIdleState() {
    final states = [PetState.idle, PetState.happy, PetState.lookingOutside];
    return states[_random.nextInt(states.length)];
  }
  
  // ═══════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════
  
  /// Trigger pet về nhà (walking away)
  void goHome() {
    transitionTo(PetState.walkingAway);
  }
  
  /// Trigger pet đi ra (walking front)
  void comeOut() {
    // Nếu đang nhìn ra ngoài, dùng transition
    if (currentState == PetState.lookingOutside) {
      transitionTo(PetState.walkingFront);
    } else {
      forceState(PetState.walkingFront);
    }
  }
  
  /// Trigger pet buồn
  void makeSad() {
    forceState(PetState.sad);
  }
  
  /// Trigger pet vui
  void makeHappy() {
    forceState(PetState.happy);
  }
  
  // ═══════════════════════════════════════════
  // ZONE MANAGEMENT
  // ═══════════════════════════════════════════
  
  /// Di chuyển đến zone cụ thể
  void moveToZone(PetZone targetZone) {
    if (_currentZone == targetZone) return;
    
    _targetZone = targetZone;
    
    // Chọn animation phù hợp dựa trên direction
    final isMovingAway = targetZone.scale < _currentZone.scale; // Moving to smaller scale = away
    
    if (isMovingAway) {
      // Đi xa - về phía cottage
      transitionTo(PetState.walkingAway);
    } else {
      // Đi gần - ra phía trước
      transitionTo(PetState.walkingFront);
    }
    
    // Sau khi walking animation kết thúc, update zone
    Future.delayed(const Duration(seconds: 2), () {
      _currentZone = targetZone;
      _targetZone = null;
      notifyListeners();
    });
  }
  
  /// Di chuyển đến zone ngẫu nhiên
  void moveToRandomZone() {
    final newZone = HomeZones.randomZone();
    moveToZone(newZone);
  }
  
  /// Di chuyển ngang trong zone hiện tại
  void moveHorizontallyInZone() {
    transitionTo(PetState.walkingHorizontally);
  }
}

// ─────────────────────────────────────────────
// PET ZONE SYSTEM
// ─────────────────────────────────────────────

/// Định nghĩa 1 điểm vị trí mà pet có thể đứng
/// x, y là tọa độ normalized (0-1) của trọng tâm bottom của pet
class PetZone {
  final String name;
  final double x;          // tọa độ x normalized (0-1)
  final double y;          // tọa độ y normalized (0-1), anchor bottom của pet
  final double scale;      // tỷ lệ size pet (1.0 = 100%)

  const PetZone({
    required this.name,
    required this.x,
    required this.y,
    this.scale = 1.0,
  });
}

/// Các điểm vị trí cố định trên home screen
class HomeZones {
  // Zone 1 — Gần window, pet nhìn ra ngoài (xa nhất, nhỏ nhất)
  static const zone1 = PetZone(
    name: 'near_window',
    x: 0.75,
    y: 0.25,
    scale: 0.75,
  );

  // Zone 2 — Gần cottage/nhà pet (trung bình)
  static const zone2 = PetZone(
    name: 'near_cottage',
    x: 0.6,
    y: 0.17,
    scale: 0.9,
  );

  // Zone 3 — Bên trái thảm (gần nhất, lớn nhất)
  static const zone3 = PetZone(
    name: 'carpet_left',
    x: 0.15,
    y: 0.15,
    scale: 1.0,
  );

  // Zone 4 — Giữa thảm (gần nhất)
  static const zone4 = PetZone(
    name: 'carpet_center',
    x: 0.55,
    y: 0.15,
    scale: 1.0,
  );
  // Zone 5 — cuối thảm (gần nhất)
  static const zone5 = PetZone(
    name: 'carpet_right',
    x: 0.85,
    y: 0.15,
    scale: 1.0,
  );
  /// Danh sách tất cả các zone
  static const List<PetZone> all = [zone1, zone2, zone3, zone4, zone5];

  /// Lấy zone ngẫu nhiên
  static PetZone randomZone() {
    final random = math.Random();
    return all[random.nextInt(all.length)];
  }
}

// ─────────────────────────────────────────────
// WIDGET CHÍNH
// ─────────────────────────────────────────────

/// Hiển thị pet animation từ sprite sheet PNG.
///
/// Cách dùng:
/// ```dart
/// // State ổn định (loop)
/// PetAnimationWidget(
///   animation: PetAnimation.state(PetState.happy),
///   width: 180,
///   height: 180,
/// )
/// 
/// // Transition (play once)
/// PetAnimationWidget(
///   animation: PetAnimation.transition(PetTransition.idleToSleep),
///   width: 180,
///   height: 180,
///   onTransitionComplete: () => print('Transition done!'),
/// )
/// ```
class PetAnimationWidget extends StatefulWidget {
  final PetAnimation animation;
  final double width;
  final double height;
  
  /// Callback khi transition hoàn thành (chỉ dùng cho transition)
  final VoidCallback? onTransitionComplete;

  const PetAnimationWidget({
    super.key,
    required this.animation,
    this.width = 80,
    this.height = 80,
    this.onTransitionComplete,
  });

  @override
  State<PetAnimationWidget> createState() => _PetAnimationWidgetState();
}

class _PetAnimationWidgetState extends State<PetAnimationWidget>
    with TickerProviderStateMixin {
  // Cache dùng chung toàn app — load 1 lần duy nhất
  static final Map<String, ui.Image> _cache = {};

  AnimationController? _controller;
  ui.Image? _sheet;
  bool _loading = true;

  // ── Lifecycle ──

  @override
  void initState() {
    super.initState();
    _load(widget.animation);
  }

  @override
  void didUpdateWidget(PetAnimationWidget old) {
    super.didUpdateWidget(old);
    if (old.animation != widget.animation) {
      _disposeController();
      _load(widget.animation);
    }
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  void _disposeController() {
    _controller?.stop();
    _controller?.dispose();
    _controller = null;
  }

  // ── Load sprite sheet ──

  Future<void> _load(PetAnimation animation) async {
    if (!mounted) return;
    setState(() => _loading = true);

    final config = animation.config;

    try {
      // Dùng cache nếu đã load trước đó
      ui.Image image;
      if (_cache.containsKey(config.assetPath)) {
        image = _cache[config.assetPath]!;
      } else {
        final data = await rootBundle.load(config.assetPath);
        final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
        final frame = await codec.getNextFrame();
        image = frame.image;
        _cache[config.assetPath] = image;
      }

      if (!mounted) return;

      // Setup controller: duration = tổng thời gian 1 cycle
      final durationMs = (config.frameCount / config.fps * 1000).toInt();
      _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationMs),
      );
      
      // State: loop liên tục, Transition: play một lần rồi callback
      if (animation.isTransition) {
        _controller!.forward().then((_) {
          if (mounted) {
            widget.onTransitionComplete?.call();
          }
        });
      } else {
        _controller!.repeat();
      }

      setState(() {
        _sheet = image;
        _loading = false;
      });
    } catch (e) {
      debugPrint('[PetAnim] Failed to load ${config.assetPath}: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    if (_loading || _sheet == null || _controller == null) {
      // Placeholder trong suốt khi đang load
      return SizedBox(width: widget.width, height: widget.height);
    }

    final config = widget.animation.config;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller!,
        builder: (_, __) {
          final frame =
              (_controller!.value * config.frameCount).floor().clamp(0, config.frameCount - 1);
          return CustomPaint(
            size: Size(widget.width, widget.height),
            painter: _SpritePainter(
              sheet: _sheet!,
              frameIndex: frame,
              columns: config.columns,
              rows: config.rows,
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PAINTER
// ─────────────────────────────────────────────

class _SpritePainter extends CustomPainter {
  final ui.Image sheet;
  final int frameIndex;
  final int columns;
  final int rows;

  const _SpritePainter({
    required this.sheet,
    required this.frameIndex,
    required this.columns,
    required this.rows,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fw = sheet.width / columns;
    final fh = sheet.height / rows;

    final col = frameIndex % columns;
    final row = frameIndex ~/ columns;

    // Vùng cắt từ sprite sheet
    final src = Rect.fromLTWH(col * fw, row * fh, fw, fh);

    // Fit vào widget giữ aspect ratio (BoxFit.contain)
    final frameAspect = fw / fh;
    final widgetAspect = size.width / size.height;

    double dw, dh, dx, dy;
    if (widgetAspect > frameAspect) {
      dh = size.height;
      dw = dh * frameAspect;
      dx = (size.width - dw) / 2;
      dy = 0;
    } else {
      dw = size.width;
      dh = dw / frameAspect;
      dx = 0;
      dy = (size.height - dh) / 2;
    }

    final dst = Rect.fromLTWH(dx, dy, dw, dh);

    canvas.drawImageRect(
      sheet,
      src,
      dst,
      Paint()
        ..filterQuality = FilterQuality.medium
        // BlendMode.screen loại bỏ background đen
        // ..blendMode = BlendMode.screen,
    );
  }

  @override
  bool shouldRepaint(_SpritePainter old) =>
      old.frameIndex != frameIndex || old.sheet != sheet;
}

// ─────────────────────────────────────────────
// STATEFUL PET WIDGET (với FSM tích hợp)
// ─────────────────────────────────────────────

/// Widget pet thông minh với FSM tự động quản lý behaviors
///
/// Cách dùng:
/// ```dart
/// StatefulPetWidget(
///   width: 180,
///   height: 180,
///   autoPlay: true, // Tự động chạy behaviors
/// )
/// ```
class StatefulPetWidget extends StatefulWidget {
  final double width;
  final double height;
  final bool autoPlay;
  final PetState initialState;

  const StatefulPetWidget({
    super.key,
    this.width = 160,
    this.height = 160,
    this.autoPlay = true,
    this.initialState = PetState.idle,
  });

  @override
  State<StatefulPetWidget> createState() => StatefulPetWidgetState();
}

class StatefulPetWidgetState extends State<StatefulPetWidget> {
  late PetFSM _fsm;

  @override
  void initState() {
    super.initState();
    _fsm = PetFSM(initialState: widget.initialState);
    _fsm.addListener(_updateAnimation);
    
    if (widget.autoPlay) {
      _fsm.startAutoBehavior();
    }
  }

  @override
  void dispose() {
    _fsm.removeListener(_updateAnimation);
    _fsm.dispose();
    super.dispose();
  }

  void _updateAnimation() {
    setState(() {});
  }

  // ═══════════════════════════════════════════
  // PUBLIC API - Có thể gọi từ parent widget
  // ═══════════════════════════════════════════

  /// Bắt đầu auto behavior
  void startAuto() => _fsm.startAutoBehavior();

  /// Dừng auto behavior
  void stopAuto() => _fsm.stopAutoBehavior();

  /// Chuyển đến state cụ thể
  void transitionTo(PetState state) => _fsm.transitionTo(state);

  /// Pet về nhà
  void goHome() => _fsm.goHome();

  /// Pet đi ra
  void comeOut() => _fsm.comeOut();

  /// Pet buồn
  void makeSad() => _fsm.makeSad();

  /// Pet vui
  void makeHappy() => _fsm.makeHappy();

  /// Lấy FSM để control chi tiết hơn
  PetFSM get fsm => _fsm;

  @override
  Widget build(BuildContext context) {
    return PetAnimationWidget(
      animation: _fsm.currentAnimation,
      width: widget.width,
      height: widget.height,
      onTransitionComplete: _fsm.onTransitionComplete,
    );
  }
}

// ─────────────────────────────────────────────
// PET WITH ZONE WIDGET (Pet + Position + FSM)
// ─────────────────────────────────────────────

/// Widget pet với zone positioning tích hợp
///
/// Pet sẽ tự động di chuyển giữa các zones, thay đổi scale và position
///
/// Cách dùng:
/// ```dart
/// PetWithZoneWidget(
///   width: 180,
///   height: 180,
///   autoPlay: true,
///   enableZoneMovement: true, // Tự động di chuyển giữa zones
/// )
/// ```
class PetWithZoneWidget extends StatefulWidget {
  final double width;
  final double height;
  final bool autoPlay;
  final bool enableZoneMovement;
  final PetState initialState;
  final PetZone? initialZone;

  const PetWithZoneWidget({
    super.key,
    this.width = 160,
    this.height = 160,
    this.autoPlay = true,
    this.enableZoneMovement = true,
    this.initialState = PetState.idle,
    this.initialZone,
  });

  @override
  State<PetWithZoneWidget> createState() => PetWithZoneWidgetState();
}

class PetWithZoneWidgetState extends State<PetWithZoneWidget>
    with SingleTickerProviderStateMixin {
  late PetFSM _fsm;
  late AnimationController _moveController;
  late Animation<double> _xAnimation;
  late Animation<double> _scaleAnimation;
  
  double _currentX = 0.5; // Normalized position (0-1)
  double _targetX = 0.5;
  double _currentScale = 1.0;
  double _targetScale = 1.0;
  bool _flipHorizontal = false; // Lật pet khi đi sang trái

  @override
  void initState() {
    super.initState();
    
    // Initialize FSM
    final initialZone = widget.initialZone ?? HomeZones.zone3;
    _fsm = PetFSM(
      initialState: widget.initialState,
      initialZone: initialZone,
    );
    _fsm.addListener(_onFSMUpdate);
    
    // Initialize position
    _currentX = initialZone.x;
    _currentScale = initialZone.scale;
    _targetX = _currentX;
    _targetScale = _currentScale;
    
    // Initialize animation controller for smooth movement
    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _xAnimation = Tween<double>(begin: _currentX, end: _targetX)
        .animate(CurvedAnimation(
      parent: _moveController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(begin: _currentScale, end: _targetScale)
        .animate(CurvedAnimation(
      parent: _moveController,
      curve: Curves.easeInOut,
    ));
    
    _moveController.addListener(() {
      setState(() {
        _currentX = _xAnimation.value;
        _currentScale = _scaleAnimation.value;
      });
    });
    
    if (widget.autoPlay) {
      _fsm.startAutoBehavior();
    }
    
    if (widget.enableZoneMovement) {
      _scheduleRandomZoneMovement();
    }
  }

  @override
  void dispose() {
    _fsm.removeListener(_onFSMUpdate);
    _fsm.dispose();
    _moveController.dispose();
    super.dispose();
  }

  void _onFSMUpdate() {
    setState(() {});
    
    // Update position/scale khi zone thay đổi
    final zone = _fsm.currentZone;
    final state = _fsm.currentState;
    
    if (state == PetState.walkingAway || 
        state == PetState.walkingFront ||
        state == PetState.walkingHorizontally) {
      _moveToPosition(zone);
    }
  }

  void _moveToPosition(PetZone zone) {
    // Xác định vị trí mục tiêu - dùng x của zone (điểm cố định)
    final newX = zone.x;
    final newScale = zone.scale;
    
    // Flip pet nếu đi sang trái
    _flipHorizontal = newX < _currentX;
    
    // Animate to new position
    _targetX = newX;
    _targetScale = newScale;
    
    _xAnimation = Tween<double>(begin: _currentX, end: _targetX)
        .animate(CurvedAnimation(
      parent: _moveController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(begin: _currentScale, end: _targetScale)
        .animate(CurvedAnimation(
      parent: _moveController,
      curve: Curves.easeInOut,
    ));
    
    _moveController.forward(from: 0);
  }

  void _scheduleRandomZoneMovement() {
    Future.delayed(Duration(seconds: 8 + _fsm._random.nextInt(7)), () {
      if (!mounted) return;
      
      // 30% chance để đổi zone
      if (_fsm._random.nextDouble() < 0.3) {
        _fsm.moveToRandomZone();
      }
      
      _scheduleRandomZoneMovement();
    });
  }

  // ═══════════════════════════════════════════
  // PUBLIC API
  // ═══════════════════════════════════════════

  void startAuto() => _fsm.startAutoBehavior();
  void stopAuto() => _fsm.stopAutoBehavior();
  void transitionTo(PetState state) => _fsm.transitionTo(state);
  void goHome() => _fsm.goHome();
  void comeOut() => _fsm.comeOut();
  void makeSad() => _fsm.makeSad();
  void makeHappy() => _fsm.makeHappy();
  void moveToZone(PetZone zone) => _fsm.moveToZone(zone);
  void moveToRandomZone() => _fsm.moveToRandomZone();
  PetFSM get fsm => _fsm;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final zone = _fsm.currentZone;
        
        // zone.y là vị trí normalized từ TOP (0=top, 1=bottom)
        // bottom của pet = (1 - zone.y) * screenHeight từ đáy màn hình
        final petBottom = (1 - zone.y) * screenHeight;
        
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: _currentX * screenWidth - (widget.width * _currentScale / 2),
          bottom: petBottom,
          curve: Curves.easeInOut,
          child: Transform.scale(
            scale: _currentScale,
            child: Transform(
              transform: Matrix4.identity()
                ..scale(_flipHorizontal ? -1.0 : 1.0, 1.0),
              alignment: Alignment.center,
              child: PetAnimationWidget(
                animation: _fsm.currentAnimation,
                width: widget.width,
                height: widget.height,
                onTransitionComplete: _fsm.onTransitionComplete,
              ),
            ),
          ),
        );
      },
    );
  }
}