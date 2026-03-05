import 'package:flutter/material.dart';

enum BackgroundTime { earlyMorning, morning, afternoon, night }

class ImageBackgroundWidget extends StatefulWidget {
  final BackgroundTime timeOfDay;
  
  const ImageBackgroundWidget({super.key, required this.timeOfDay});

  @override
  State<ImageBackgroundWidget> createState() => _ImageBackgroundWidgetState();
}

class _ImageBackgroundWidgetState extends State<ImageBackgroundWidget> {
  // Debug tap feature temporarily disabled
  // Uncomment these to re-enable tap debug
  /*
  Offset? _tapPosition;
  Offset? _normalizedPosition;

  void _onTapDown(TapDownDetails details, Size screenSize) {
    final position = details.localPosition;
    final normalized = Offset(
      position.dx / screenSize.width,
      position.dy / screenSize.height,
    );

    setState(() {
      _tapPosition = position;
      _normalizedPosition = normalized;
    });

    // Auto-hide after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _tapPosition = null;
          _normalizedPosition = null;
        });
      }
    });
  }
  */

  static const Map<BackgroundTime, String> _backgroundAssets = {
    BackgroundTime.earlyMorning: 'assets/images/home/background/peter_house_early_morning.png',
    BackgroundTime.morning: 'assets/images/home/background/peter_house_morning.png',
    BackgroundTime.afternoon: 'assets/images/home/background/peter_house_afternoon.png',
    BackgroundTime.night: 'assets/images/home/background/peter_house_night.png',
  };

  @override
  Widget build(BuildContext context) {
    final backgroundAsset = _backgroundAssets[widget.timeOfDay]!;

    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            child: Image.asset(
              backgroundAsset,
              key: ValueKey(backgroundAsset),
              fit: BoxFit.fill,
              width: double.infinity,
            ),
          ),
        ),

        // Debug coordinate display - TEMPORARILY DISABLED
        // Uncomment GestureDetector wrapper and these widgets to enable tap debug
        /*
        if (_tapPosition != null && _normalizedPosition != null)
          Positioned(
            left: _tapPosition!.dx - 80,
            top: _tapPosition!.dy - 60,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.yellowAccent, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Normalized:',
                    style: TextStyle(
                      color: Colors.yellowAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'X: ${_normalizedPosition!.dx.toStringAsFixed(3)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Text(
                    'Y: ${_normalizedPosition!.dy.toStringAsFixed(3)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Tap indicator dot
        if (_tapPosition != null)
          Positioned(
            left: _tapPosition!.dx - 6,
            top: _tapPosition!.dy - 6,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        */
      ],
    );
    
    // To re-enable tap debug, wrap the Stack above with:
    // return GestureDetector(
    //   onTapDown: (details) => _onTapDown(details, screenSize),
    //   child: Stack(...),
    // );
  }
}