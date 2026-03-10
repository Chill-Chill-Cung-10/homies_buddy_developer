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
  happy,           // Vui vẻ
  idle,            // Đứng im, quan sát
  sleep,           // Ngủ
  sad,             // Buồn
  happyVsSmilling, // Happy variant
  lookingOutside,  // Nhìn ra ngoài / xa cách
}

/// Các animation chuyển đổi giữa các trạng thái (play once)
enum PetTransition {
  idleToSleep,     // idle → sleep
  lookFrontToBack, // quay từ trước ra sau
  lookBackToFront, // quay từ sau ra trước (reverse của lookFrontToBack)
}

/// Sealed class đại diện cho bất kỳ animation nào của pet
sealed class PetAnimation {
  const PetAnimation();

  factory PetAnimation.state(PetState state) = _PetAnimationState;
  factory PetAnimation.transition(PetTransition transition) =
      _PetAnimationTransition;

  _SpriteConfig get config;
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
  final int frameCount;
  final double fps;
  final bool reversePlayback;

  const _SpriteConfig({
    required this.assetPath,
    required this.columns,
    required this.rows,
    required this.frameCount,
    required this.fps,
    this.reversePlayback = false,
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
  PetState.happyVsSmilling: _SpriteConfig(
    assetPath: 'assets/images/home/sprite_pets/lumni_happy_vs_smiling.png',
    columns: 5,
    rows: 8,
    frameCount: 36,
    fps: 14,
  ),
};

// ── Cấu hình sprite cho các TRANSITION (play once) ──
const Map<PetTransition, _SpriteConfig> _transitionConfigs = {
  PetTransition.idleToSleep: _SpriteConfig(
    assetPath: 'assets/images/home/sprite_pets/lumni_idle_to_sleep.png',
    columns: 5,
    rows: 13,
    frameCount: 61,
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
    assetPath: 'assets/images/home/sprite_pets/lumni_look_front_to_back.png',
    columns: 5,
    rows: 13,
    frameCount: 61,
    fps: 14,
    reversePlayback: true,
  ),
};

// ─────────────────────────────────────────────
// PET STATE MACHINE
// ─────────────────────────────────────────────

/// Finite State Machine để quản lý hành vi và chuyển đổi của pet
class PetFSM extends ChangeNotifier {
  PetAnimation _currentAnimation;
  PetState? _targetState;
  Timer? _stateTimer;
  final math.Random _random = math.Random();

  PetAnimation get currentAnimation => _currentAnimation;

  PetState? get currentState {
    final anim = _currentAnimation;
    return anim is _PetAnimationState ? anim.state : null;
  }

  bool get isInTransition => _currentAnimation.isTransition;

  PetFSM({PetState initialState = PetState.idle})
      : _currentAnimation = PetAnimation.state(initialState) {
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
    if (current == null) return; // Đang trong transition
    if (current == newState) return;

    final transition = _findTransition(current, newState);

    if (transition != null) {
      _playTransition(transition, targetState: newState);
    } else {
      _changeToState(newState);
    }
  }

  void startAutoBehavior() => _scheduleNextBehavior();

  void stopAutoBehavior() {
    _stateTimer?.cancel();
    _stateTimer = null;
  }

  /// Force chuyển sang state ngay lập tức (không qua transition)
  void forceState(PetState state) => _changeToState(state);

  // ═══════════════════════════════════════════
  // PRIVATE METHODS
  // ═══════════════════════════════════════════

  void _changeToState(PetState newState) {
    _currentAnimation = PetAnimation.state(newState);
    _targetState = null;
    notifyListeners();
    _scheduleNextBehavior();
  }

  void _playTransition(PetTransition transition, {required PetState targetState}) {
    _currentAnimation = PetAnimation.transition(transition);
    _targetState = targetState;
    notifyListeners();
  }

  void onTransitionComplete() {
    if (_targetState != null) {
      _changeToState(_targetState!);
    } else {
      _changeToState(PetState.idle);
    }
  }

  /// Tìm transition phù hợp giữa 2 states
  PetTransition? _findTransition(PetState from, PetState to) {
    const transitionMap = {
      // idle → sleep
      (PetState.idle, PetState.sleep): PetTransition.idleToSleep,

      // lookingOutside → idle: quay mặt lại trước
      (PetState.lookingOutside, PetState.idle): PetTransition.lookBackToFront,
      (PetState.lookingOutside, PetState.happy): PetTransition.lookBackToFront,
      (PetState.lookingOutside, PetState.sad): PetTransition.lookBackToFront,

      // idle/happy → lookingOutside: quay mặt ra sau
      (PetState.idle, PetState.lookingOutside): PetTransition.lookFrontToBack,
      (PetState.happy, PetState.lookingOutside): PetTransition.lookFrontToBack,
    };

    return transitionMap[(from, to)];
  }

  /// Lên lịch hành vi tiếp theo (auto behavior)
  void _scheduleNextBehavior() {
    _stateTimer?.cancel();

    // Random 5-12 giây giữa các behavior
    final delaySeconds = 5 + _random.nextInt(8);
    _stateTimer = Timer(Duration(seconds: delaySeconds), _performRandomBehavior);
  }

  /// Thực hiện hành vi ngẫu nhiên dựa trên state hiện tại
  /// Chỉ dùng cho auto-idle behavior — KHÔNG override behavior từ note_analysis
  void _performRandomBehavior() {
    final current = currentState;
    if (current == null) return; // Đang trong transition

    switch (current) {
      // ── IDLE: điểm trung tâm, có thể đi mọi hướng ──
      case PetState.idle:
        final roll = _random.nextDouble();
        if (roll < 0.30) {
          transitionTo(PetState.sleep);           // 30% → ngủ
        } else if (roll < 0.55) {
          transitionTo(PetState.lookingOutside);  // 25% → nhìn ra ngoài
        } else if (roll < 0.80) {
          transitionTo(PetState.happy);           // 25% → happy
        } else {
          _scheduleNextBehavior();                // 20% → ở lại idle
        }

      // ── HAPPY: vui, thỉnh thoảng smiling ──
      case PetState.happy:
        final roll = _random.nextDouble();
        if (roll < 0.40) {
          // Happy variant (play once → về happy)
          _playTransition(PetTransition.lookFrontToBack, targetState: PetState.happy);
          // Dùng tạm lookFrontToBack như "idle movement" nếu chưa có happyVsSmiling transition
          // TODO: thay bằng PetTransition.happyVsSmiling khi có asset
        } else if (roll < 0.70) {
          transitionTo(PetState.idle);            // 30% → về idle
        } else {
          transitionTo(PetState.lookingOutside);  // 30% → nhìn ra ngoài
        }

      // ── SLEEP: thỉnh thoảng thức dậy ──
      case PetState.sleep:
        // Sau 1 chu kỳ sleep, về idle
        transitionTo(PetState.idle);

      // ── LOOKING OUTSIDE: có thể quay lại hoặc ở lại ──
      case PetState.lookingOutside:
        final roll = _random.nextDouble();
        if (roll < 0.60) {
          transitionTo(PetState.idle);   // 60% → quay về idle (có transition)
        } else {
          transitionTo(PetState.happy);  // 40% → quay về happy (có transition)
        }

      // ── SAD / HAPPYVSSMILLING: không auto-change ──
      // Những state này được drive bởi note_analysis, không random
      case PetState.sad:
      case PetState.happyVsSmilling:
        _scheduleNextBehavior(); // Ở lại, check lại sau
    }
  }

  // ═══════════════════════════════════════════
  // HELPER SHORTCUTS
  // ═══════════════════════════════════════════

  void makeSad() => forceState(PetState.sad);
  void makeHappy() => forceState(PetState.happy);
  void makeSleep() => transitionTo(PetState.sleep);
  void makeIdle() => transitionTo(PetState.idle);
  void makeLookOutside() => transitionTo(PetState.lookingOutside);
}

// ─────────────────────────────────────────────
// NOTE ANALYSIS → PET STATE
// ─────────────────────────────────────────────

/// Map kết quả từ note_analysis sang PetState
///
/// Gọi hàm này sau khi nhận được data từ Supabase
PetState decidePetStateFromAnalysis({
  required String tone,       // từ note_analysis.current_tone
  required String trend,      // từ note_analysis.emotional_trend
  required int severity,      // từ note_analysis.severity_level (1-5)
  required double deltaHours, // giờ kể từ lần mở app cuối
  required int currentHour,   // DateTime.now().hour
}) {
  // ── Rule 1: Giờ ngủ → sleep ──
  final isSleepHour = currentHour >= 23 || currentHour <= 5;
  if (isSleepHour) return PetState.sleep;

  // ── Rule 2: Bỏ rơi > 48h → nhìn ra ngoài buồn bã ──
  if (deltaHours > 48) return PetState.lookingOutside;

  // ── Rule 3: Dựa trên tone từ AI ──
  switch (tone) {
    case 'verySad':
      // Rất buồn, severity cao → sad
      return PetState.sad;

    case 'sad':
      // Severity cao → sad, severity thấp → idle cảm thông
      return severity >= 3 ? PetState.sad : PetState.idle;

    case 'anxious':
      // Lo lắng → idle (hiện diện nhưng không quá phấn khích)
      return PetState.idle;

    case 'angry':
      // Tức giận → nhìn ra ngoài (tránh mặt nhẹ)
      return PetState.lookingOutside;

    case 'happy':
      return PetState.happy;

    case 'veryHappy':
      // Rất vui → happy variant
      return PetState.happyVsSmilling;

    case 'neutral':
    default:
      // ── Rule 4: Neutral → dựa trên trend ──
      return _resolveNeutralTone(trend);
  }
}

PetState _resolveNeutralTone(String trend) {
  switch (trend) {
    case 'improving':
      return PetState.happy;
    case 'declining':
      return PetState.sad;
    case 'volatile':
      return PetState.idle; // Ổn định, không phản ứng thái quá
    case 'stable':
    default:
      return PetState.idle;
  }
}

// ─────────────────────────────────────────────
// WIDGET CHÍNH
// ─────────────────────────────────────────────

class PetAnimationWidget extends StatefulWidget {
  final PetAnimation animation;
  final double width;
  final double height;
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
  static final Map<String, ui.Image> _cache = {};

  AnimationController? _controller;
  ui.Image? _sheet;
  bool _loading = true;

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

  Future<void> _load(PetAnimation animation) async {
    if (!mounted) return;
    setState(() => _loading = true);

    final config = animation.config;

    try {
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

      final durationMs = (config.frameCount / config.fps * 1000).toInt();
      _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durationMs),
      );

      if (animation.isTransition) {
        _controller!.forward().then((_) {
          if (mounted) widget.onTransitionComplete?.call();
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

  @override
  Widget build(BuildContext context) {
    if (_loading || _sheet == null || _controller == null) {
      return SizedBox(width: widget.width, height: widget.height);
    }

    final config = widget.animation.config;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller!,
        builder: (_, __) {
          final rawFrame = (_controller!.value * config.frameCount)
              .floor()
              .clamp(0, config.frameCount - 1);
          final frame = config.reversePlayback
              ? (config.frameCount - 1 - rawFrame)
              : rawFrame;
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

    final src = Rect.fromLTWH(col * fw, row * fh, fw, fh);

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

    canvas.drawImageRect(
      sheet,
      src,
      Rect.fromLTWH(dx, dy, dw, dh),
      Paint()..filterQuality = FilterQuality.medium,
    );
  }

  @override
  bool shouldRepaint(_SpritePainter old) =>
      old.frameIndex != frameIndex || old.sheet != sheet;
}

// ─────────────────────────────────────────────
// STATEFUL PET WIDGET (FSM tích hợp)
// ─────────────────────────────────────────────

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
    _fsm.addListener(_rebuild);
    if (widget.autoPlay) _fsm.startAutoBehavior();
  }

  @override
  void dispose() {
    _fsm.removeListener(_rebuild);
    _fsm.dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  // ═══════════════════════════════════════════
  // PUBLIC API
  // ═══════════════════════════════════════════

  void startAuto() => _fsm.startAutoBehavior();
  void stopAuto() => _fsm.stopAutoBehavior();
  void transitionTo(PetState state) => _fsm.transitionTo(state);
  void makeSad() => _fsm.makeSad();
  void makeHappy() => _fsm.makeHappy();
  void makeSleep() => _fsm.makeSleep();
  void makeIdle() => _fsm.makeIdle();
  void makeLookOutside() => _fsm.makeLookOutside();
  PetFSM get fsm => _fsm;

  /// Áp dụng trực tiếp từ note_analysis
  void applyAnalysis({
    required String tone,
    required String trend,
    required int severity,
    required double deltaHours,
  }) {
    final targetState = decidePetStateFromAnalysis(
      tone: tone,
      trend: trend,
      severity: severity,
      deltaHours: deltaHours,
      currentHour: DateTime.now().hour,
    );
    _fsm.stopAutoBehavior(); // Tắm auto khi có analysis
    _fsm.transitionTo(targetState);
  }

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
// PET ZONE SYSTEM
// ─────────────────────────────────────────────

class PetZone {
  final String name;
  final double x;
  final double y;
  final double scale;

  const PetZone({
    required this.name,
    required this.x,
    required this.y,
    this.scale = 1.0,
  });
}

class HomeZones {
  static const zone1 = PetZone(name: 'near_window',    x: 0.75, y: 0.25, scale: 0.75);
  static const zone2 = PetZone(name: 'near_cottage',   x: 0.60, y: 0.17, scale: 0.90);
  static const zone3 = PetZone(name: 'carpet_left',    x: 0.15, y: 0.15, scale: 1.00);
  static const zone4 = PetZone(name: 'carpet_center',  x: 0.55, y: 0.15, scale: 1.00);
  static const zone5 = PetZone(name: 'carpet_right',   x: 0.85, y: 0.15, scale: 1.00);

  static const List<PetZone> all = [zone1, zone2, zone3, zone4, zone5];

  static PetZone randomZone() => all[math.Random().nextInt(all.length)];
}