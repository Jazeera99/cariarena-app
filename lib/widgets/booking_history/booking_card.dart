import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './booking_action_buttons.dart';
import './booking_status_badge.dart';

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback? onTap;
  final VoidCallback? onCheckIn;
  final VoidCallback? onCancel;
  final VoidCallback? onReview;
  final VoidCallback? onBookAgain;

  const BookingCard({
    super.key,
    required this.booking,
    this.onTap,
    this.onCheckIn,
    this.onCancel,
    this.onReview,
    this.onBookAgain,
  });

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final venue = booking['venue'] as Map<String, dynamic>? ?? {};
    final bookingDate = DateTime.parse(
      booking['booking_date'] as String? ?? DateTime.now().toString(),
    );
    final startTime = DateTime.parse(
      booking['start_time'] as String? ?? DateTime.now().toString(),
    );
    final endTime = DateTime.parse(
      booking['end_time'] as String? ??
          DateTime.now().add(Duration(hours: 1)).toString(),
    );
    final status = booking['status'] as String? ?? 'pending';
    final totalAmount = booking['total_amount'] as double? ?? 0.0;
    final bookingReference = booking['booking_reference'] as String? ?? '';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl:
                          venue['image_url'] as String? ??
                          'https://images.unsplash.com/photo-1544717297-fa95b6ee9643?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
                      width: 20.w,
                      height: 15.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                venue['name'] as String? ?? 'Venue Name',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            BookingStatusBadge(status: status),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'calendar_today',
                              size: 16,
                              color:
                                  AppTheme
                                      .lightTheme
                                      .colorScheme
                                      .onSurfaceVariant,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              _formatDate(bookingDate),
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'access_time',
                              size: 16,
                              color:
                                  AppTheme
                                      .lightTheme
                                      .colorScheme
                                      .onSurfaceVariant,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              '${_formatTime(startTime)} - ${_formatTime(endTime)}',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Divider(
                color: AppTheme.lightTheme.colorScheme.outline.withValues(
                  alpha: 0.2,
                ),
                height: 1,
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kode Booking',
                        style: AppTheme.lightTheme.textTheme.bodySmall
                            ?.copyWith(
                              color:
                                  AppTheme
                                      .lightTheme
                                      .colorScheme
                                      .onSurfaceVariant,
                            ),
                      ),
                      Text(
                        bookingReference,
                        style: AppTheme.lightTheme.textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Bayar',
                        style: AppTheme.lightTheme.textTheme.bodySmall
                            ?.copyWith(
                              color:
                                  AppTheme
                                      .lightTheme
                                      .colorScheme
                                      .onSurfaceVariant,
                            ),
                      ),
                      Text(
                        'Rp ${totalAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                        style: AppTheme.lightTheme.textTheme.titleSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              BookingActionButtons(
                status: status,
                onCheckIn: onCheckIn,
                onCancel: onCancel,
                onReview: onReview,
                onBookAgain: onBookAgain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
