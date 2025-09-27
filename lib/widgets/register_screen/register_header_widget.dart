import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

/// Header widget for register screen with profile photo upload option
class RegisterHeaderWidget extends StatelessWidget {
  final String? profileImagePath;
  final VoidCallback onPhotoTap;

  const RegisterHeaderWidget({
    super.key,
    this.profileImagePath,
    required this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile photo upload
        GestureDetector(
          onTap: onPhotoTap,
          child: Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primaryContainer,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withAlpha(77),
                width: 2,
              ),
            ),
            child:
                profileImagePath != null
                    ? ClipOval(
                      child: Image.network(
                        profileImagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildDefaultAvatar(context);
                        },
                      ),
                    )
                    : _buildDefaultAvatar(context),
          ),
        ),

        SizedBox(height: 2.h),

        // Upload instruction
        Text(
          "Tambah Foto Profil",
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),

        SizedBox(height: 0.5.h),

        Text(
          "Ketuk untuk memilih foto",
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// Build default avatar with camera icon
  Widget _buildDefaultAvatar(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Icon(
            Icons.person,
            size: 16.w,
            color: Theme.of(context).colorScheme.primary.withAlpha(128),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.secondary,
              border: Border.all(
                color: Theme.of(context).scaffoldBackgroundColor,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.camera_alt,
              size: 4.w,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
