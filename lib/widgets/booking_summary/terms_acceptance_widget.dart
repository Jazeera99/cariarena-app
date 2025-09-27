import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TermsAcceptanceWidget extends StatelessWidget {
  final bool isAccepted;
  final Function(bool?) onChanged;
  final VoidCallback onTermsTap;

  const TermsAcceptanceWidget({
    super.key,
    required this.isAccepted,
    required this.onChanged,
    required this.onTermsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: isAccepted,
            onChanged: onChanged,
            activeColor: AppTheme.lightTheme.colorScheme.primary,
            checkColor: AppTheme.lightTheme.colorScheme.onPrimary,
            side: BorderSide(color: AppTheme.lightTheme.dividerColor, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(!isAccepted),
              child: RichText(
                text: TextSpan(
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(text: "Saya menyetujui "),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: onTermsTap,
                        child: Text(
                          "Syarat dan Ketentuan",
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    AppTheme.lightTheme.colorScheme.primary,
                              ),
                        ),
                      ),
                    ),
                    const TextSpan(text: " serta "),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: onTermsTap,
                        child: Text(
                          "Kebijakan Privasi",
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    AppTheme.lightTheme.colorScheme.primary,
                              ),
                        ),
                      ),
                    ),
                    const TextSpan(text: " yang berlaku."),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
