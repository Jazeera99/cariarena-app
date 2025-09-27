import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

/// Widget for terms and conditions acceptance with linked policy text
class TermsAcceptanceWidget extends StatelessWidget {
  final bool isAccepted;
  final ValueChanged<bool> onChanged;

  const TermsAcceptanceWidget({
    super.key,
    required this.isAccepted,
    required this.onChanged,
  });

  /// Show terms and conditions dialog
  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              "Syarat dan Ketentuan",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTermsSection(
                    context,
                    "1. Penggunaan Aplikasi",
                    "Aplikasi CourtBooker digunakan untuk booking lapangan olahraga. Pengguna bertanggung jawab atas keakuratan informasi yang diberikan.",
                  ),
                  _buildTermsSection(
                    context,
                    "2. Akun Pengguna",
                    "Setiap pengguna harus membuat akun dengan informasi yang valid. Pengguna bertanggung jawab menjaga kerahasiaan akun.",
                  ),
                  _buildTermsSection(
                    context,
                    "3. Pembayaran",
                    "Pembayaran harus dilakukan sesuai dengan ketentuan yang berlaku. Pembatalan booking mengikuti kebijakan yang ditetapkan.",
                  ),
                  _buildTermsSection(
                    context,
                    "4. Privasi",
                    "Data pribadi pengguna akan dijaga sesuai kebijakan privasi aplikasi dan tidak akan disebarluaskan tanpa izin.",
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Tutup",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
    );
  }

  /// Show privacy policy dialog
  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              "Kebijakan Privasi",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTermsSection(
                    context,
                    "Pengumpulan Data",
                    "Kami mengumpulkan data yang diperlukan untuk memberikan layanan booking lapangan yang optimal.",
                  ),
                  _buildTermsSection(
                    context,
                    "Penggunaan Data",
                    "Data yang dikumpulkan digunakan untuk pemrosesan booking, komunikasi, dan peningkatan layanan.",
                  ),
                  _buildTermsSection(
                    context,
                    "Keamanan Data",
                    "Kami menerapkan langkah-langkah keamanan yang tepat untuk melindungi data pribadi Anda.",
                  ),
                  _buildTermsSection(
                    context,
                    "Hak Pengguna",
                    "Anda memiliki hak untuk mengakses, memperbarui, atau menghapus data pribadi Anda kapan saja.",
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Tutup",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
    );
  }

  /// Build terms section widget
  Widget _buildTermsSection(
    BuildContext context,
    String title,
    String content,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Checkbox
        SizedBox(
          width: 6.w,
          height: 6.w,
          child: Checkbox(
            value: isAccepted,
            onChanged: (value) => onChanged(value ?? false),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),

        SizedBox(width: 3.w),

        // Terms text with clickable links
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              children: [
                const TextSpan(text: "Saya menyetujui "),
                TextSpan(
                  text: "Syarat dan Ketentuan",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () => _showTermsDialog(context),
                ),
                const TextSpan(text: " serta "),
                TextSpan(
                  text: "Kebijakan Privasi",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () => _showPrivacyDialog(context),
                ),
                const TextSpan(text: " yang berlaku."),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
