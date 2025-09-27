import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BookingStatusBadge extends StatelessWidget {
  final String status;
  final double? fontSize;

  const BookingStatusBadge({super.key, required this.status, this.fontSize});

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'dikonfirmasi':
      case 'selesai':
      case 'completed':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'pending':
      case 'menunggu':
      case 'pending payment':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'cancelled':
      case 'dibatalkan':
      case 'canceled':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  String _getStatusText() {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'Dikonfirmasi';
      case 'pending':
        return 'Menunggu';
      case 'pending payment':
        return 'Menunggu Pembayaran';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
      case 'canceled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        _getStatusText(),
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.w600,
          fontSize: fontSize ?? 11.sp,
        ),
      ),
    );
  }
}
