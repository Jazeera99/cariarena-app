import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BookingActionButtons extends StatelessWidget {
  final String status;
  final VoidCallback? onCheckIn;
  final VoidCallback? onCancel;
  final VoidCallback? onReview;
  final VoidCallback? onBookAgain;

  const BookingActionButtons({
    super.key,
    required this.status,
    this.onCheckIn,
    this.onCancel,
    this.onReview,
    this.onBookAgain,
  });

  @override
  Widget build(BuildContext context) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'dikonfirmasi':
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.lightTheme.colorScheme.error,
                  side: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
                child: Text(
                  'Batalkan',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: ElevatedButton(
                onPressed: onCheckIn,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
                child: Text(
                  'Check-in',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ),
          ],
        );

      case 'completed':
      case 'selesai':
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onBookAgain,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
                child: Text(
                  'Pesan Lagi',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: ElevatedButton(
                onPressed: onReview,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
                child: Text(
                  'Beri Review',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ),
          ],
        );

      case 'pending':
      case 'menunggu':
      case 'pending payment':
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.error,
              side: BorderSide(color: AppTheme.lightTheme.colorScheme.error),
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
            ),
            child: Text(
              'Batalkan Pesanan',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                fontSize: 13.sp,
              ),
            ),
          ),
        );

      default:
        return SizedBox.shrink();
    }
  }
}
