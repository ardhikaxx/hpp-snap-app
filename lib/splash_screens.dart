import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hppsnap_app/page/home_screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<Offset> _slideUpAnimation;
  late Animation<Offset> _illustrationSlideUpAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.bounceOut),
      ),
    );

    _slideUpAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.1, 0.7, curve: Curves.easeOutBack),
          ),
        );

    _illustrationSlideUpAnimation =
        Tween<Offset>(
          begin: const Offset(0.0, 2.0),
          end: const Offset(0.0, 0.3),
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.1, 0.7, curve: Curves.easeOutBack),
          ),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToHome() {
    _controller.reverse().then((_) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                height: size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0F6CCB).withOpacity(_fadeAnimation.value),
                      const Color(0xFF0F84D4).withOpacity(_fadeAnimation.value),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              );
            },
          ),

          // Illustration
          Positioned(
            bottom: size.height * 0.36,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final slideValue = _illustrationSlideUpAnimation.value;
                final bounceValue = _bounceAnimation.value;

                return Transform.translate(
                  offset: Offset(slideValue.dx, slideValue.dy * 100),
                  child: Transform.scale(
                    scale: _scaleAnimation.value * (1 + bounceValue * 0.05),
                    child: Opacity(opacity: _fadeAnimation.value, child: child),
                  ),
                );
              },
              child: Image.asset(
                'assets/ilustrasi/ilustrations.png',
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            top: size.height * 0.12,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final bounceValue = _bounceAnimation.value;
                final scaleValue = _scaleAnimation.value;
                final slideValue = _slideUpAnimation.value;

                return Transform.translate(
                  offset: Offset(slideValue.dx * 100, slideValue.dy * 100),
                  child: Transform.scale(
                    scale: scaleValue * (1 + bounceValue * 0.1),
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: child,
                    ),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.asset(
                        'assets/icons/icon.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.white,
                            child: const Icon(
                              Icons.image,
                              color: Color(0xFF0F6CCB),
                              size: 50,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  _BounceText(
                    text: 'HPP Snap App',
                    animation: _controller,
                    delay: 0.3,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontFamily: 'SuperTrend',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  _BounceText(
                    text: 'Hitung Harga Pokok Penjualan\nProdukmu Sekarang!',
                    animation: _controller,
                    delay: 0.5,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: InnerCurveClipper(),
              child: Container(
                height: size.height * 0.48,
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(top: 140, left: 20, right: 20),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          final bounceValue = _bounceAnimation.value;

                          return Transform.translate(
                            offset: Offset(0, (1 - bounceValue) * 10),
                            child: Opacity(
                              opacity: _controller.value > 0.5
                                  ? _fadeAnimation.value
                                  : 0.0,
                              child: child,
                            ),
                          );
                        },
                        child: const Text(
                          "Fitur Utama",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F6CCB),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _BounceFeatureCard(
                            icon: FontAwesomeIcons.dollarSign,
                            label: "Hitung\nHPP",
                            animation: _controller,
                            delay: 0.5,
                          ),
                          _BounceFeatureCard(
                            icon: FontAwesomeIcons.cubes,
                            label: "Bahan\nBaku",
                            animation: _controller,
                            delay: 0.6,
                          ),
                          _BounceFeatureCard(
                            icon: FontAwesomeIcons.peopleGroup,
                            label: "Tenaga\nKerja",
                            animation: _controller,
                            delay: 0.7,
                          ),
                          _BounceFeatureCard(
                            icon: FontAwesomeIcons.sackDollar,
                            label: "Biaya\nTetap",
                            animation: _controller,
                            delay: 0.8,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _AnimatedButton(
                        animation: _controller,
                        onPressed: _goToHome,
                        child: const Text(
                          "Mulai Hitung HPP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BounceText extends StatelessWidget {
  final String text;
  final Animation<double> animation;
  final TextStyle style;
  final double delay;

  const _BounceText({
    required this.text,
    required this.animation,
    required this.style,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final end = (delay + 0.4).clamp(0.0, 1.0);
        final value = CurvedAnimation(
          parent: animation,
          curve: Interval(delay, end, curve: Curves.bounceOut),
        ).value;

        final opacity = value.clamp(0.0, 1.0);
        final scale = 0.7 + value * 0.3;
        final offset = (1 - value) * 30;

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, offset),
            child: Transform.scale(
              scale: scale,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: style,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BounceFeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Animation<double> animation;
  final double delay;

  const _BounceFeatureCard({
    required this.icon,
    required this.label,
    required this.animation,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final end = (delay + 0.3).clamp(0.0, 1.0);
        final value = CurvedAnimation(
          parent: animation,
          curve: Interval(delay, end, curve: Curves.bounceOut),
        ).value;

        final opacity = value.clamp(0.0, 1.0);
        final scale = 0.5 + value * 0.5;
        final offset = (1 - value) * 50;

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, offset),
            child: Transform.scale(scale: scale, child: child),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F2FF),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F6CCB).withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(icon, color: const Color(0xFF0F6CCB), size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedButton extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback onPressed;
  final Widget child;

  const _AnimatedButton({
    required this.animation,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final value = CurvedAnimation(
          parent: animation,
          curve: const Interval(0.7, 1.0, curve: Curves.elasticOut),
        ).value;

        final opacity = value.clamp(0.0, 1.0);
        final scale = 0.8 + value * 0.2;

        return Opacity(
          opacity: opacity,
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F6CCB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 8,
            shadowColor: const Color(0xFF0F6CCB).withOpacity(0.5),
          ),
          child: child,
        ),
      ),
    );
  }
}

class InnerCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 60);

    path.quadraticBezierTo(size.width / 2, 180, size.width, 60);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
