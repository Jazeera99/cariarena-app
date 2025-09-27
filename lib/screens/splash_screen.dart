import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();

    // Call checkAuthentication to restore login state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).checkAuthentication();
    });

    // Navigate to next screen after animation and auth check
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    // Wait animation duration
    await Future.delayed(const Duration(milliseconds: 5000));

    Navigator.of(context).pushReplacementNamed(AppRoutes.homeScreen);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A4DA2), // Warna biru modern
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A4DA2), Color(0xFF1A6FD6)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo dengan animasi
              ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomPaint(
                        size: const Size(80, 80),
                        painter: LogoPainter(),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Teks dengan animasi slide
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      const Text(
                        'CariArena',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Reservasi Lapangan Lebih Mudah',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Loading indicator
              FadeTransition(
                opacity: _fadeAnimation,
                child: const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = const Color.fromARGB(255, 62, 238, 42)
          ..style = PaintingStyle.fill;

    // Gambar lapangan (persegi panjang dengan garis tengah)
    final Rect fieldRect = Rect.fromLTRB(
      size.width * 0.2,
      size.height * 0.2,
      size.width * 0.8,
      size.height * 0.8,
    );

    // Gambar lapangan
    canvas.drawRect(
      fieldRect,
      paint..color = const Color.fromARGB(255, 62, 238, 42).withOpacity(0.2),
    );

    // Gambar garis tepi lapangan
    canvas.drawRect(
      fieldRect,
      Paint()
        ..color = const Color.fromARGB(255, 62, 238, 42)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Gambar garis tengah
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.5, size.height * 0.8),
      Paint()
        ..color = const Color.fromARGB(255, 62, 238, 42)
        ..strokeWidth = 1.5,
    );

    // Gambar lingkaran tengah
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.1,
      Paint()
        ..color = const Color.fromARGB(255, 62, 238, 42)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Gambar pemain (lingkaran kecil)
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.4),
      size.width * 0.05,
      paint..color = const Color.fromARGB(255, 62, 238, 42),
    );

    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.6),
      size.width * 0.05,
      paint..color = const Color.fromARGB(255, 62, 238, 42),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
