import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

// ─────────────────────────────────────────────
// ENUM & CONFIG
// ─────────────────────────────────────────────

enum PetAnimationState {
  happy,
  happyToWalkHorizontally,
  happyVsSmiling,
  idle,
  idleToSleep,
  lookingOutside,
  lookingToWalkFront,
  lookFrontToBack,
  lookBackToFront,
  sleep,
  walkingAway,
  walkingFront,
  walkingHorizontally,
  sad,
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

// ─────────────────────────────────────────────
// PET ZONE SYSTEM
// ─────────────────────────────────────────────

/// Định nghĩa 1 vùng mà pet có thể di chuyển hoặc đứng
class PetZone {
  final String name;
  final double xMin;       // tọa độ x nhỏ nhất (normalized 0-1)
  final double xMax;       // tọa độ x lớn nhất (normalized 0-1)
  final double y;          // vị trí đứng (anchor bottom của pet, normalized 0-1)
  final double scale;      // tỷ lệ size pet (1.0 = 100%)

  const PetZone({
    required this.name,
    required this.xMin,
    required this.xMax,
    required this.y,
    this.scale = 1.0,
  });

  /// Random vị trí x trong zone
  double randomX() {
    final range = xMax - xMin;
    final random = math.Random();
    return xMin + range * random.nextDouble();
  }

  /// Lấy vị trí giữa zone
  double get centerX => (xMin + xMax) / 2;

  /// Kiểm tra vị trí x có nằm trong zone không
  bool contains(double x) => x >= xMin && x <= xMax;
}

/// Các vùng cố định trên home screen
class HomeZones {
  // Zone 1 — Gần cottage, nhỏ nhất, xa nhất (pet nhỏ hơn)
  static const zone1 = PetZone(
    name: 'near_cottage',
    xMin: 0.695,
    xMax: 0.87,
    y: 0.735,
    scale: 0.75, // Pet nhỏ hơn 25% vì ở xa
  );

  // Zone 2 — Giữa thảm, trung bình
  static const zone2 = PetZone(
    name: 'carpet_mid',
    xMin: 0.54,
    xMax: 0.87,
    y: 0.79,
    scale: 0.9, // Pet size trung bình
  );

  // Zone 3 — Toàn bộ thảm, rộng nhất, gần nhất (pet lớn nhất)
  static const zone3 = PetZone(
    name: 'carpet_full',
    xMin: 0.14,
    xMax: 0.87,
    y: 0.820,
    scale: 1.0, // Pet size đầy đủ vì ở gần
  );

  /// Danh sách tất cả các zone, sắp xếp từ gần đến xa
  static const List<PetZone> all = [zone3, zone2, zone1];

  /// Lấy zone ngẫu nhiên
  static PetZone randomZone() {
    final random = math.Random();
    return all[random.nextInt(all.length)];
  }

  /// Tìm zone phù hợp nhất với vị trí x cho trước
  static PetZone? findZoneForX(double x) {
    for (final zone in all) {
      if (zone.contains(x)) return zone;
    }
    return null;
  }
}

// ─────────────────────────────────────────────
// WIDGET CHÍNH
// ─────────────────────────────────────────────

/// Hiển thị pet animation từ sprite sheet PNG.
///
/// Cách dùng:
/// ```dart
/// PetAnimationWidget(
///   state: PetAnimationState.happy,
///   width: 180,
///   height: 180,
/// )
/// ```
class PetAnimationWidget extends StatefulWidget {
  final PetAnimationState state;
  final double width;
  final double height;

  const PetAnimationWidget({
    super.key,
    required this.state,
    this.width = 160,
    this.height = 160,
  });

  @override
  State<PetAnimationWidget> createState() => _PetAnimationWidgetState();
}

class _PetAnimationWidgetState extends State<PetAnimationWidget>
    with TickerProviderStateMixin {
  // ── Cấu hình sprite (đo thực tế từ ảnh 769x2000, grid 5x13, 61 frames) ──
  static const Map<PetAnimationState, _SpriteConfig> _configs = {
    PetAnimationState.happy: _SpriteConfig(
      assetPath: 'assets/images/home/sprite_pets/lumni_happy.png',
      columns: 5,
      rows: 13,
      frameCount: 61,
      fps: 14,
    ),
    PetAnimationState.happyToWalkHorizontally: _SpriteConfig(
      assetPath: 'assets/images/home/sprite_pets/lumni_happy_to_walk_horizontally.png',
      columns: 5,
      rows: 13,
      frameCount: 61,
      fps: 14,
    ),
    PetAnimationState.happyVsSmiling: _SpriteConfig(
      assetPath: 'assets/images/home/sprite_pets/lumni_happy_vs_smiling.png',
      columns: 5,
      rows: 13,
      frameCount: 61,
      fps: 14,
    ),
    PetAnimationState.idle: _SpriteConfig(
      assetPath: 'assets/images/home/sprite_pets/lumni_idle.png',
      columns: 5,
      rows: 13,
      frameCount: 61,
      fps: 14,
    ),
    PetAnimationState.idleToSleep: _SpriteConfig(
      assetPath: 'assets/images/home/sprite_pets/lumni_idle_to_sleep.png',
      columns: 5,
      rows: 13,
      frameCount: 61,
      fps: 14,
    ),
    PetAnimationState.lookingOutside: _SpriteConfig(
      assetPath: 'assets/images/home/sprite_pets/lumni_looking_outside.png',
      columns: 5,
      rows: 13,
      frameCount: 61,
      fps: 14,
    ),
    PetAnimationState.lookingToWalkFront: _SpriteConfig(
      assetPath: 'assets/images/home/sprite_pets/lumni_looking_to_walk_front.png',
      columns: 5,
      rows: 13,
      frameCount: 61,
      fps: 14,
    ),
    PetAnimationState.lookFrontToBack: _SpriteConfig(
      assetPath: 'assets/images/home/sprite_pets/lumni_look_front_to_back.png',
      columns: 5,
      rows: 13,
      frameCount: 61,
      fps: 14,
    ),
    PetAnimationState.sleep: _SpriteConfig(
      assetPath: 'assets/images/home/sprite_pets/lumni_sleep.png',
      columns: 5,
      rows: 13,
      frameCount: 61,
      fps: 14,
    ),
    PetAnimationState.walkingAway: _SpriteConfig(
      assetPath: 'assets/images/home/sprite_pets/lumni_walking_away.png',
      columns: 5,
      rows: 13,
      frameCount: 61,
      fps: 14,
    ),
    PetAnimationState.walkingFront: _SpriteConfig(
      assetPath: 'assets/images/home/sprite_pets/lumni_walking_front.png',
      columns: 5,
      rows: 13,
      frameCount: 61,
      fps: 14,
    ),
    PetAnimationState.walkingHorizontally: _SpriteConfig(
      assetPath: 'assets/images/home/sprite_pets/lumni_walking_horizontally.png',
      columns: 5,
      rows: 13,
      frameCount: 61,
      fps: 14,
    ),
    PetAnimationState.sad: _SpriteConfig(
      assetPath: 'assets/images/home/sprite_pets/lumn_sad.png',
      columns: 5,
      rows: 13,
      frameCount: 61,
      fps: 14,
    ),
  };

  // Cache dùng chung toàn app — load 1 lần duy nhất
  static final Map<String, ui.Image> _cache = {};

  AnimationController? _controller;
  ui.Image? _sheet;
  bool _loading = true;

  // ── Lifecycle ──

  @override
  void initState() {
    super.initState();
    _load(widget.state);
  }

  @override
  void didUpdateWidget(PetAnimationWidget old) {
    super.didUpdateWidget(old);
    if (old.state != widget.state) {
      _disposeController();
      _load(widget.state);
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

  Future<void> _load(PetAnimationState state) async {
    if (!mounted) return;
    setState(() => _loading = true);

    final config = _configs[state]!;

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
      )..repeat();

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

    final config = _configs[widget.state]!;

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