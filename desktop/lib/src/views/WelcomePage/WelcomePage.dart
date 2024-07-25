import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  Offset _mousePosition = Offset.zero;
  Offset _laggedMousePosition = Offset.zero;
  Timer? _timer;
  Timer? _fillTimer;
  bool _filling = false;
  double _fillProgress = 0.0;
  double _waveProgress = 0.0;
  double _waveProgress2 = 0.0;

  late AnimationController _dotController;
  late Animation<double> _dotAnimation;
  Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and tween for the dot animation
    _dotController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _dotAnimation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(
        parent: _dotController,
        curve: Curves.fastOutSlowIn,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _dotController.reverse();
        }
      });

    // Start the random dot animation
    _startRandomDotAnimation();

    _timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        final distance = (_mousePosition - _laggedMousePosition).distance;
        final interpolationFactor = (distance / 100).clamp(0.05, 1.0) * 0.05;
        _laggedMousePosition = Offset.lerp(
            _laggedMousePosition, _mousePosition, interpolationFactor)!;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fillTimer?.cancel();
    _dotController.dispose();
    super.dispose();
  }

  void _startFilling(Offset startPosition) {
    setState(() {
      _filling = true;
      _fillProgress = 0.0;
      _waveProgress = 0.0;
      _waveProgress2 = 0.0;
    });

    _fillTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        _fillProgress += 0.02; // Adjust this value to control the filling speed
        if (_fillProgress >= 1.0) {
          _fillProgress = 1.0;
        }

        // Start the second wave slightly after the fill starts
        if (_fillProgress >= 0.65) {
          _waveProgress += 0.02;
        }

        if (_fillProgress >= 0.75) {
          _waveProgress2 += 0.02;
        }

        if (_waveProgress >= 1.0) {
          _waveProgress = 1.0;
          _waveProgress2 = 1.0;
          _fillTimer?.cancel();
          context.go('/login');
        }
      });
    });
  }

  void _startRandomDotAnimation() {
    Timer.periodic(Duration(seconds: _random.nextInt(3) + 2), (timer) {
      _dotController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    Size screenSize = MediaQuery.of(context).size;
    Offset centerOffset = Offset(screenSize.width / 2, screenSize.height / 2);

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: MouseRegion(
          onHover: (event) {
            setState(() {
              _mousePosition = event.localPosition;
            });
          },
          onExit: (event) {
            setState(() {
              _mousePosition = centerOffset;
            });
          },
          child: CustomPaint(
            painter: BackgroundPainter(
              mousePosition: _laggedMousePosition,
              fillProgress: _filling ? _fillProgress : 0.0,
              waveProgress: _filling ? _waveProgress : 0.0,
              waveProgress2: _filling ? _waveProgress2 : 0.0,
              fillCenter: _filling
                  ? Offset(screenSize.width / 2, screenSize.height / 2 + 100)
                  : Offset.zero, // Approximate button position
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1000),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Hero(
                              tag: 'nobi',
                              child: Text(
                                'nobi',
                                style: TextStyle(
                                  fontSize: 144,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 31, 104, 117),
                                ),
                              ),
                            ),
                            AnimatedBuilder(
                              animation: _dotAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _dotAnimation.value),
                                  child: Text(
                                    '.',
                                    style: TextStyle(
                                      fontSize: 144,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 31, 104, 117),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Text(
                          'Your data anywhere you go',
                          style: TextStyle(fontSize: 76),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                    ElevatedButton(
                      onPressed: () => _startFilling(Offset(
                          screenSize.width / 2, screenSize.height / 2 + 100)),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(200, 50),
                        backgroundColor: Color.fromARGB(255, 31, 104, 117),
                        foregroundColor: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final Offset mousePosition;
  final double fillProgress;
  final double waveProgress;
  final double waveProgress2;
  final Offset fillCenter;

  BackgroundPainter({
    required this.mousePosition,
    required this.fillProgress,
    required this.waveProgress,
    required this.waveProgress2,
    required this.fillCenter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final dotSpacing = 50.0;
    final fadeRadius = 300.0;
    final maxOpacity = 0.5;
    final easeInProgress = Curves.easeIn.transform(fillProgress);
    final fillRadius = easeInProgress * size.longestSide;

    final waveEaseInProgress = Curves.easeInOut.transform(waveProgress);
    final waveRadius = waveEaseInProgress * size.longestSide;

    final waveEaseInProgress2 = Curves.easeInOut.transform(waveProgress2);
    final waveRadius2 = waveEaseInProgress2 * size.longestSide;

    final midDistance = waveRadius2 + (waveRadius - waveRadius2) / 2;

    if (waveProgress > 0) {
      print('wave progress: ' +
          waveProgress.toString() +
          ' -- wave radious: ' +
          waveRadius.toString() +
          ' -- ease in progres: ' +
          midDistance.toString());
    }

    for (double x = 0; x < size.width; x += dotSpacing) {
      for (double y = 0; y < size.height; y += dotSpacing) {
        final dotPosition = Offset(x, y);
        final distanceToMouse = (mousePosition - dotPosition).distance;
        final distanceToFillCenter = (fillCenter - dotPosition).distance;
        double opacity = 0.0;
        double dotSize = 3;

        if (fillProgress > 0) {
          opacity = maxOpacity *
              (1 - (distanceToFillCenter / fillRadius)).clamp(0.0, 1.0);
        } else {
          opacity =
              (1 - (distanceToMouse / fadeRadius)).clamp(0.0, 1.0) * maxOpacity;
        }

        if (waveProgress > 0) {
          if (distanceToFillCenter > waveRadius2 &&
              distanceToFillCenter < waveRadius) {
            if (distanceToFillCenter > waveRadius2 &&
                distanceToFillCenter < midDistance) {
              final waveEffectProgress =
                  (1 - (waveRadius2 / distanceToFillCenter)).clamp(0.0, 1.0);
              dotSize = 3.0 + 10.0 * waveEffectProgress;
            }

            if (distanceToFillCenter < waveRadius &&
                distanceToFillCenter > midDistance) {
              final waveEffectProgress =
                  (1 - (distanceToFillCenter / waveRadius)).clamp(0.0, 1.0);
              dotSize = 3.0 + 10.0 * waveEffectProgress;
            }
          }
        }

        canvas.drawCircle(
          dotPosition,
          dotSize,
          paint..color = paint.color.withOpacity(opacity),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
