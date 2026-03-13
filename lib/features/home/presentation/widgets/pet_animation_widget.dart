import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math' as math;

// ─────────────────────────────────────────────
// ENUM & CONFIG
// ─────────────────────────────────────────────

enum PetState {
  happy,
  idle,
  sleep,
  sad,
  happyVsSmilling,
  lookingOutside,
}

enum PetTransition {
  idleToSleep,
  lookFrontToBack,
  lookBackToFront, sleepToIdle,
}

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
    frameCount: 37,
    fps: 14,
  ),
};

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
    rows: 7,
    frameCount: 34,
    fps: 14,
  ),
  PetTransition.lookBackToFront: _SpriteConfig(
    assetPath: 'assets/images/home/sprite_pets/lumni_look_front_to_back.png',
    columns: 5,
    rows: 7,
    frameCount: 34,
    fps: 14,
    reversePlayback: true,
  ),
  PetTransition.sleepToIdle: _SpriteConfig(
    assetPath: 'assets/images/home/sprite_pets/lumni_idle_to_sleep.png',
    columns: 5,
    rows: 13,
    frameCount: 61,
    fps: 14,
    reversePlayback: true,
  )
};

// ─────────────────────────────────────────────
// PET STATE MACHINE
// ─────────────────────────────────────────────

class PetFSM extends ChangeNotifier {
  PetAnimation _currentAnimation;
  PetState? _targetState;
  Timer? _stateTimer;

  bool _autoBehaviorEnabled = false;

  /// Mood do DB quyết định — "home base" mà auto behavior luôn phải quay về.
  PetState _dbMood = PetState.idle;

  /// Energy nhận từ DB (0.0 → 1.0).
  /// Quyết định pet có tự ngủ không — không do DB set sleep trực tiếp.
  double _energy = 1.0;

  // Ngưỡng energy
  static const double _sleepThreshold  = 0.25; // < 25% → tự ngủ
  static const double _tiredThreshold  = 0.50; // < 50% → hạn chế hoạt động

  final math.Random _random = math.Random();

  PetAnimation get currentAnimation => _currentAnimation;

  PetState? get currentState {
    final anim = _currentAnimation;
    return anim is _PetAnimationState ? anim.state : null;
  }

  bool get isInTransition => _currentAnimation.isTransition;

  /// Mood hiện tại do DB set — dùng để debug log bên ngoài.
  PetState get dbMood => _dbMood;

  PetFSM({PetState initialState = PetState.idle})
      : _currentAnimation = PetAnimation.state(initialState),
        _dbMood = initialState;

  @override
  void dispose() {
    _stateTimer?.cancel();
    super.dispose();
  }

  // ═══════════════════════════════════════════
  // PUBLIC API
  // ═══════════════════════════════════════════

  /// Entry point duy nhất cho DB/external mood update.
  ///
  /// - [mood]           : mood mới từ DB
  /// - [energy]         : energy mới từ DB (0.0–1.0), dùng để quyết định sleep
  /// - [withTransition] : có chạy transition animation không
  ///
  /// Flow:
  ///   1. Cập nhật _dbMood và _energy
  ///   2. Cancel timer cũ
  ///   3. Nếu energy thấp → ưu tiên sleep ngay, bỏ qua mood DB
  ///   4. Nếu không → chuyển sang mood DB (có/không transition)
  ///   5. Restart auto behavior
  void setMoodFromDB(
    PetState mood, {
    double energy = 1.0,
    bool withTransition = false,
  }) {
    _dbMood  = mood;
    _energy  = energy.clamp(0.0, 1.0);

    // Cancel timer cũ — bắt đầu fresh
    stopAutoBehavior();

    // Energy quá thấp → ngủ ngay, bất kể mood DB
    if (_energy < _sleepThreshold && mood != PetState.sad) {
      _goSleep();
    } else if (withTransition && currentState != null && currentState != mood) {
      if (isInTransition) {
        // Đang chạy transition → override target, animation hiện tại
        // chạy tiếp rồi onTransitionComplete sẽ về đúng mood
        _targetState = mood;
      } else {
        final t = _findTransition(currentState!, mood);
        if (t != null) {
          _playTransition(t, targetState: mood);
        } else {
          _changeToState(mood);
        }
      }
    } else {
      _currentAnimation = PetAnimation.state(mood);
      _targetState = null;
      notifyListeners();
    }

    startAutoBehavior();
  }

  void startAutoBehavior() {
    _autoBehaviorEnabled = true;
    _scheduleNextBehavior();
  }

  void stopAutoBehavior() {
    _autoBehaviorEnabled = false;
    _stateTimer?.cancel();
    _stateTimer = null;
  }

  /// Chỉ dùng nội bộ cho auto behavior transitions.
  /// Bên ngoài FSM nên dùng [setMoodFromDB].
  void transitionTo(PetState newState) {
    final current = currentState;
    if (current == null) return;
    if (current == newState) return;

    final transition = _findTransition(current, newState);
    if (transition != null) {
      _playTransition(transition, targetState: newState);
    } else {
      _changeToState(newState);
    }
  }

  /// @deprecated Dùng [setMoodFromDB] thay thế.
  void forceState(PetState state) => setMoodFromDB(state);

  // ═══════════════════════════════════════════
  // PRIVATE METHODS
  // ═══════════════════════════════════════════

  void _changeToState(PetState newState) {
    _currentAnimation = PetAnimation.state(newState);
    _targetState = null;
    notifyListeners();

    if (_autoBehaviorEnabled) {
      _scheduleNextBehavior();
    }
  }

  void _playTransition(
    PetTransition transition, {
    required PetState targetState,
  }) {
    _currentAnimation = PetAnimation.transition(transition);
    _targetState = targetState;
    notifyListeners();
  }

  void onTransitionComplete() {
    // Ưu tiên _targetState, fallback về _dbMood — không bao giờ về idle mặc định
    _changeToState(_targetState ?? _dbMood);
  }

  PetTransition? _findTransition(PetState from, PetState to) {
    const transitionMap = {
      (PetState.idle, PetState.sleep): PetTransition.idleToSleep,
      (PetState.lookingOutside, PetState.idle): PetTransition.lookBackToFront,
      (PetState.lookingOutside, PetState.happy): PetTransition.lookBackToFront,
      (PetState.lookingOutside, PetState.sad): PetTransition.lookBackToFront,
      (PetState.idle, PetState.lookingOutside): PetTransition.lookFrontToBack,
      (PetState.happy, PetState.lookingOutside): PetTransition.lookFrontToBack,
      (PetState.happyVsSmilling, PetState.lookingOutside): PetTransition.lookFrontToBack,
      (PetState.sleep, PetState.idle): PetTransition.sleepToIdle,

    };
    return transitionMap[(from, to)];
  } 

  void _scheduleNextBehavior() {
    _stateTimer?.cancel();
    if (!_autoBehaviorEnabled) return;

    final delaySeconds = 140 + _random.nextInt(8);
    _stateTimer = Timer(
      Duration(seconds: delaySeconds),
      _performRandomBehavior,
    );
  }

  void _performRandomBehavior() {
    if (!_autoBehaviorEnabled) return;

    final current = currentState;
    if (current == null) return; // Đang transition → chờ

    // ── Ưu tiên sleep nếu energy cạn, bất kể mood ──
    // (trừ sad — pet buồn không cần sleep logic này)
    if (_energy < _sleepThreshold && _dbMood != PetState.sad) {
      if (current != PetState.sleep) {
        _goSleep();
      } else {
        _scheduleNextBehavior(); // Đang ngủ rồi → tiếp tục ngủ
      }
      return;
    }

    // ── Pet đang ngủ nhưng energy đã phục hồi → thức dậy ──
    if (current == PetState.sleep) {
      transitionTo(_dbMood); // Thức dậy về đúng mood DB
      return;
    }

    // ── Auto behavior theo _dbMood ──
    switch (_dbMood) {

      // Mood tích cực + còn sức: xoay happy ↔ lookingOutside
      case PetState.happy:
      case PetState.happyVsSmilling:
        if (_energy < _tiredThreshold) {
          // Hơi mệt → không nhìn ra ngoài, ở lại
          _scheduleNextBehavior();
        } else if (current == PetState.lookingOutside) {
          transitionTo(_dbMood); // Quay về mood gốc
        } else {
          final roll = _random.nextDouble();
          if (roll < 0.45) {
            transitionTo(PetState.lookingOutside);
          } else {
            _scheduleNextBehavior();
          }
        }

      // Mood trung tính: xoay idle ↔ lookingOutside (không sleep ở đây — đã handle ở trên)
      case PetState.idle:
      case PetState.lookingOutside:
      case PetState.sleep:
        if (_energy < _tiredThreshold) {
          // Mệt nhưng chưa ngủ → chỉ idle, không lookingOutside
          if (current != PetState.idle) {
            transitionTo(PetState.idle);
          } else {
            _scheduleNextBehavior();
          }
        } else if (current == PetState.lookingOutside) {
          transitionTo(PetState.idle);
        } else {
          final roll = _random.nextDouble();
          if (roll < 0.45) {
            transitionTo(PetState.lookingOutside);
          } else {
            _scheduleNextBehavior();
          }
        }

      // Mood tiêu cực: đứng im, không tự thay đổi
      case PetState.sad:
        _scheduleNextBehavior();
    }
  }

  /// Chuyển pet vào sleep — tìm transition animation nếu có.
  void _goSleep() {
    final current = currentState;
    if (current == null || current == PetState.sleep) return;

    final t = _findTransition(current, PetState.sleep);
    if (t != null) {
      _playTransition(t, targetState: PetState.sleep);
    } else {
      _changeToState(PetState.sleep);
    }
  }

  // ═══════════════════════════════════════════
  // HELPER SHORTCUTS
  // ═══════════════════════════════════════════

  void makeSad()         => setMoodFromDB(PetState.sad);
  void makeHappy()       => setMoodFromDB(PetState.happy);
  void makeSleep()       => setMoodFromDB(PetState.sleep);
  void makeIdle()        => setMoodFromDB(PetState.idle);
  void makeLookOutside() => setMoodFromDB(PetState.lookingOutside);
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
        builder: (_, _) {
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
// STATEFUL PET WIDGET
// ─────────────────────────────────────────────

class StatefulPetWidget extends StatefulWidget {
  final double width;
  final double height;
  final bool autoPlay;
  final PetState initialState;

  // ── Callback khi widget đã mount và FSM sẵn sàng ──
  // Dùng để apply pending mood từ HomeScreen nếu DB query
  // trả về trước khi widget được build xong
  final VoidCallback? onReady;

  const StatefulPetWidget({
    super.key,
    this.width = 160,
    this.height = 160,
    this.autoPlay = false,
    this.initialState = PetState.idle,
    this.onReady,
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

    // Fire onReady sau frame đầu tiên — đảm bảo FSM đã sẵn sàng nhận lệnh
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onReady?.call();
    });
  }

  @override
  void dispose() {
    _fsm.removeListener(_rebuild);
    _fsm.dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  void startAuto() => _fsm.startAutoBehavior();
  void stopAuto() => _fsm.stopAutoBehavior();
  void transitionTo(PetState state) => _fsm.transitionTo(state);
  void makeSad() => _fsm.makeSad();
  void makeHappy() => _fsm.makeHappy();
  void makeSleep() => _fsm.makeSleep();
  void makeIdle() => _fsm.makeIdle();
  void makeLookOutside() => _fsm.makeLookOutside();
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
  static const zone1 = PetZone(name: 'near_window',   x: 0.75, y: 0.25, scale: 0.75);
  static const zone2 = PetZone(name: 'near_cottage',  x: 0.60, y: 0.17, scale: 0.90);
  static const zone3 = PetZone(name: 'carpet_left',   x: 0.15, y: 0.15, scale: 1.00);
  static const zone4 = PetZone(name: 'carpet_center', x: 0.55, y: 0.15, scale: 1.00);
  static const zone5 = PetZone(name: 'carpet_right',  x: 0.85, y: 0.15, scale: 1.00);

  static const List<PetZone> all = [zone1, zone2, zone3, zone4, zone5];

  static PetZone randomZone() => all[math.Random().nextInt(all.length)];
}