import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';

/// Registration form widget with all required input fields and validation
class RegisterFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool isLoading;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final VoidCallback onRegister;

  const RegisterFormWidget({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.isLoading,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.onRegister,
  });

  /// Calculate password strength score
  int _getPasswordStrength(String password) {
    int score = 0;

    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    return score;
  }

  /// Get password strength color
  Color _getPasswordStrengthColor(int strength, BuildContext context) {
    switch (strength) {
      case 0:
      case 1:
        return Theme.of(context).colorScheme.error;
      case 2:
      case 3:
        return AppTheme.getWarningColor(
          Theme.of(context).brightness == Brightness.light,
        );
      case 4:
      case 5:
        return AppTheme.getSuccessColor(
          Theme.of(context).brightness == Brightness.light,
        );
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }

  /// Get password strength label
  String _getPasswordStrengthLabel(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return "Lemah";
      case 2:
      case 3:
        return "Sedang";
      case 4:
      case 5:
        return "Kuat";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Full name input
          TextFormField(
            controller: fullNameController,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: "Nama Lengkap",
              hintText: "Masukkan nama lengkap Anda",
              prefixIcon: Icon(
                Icons.person_outline,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Nama lengkap harus diisi";
              }
              if (value.trim().length < 2) {
                return "Nama lengkap minimal 2 karakter";
              }
              return null;
            },
          ),

          SizedBox(height: 2.h),

          // Email input
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Masukkan alamat email Anda",
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email harus diisi";
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return "Format email tidak valid";
              }
              return null;
            },
          ),

          SizedBox(height: 2.h),

          // Phone number input with Indonesian format
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(15),
            ],
            decoration: InputDecoration(
              labelText: "Nomor Telepon",
              hintText: "08xxxxxxxxxx",
              prefixIcon: Icon(
                Icons.phone_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              prefixText: "+62 ",
              prefixStyle: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Nomor telepon harus diisi";
              }
              if (value.length < 8 || value.length > 13) {
                return "Nomor telepon tidak valid";
              }
              if (!value.startsWith('8')) {
                return "Nomor harus diawali dengan 8";
              }
              return null;
            },
            onChanged: (value) {
              // Auto format phone number
              if (value.isNotEmpty && !value.startsWith('8')) {
                phoneController.text = '8$value';
                phoneController.selection = TextSelection.fromPosition(
                  TextPosition(offset: phoneController.text.length),
                );
              }
            },
          ),

          SizedBox(height: 2.h),

          // Password input with strength indicator
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Kata Sandi",
                  hintText: "Buat kata sandi yang kuat",
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onPressed: onTogglePasswordVisibility,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Kata sandi harus diisi";
                  }
                  if (value.length < 8) {
                    return "Kata sandi minimal 8 karakter";
                  }
                  return null;
                },
                onChanged: (value) {
                  // Trigger rebuild to update strength indicator
                  (context as Element).markNeedsBuild();
                },
              ),

              SizedBox(height: 1.h),

              // Password strength indicator
              if (passwordController.text.isNotEmpty) ...[
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value:
                            _getPasswordStrength(passwordController.text) / 5.0,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.outline.withAlpha(51),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getPasswordStrengthColor(
                            _getPasswordStrength(passwordController.text),
                            context,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _getPasswordStrengthLabel(
                        _getPasswordStrength(passwordController.text),
                      ),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _getPasswordStrengthColor(
                          _getPasswordStrength(passwordController.text),
                          context,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),

          SizedBox(height: 2.h),

          // Confirm password input
          TextFormField(
            controller: confirmPasswordController,
            obscureText: obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: "Konfirmasi Kata Sandi",
              hintText: "Masukkan ulang kata sandi Anda",
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onPressed: onToggleConfirmPasswordVisibility,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Konfirmasi kata sandi harus diisi";
              }
              if (value != passwordController.text) {
                return "Kata sandi tidak cocok";
              }
              return null;
            },
            onFieldSubmitted: (_) => onRegister(),
          ),

          SizedBox(height: 4.h),

          // Register button
          SizedBox(
            width: double.infinity,
            height: 7.h,
            child: ElevatedButton(
              onPressed: isLoading ? null : onRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: Theme.of(context).colorScheme.shadow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 1.h),
              ),
              child:
                  isLoading
                      ? SizedBox(
                        height: 3.h,
                        width: 3.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      )
                      : Text(
                        "Buat Akun",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
