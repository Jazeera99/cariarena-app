import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BookingDetailsCard extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const BookingDetailsCard({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    final bookingDate =
        bookingData["date"] as String? ?? 'Tanggal tidak tersedia';

    // 2. Amankan Waktu (Time Slots)
    final timeSlots = bookingData["time_slots"] as List? ?? [];
    final timeSlotString =
        timeSlots.cast<String>().isNotEmpty
            ? timeSlots.cast<String>().join(" - ") // Gabungkan slot waktu
            : 'Slot waktu tidak tersedia';

    // 3. Hitung Durasi (Asumsi Durasi 1 jam per slot)
    // Sesuaikan logika ini jika durasi booking Anda berbeda
    final duration =
        timeSlots.length > 0
            ? "${timeSlots.length} jam"
            : 'Durasi tidak diketahui';

    // 4. Data Lapangan
    // Jika Anda tidak memiliki data lapangan di bookingData, gunakan fallback
    final fieldData = bookingData["field"] as Map<String, dynamic>?;

    final courtName =
        fieldData != null
            ? fieldData["name"] as String? ?? 'Lapangan tidak diketahui'
            : 'Lapangan tidak diketahui';
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Detail Pemesanan",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 3.h),
            _buildDetailRow("Tanggal", bookingDate),
            SizedBox(height: 2.h),
            _buildDetailRow("Waktu", timeSlotString),
            SizedBox(height: 2.h),
            _buildDetailRow("Durasi", duration),
            SizedBox(height: 2.h),
            _buildDetailRow("Lapangan", courtName),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
