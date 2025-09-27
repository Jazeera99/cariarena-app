import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../widgets/login_screen/login_form_widget.dart';
import '../../widgets/login_screen/login_header_widget.dart';
import '../../widgets/login_screen/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handle login form submission with validation and authentication
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Akses AuthProvider menggunakan Provider.of.
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      // Panggil metode login dari AuthProvider.
      // Metode ini akan menangani panggilan API dan penyimpanan token.
      await authProvider.login(_emailController.text, _passwordController.text);

      // Jika login berhasil (metode login tidak melempar error),
      // navigasi kembali ke halaman sebelumnya dan kirimkan nilai 'true'.
      // Ini akan memberitahu halaman VenueDetailScreen bahwa login berhasil.
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Tangani error jika login gagal.
      // Tampilkan pesan error yang sesuai.
      _showErrorSnackBar(
        "Login gagal. Periksa kembali email dan kata sandi Anda.",
      );
      // Optional: Log error detail untuk debugging.
      print("Login error: $e");
    } finally {
      // Pastikan _isLoading diubah kembali menjadi false, terlepas dari hasilnya.
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Show error message in SnackBar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Navigate to register screen
  void _navigateToRegister() {
    Navigator.pushNamed(context, AppRoutes.registerScreen);
  }

  /// Navigate to forgot password (placeholder for now)
  void _navigateToForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Fitur lupa password akan segera tersedia"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Handle social login (placeholder for now)
  void _handleSocialLogin(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Login dengan $provider akan segera tersedia"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.06,
          ),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),

              // App logo and branding
              LoginHeaderWidget(),

              SizedBox(height: MediaQuery.of(context).size.height * 0.06),

              // Login form
              LoginFormWidget(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                obscurePassword: _obscurePassword,
                isLoading: _isLoading,
                onTogglePasswordVisibility: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
                onLogin: _handleLogin,
                onForgotPassword: _navigateToForgotPassword,
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.04),

              // Social login options
              SocialLoginWidget(onSocialLogin: _handleSocialLogin),

              SizedBox(height: MediaQuery.of(context).size.height * 0.04),

              // Registration prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Belum punya akun? ",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  GestureDetector(
                    onTap: _navigateToRegister,
                    child: Text(
                      "Daftar",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
