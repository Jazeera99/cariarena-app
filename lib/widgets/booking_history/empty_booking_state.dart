import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyBookingState extends StatelessWidget {
  final String filterType;
  final VoidCallback? onSearchCourts;

  const EmptyBookingState({
    super.key,
    required this.filterType,
    this.onSearchCourts,
  });

  String _getEmptyMessage() {
    switch (filterType.toLowerCase()) {
      case 'mendatang':
        return 'Belum ada booking mendatang';
      case 'selesai':
        return 'Belum ada booking yang selesai';
      case 'dibatalkan':
        return 'Tidak ada booking yang dibatalkan';
      default:
        return 'Belum ada riwayat booking';
    }
  }

  String _getEmptyDescription() {
    switch (filterType.toLowerCase()) {
      case 'mendatang':
        return 'Booking lapangan badminton favoritmu sekarang dan nikmati permainan yang seru!';
      case 'selesai':
        return 'Setelah bermain, booking yang selesai akan muncul di sini';
      case 'dibatalkan':
        return 'Booking yang dibatalkan akan ditampilkan di sini';
      default:
        return 'Mulai booking lapangan badminton favoritmu dan nikmati permainan yang seru!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageWidget(
              imageUrl:
                  'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
              width: 60.w,
              height: 40.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 4.h),
            Text(
              _getEmptyMessage(),
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              _getEmptyDescription(),
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (filterType.toLowerCase() != 'dibatalkan') ...[
              SizedBox(height: 4.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onSearchCourts,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Text(
                    'Cari Lapangan',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
