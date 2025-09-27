import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentStatusWidget extends StatelessWidget {
  final String status;
  final String message;
  final String? bookingReference;
  final VoidCallback? onRetry;
  final VoidCallback? onViewBooking;

  const PaymentStatusWidget({
    super.key,
    required this.status,
    required this.message,
    this.bookingReference,
    this.onRetry,
    this.onViewBooking,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStatusIcon(),
          SizedBox(height: 4.h),
          Text(
            _getStatusTitle(),
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: _getStatusColor(),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            message,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (bookingReference != null) ...[
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Kode Booking',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    bookingReference!,
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.colorScheme.primary,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 4.h),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    String iconName;
    Color iconColor;
    Color backgroundColor;

    switch (status) {
      case 'success':
        iconName = 'check_circle';
        iconColor = AppTheme.getSuccessColor(true);
        backgroundColor = AppTheme.getSuccessColor(true).withValues(alpha: 0.1);
        break;
      case 'failed':
        iconName = 'error';
        iconColor = AppTheme.lightTheme.colorScheme.error;
        backgroundColor = AppTheme.lightTheme.colorScheme.error.withValues(
          alpha: 0.1,
        );
        break;
      case 'processing':
        iconName = 'hourglass_empty';
        iconColor = AppTheme.getWarningColor(true);
        backgroundColor = AppTheme.getWarningColor(true).withValues(alpha: 0.1);
        break;
      default:
        iconName = 'info';
        iconColor = AppTheme.lightTheme.colorScheme.primary;
        backgroundColor = AppTheme.lightTheme.colorScheme.primary.withValues(
          alpha: 0.1,
        );
    }

    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Center(
        child: CustomIconWidget(
          iconName: iconName,
          color: iconColor,
          size: 10.w,
        ),
      ),
    );
  }

  String _getStatusTitle() {
    switch (status) {
      case 'success':
        return 'Pembayaran Berhasil!';
      case 'failed':
        return 'Pembayaran Gagal';
      case 'processing':
        return 'Memproses Pembayaran';
      default:
        return 'Status Pembayaran';
    }
  }

  Color _getStatusColor() {
    switch (status) {
      case 'success':
        return AppTheme.getSuccessColor(true);
      case 'failed':
        return AppTheme.lightTheme.colorScheme.error;
      case 'processing':
        return AppTheme.getWarningColor(true);
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    if (status == 'success') {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onViewBooking,
              child: const Text('Lihat Detail Booking'),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed:
                  () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home-screen',
                    (route) => false,
                  ),
              child: const Text('Kembali ke Beranda'),
            ),
          ),
        ],
      );
    } else if (status == 'failed') {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onRetry,
              child: const Text('Coba Lagi'),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            ),
          ),
        ],
      );
    } else if (status == 'processing') {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
