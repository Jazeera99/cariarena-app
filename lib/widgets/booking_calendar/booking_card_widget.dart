import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/app_export.dart';

class BookingCard extends StatelessWidget {
  final DateTime selectedDate;
  final List<String> selectedTimeSlots;
  final Map<String, dynamic>? fieldData;
  final double totalPrice;
  final int totalDuration;
  final VoidCallback? onProceedToPayment;
  final bool isLoading;
  final Map<String, Map<String, dynamic>> timeSlots;

  const BookingCard({
    super.key,
    required this.selectedDate,
    required this.selectedTimeSlots,
    required this.fieldData,
    required this.totalPrice,
    required this.totalDuration,
    required this.onProceedToPayment,
    required this.timeSlots,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValidSelection = selectedTimeSlots.isNotEmpty;
    final timeSlotsText =
        selectedTimeSlots.isNotEmpty
            ? '${selectedTimeSlots.first} - ${selectedTimeSlots.last}'
            : 'Pilih waktu';

    final isSingleSlot = selectedTimeSlots.length == 1;
    final displayTimeSlot =
        isSingleSlot
            ? '${selectedTimeSlots.first} - ${DateFormat('HH:mm').format(DateTime.parse('2025-01-01 ${selectedTimeSlots.first}:00').add(const Duration(hours: 1)))}'
            : selectedTimeSlots.isNotEmpty
            ? '${selectedTimeSlots.first} - ${DateFormat('HH:mm').format(DateTime.parse('2025-01-01 ${selectedTimeSlots.last}:00').add(const Duration(hours: 1)))}'
            : 'Pilih waktu';

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              if (hasValidSelection) ...[
                Text(
                  'RINGKASAN BOOKING',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    fieldData?['image_url'] ??
                        'https://placehold.co/600x400/CCCCCC/666666?text=Image+Not+Found',
                    fit: BoxFit.cover,
                    height: 20.h,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 20.h,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/sad_face.svg',
                            width: 50.w,
                            color: Colors.grey[600],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  fieldData?['name'] ?? 'Nama Lapangan Tidak Tersedia',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 4.w,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: 1.w),
                    Expanded(
                      child: Text(
                        fieldData?['full_address'] ?? 'Lokasi Tidak Diketahui',
                        style: theme.textTheme.bodyLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.star, size: 4.w, color: Colors.amber),
                    SizedBox(width: 1.w),
                    Text(
                      (fieldData?['average_rating'] as num?)?.toStringAsFixed(
                            1,
                          ) ??
                          '0',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),

                SizedBox(height: 1.h),
                _buildDetailRow(context, 'Lapangan', fieldData?['name'] ?? ''),
                _buildDetailRow(
                  context,
                  'Tanggal',
                  DateFormat('EEEE, d MMMM y', 'id_ID').format(selectedDate),
                ),
                _buildDetailRow(context, 'Waktu', displayTimeSlot),
                _buildDetailRow(context, 'Durasi', '$totalDuration Jam'),
                const Divider(),
                SizedBox(height: 1.h),
                _buildDetailRow(
                  context,
                  'Total Pembayaran',
                  'Rp ${NumberFormat.decimalPattern('id_ID').format(totalPrice)}',
                  isBold: true,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : onProceedToPayment,
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text('Lanjutkan Pembayaran'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDetailRow(
    BuildContext context,
    String label,
    List<String> timeSlots,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children:
                timeSlots.map((slot) {
                  final parts = slot.split(':');
                  final startHour = int.parse(parts[0]);
                  final endHour = startHour + 1;
                  final endTime =
                      '${endHour.toString().padLeft(2, '0')}:${parts[1]}';
                  return Text(
                    '$slot - $endTime',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
