import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';

class TimeSlotGrid extends StatelessWidget {
  final DateTime selectedDate;
  final List<String> selectedTimeSlots;
  final Function(String) onTimeSlotSelected;
  final Map<String, Map<String, dynamic>> timeSlots;
  final bool isLoading;

  const TimeSlotGrid({
    super.key,
    required this.selectedDate,
    required this.selectedTimeSlots,
    required this.onTimeSlotSelected,
    required this.timeSlots,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingGrid(context);
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // Ganti AppTheme.shadowColor dengan ini
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Waktu',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          _buildTimeSlotGrid(),
        ],
      ),
    );
  }

  Widget _buildLoadingGrid(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // Ganti AppTheme.shadowColor dengan ini
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Waktu',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              crossAxisSpacing: 2.w,
              mainAxisSpacing: 1.h,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                      .withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotGrid() {
    final sortedSlots =
        timeSlots.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        crossAxisSpacing: 2.w,
        mainAxisSpacing: 1.h,
      ),
      itemCount: sortedSlots.length,
      itemBuilder: (context, index) {
        final slot = sortedSlots[index];
        final timeSlot = slot.key;
        final slotData = slot.value;
        return _buildTimeSlotCard(timeSlot, slotData);
      },
    );
  }

  Widget _buildTimeSlotCard(String timeSlot, Map<String, dynamic> slotData) {
    final isAvailable = slotData['available'] as bool;
    final price = (slotData['price'] as num).toDouble();
    final isSelected = selectedTimeSlots.contains(timeSlot);
    final isPast = _isTimeSlotPast(timeSlot);

    Color backgroundColor;
    Color textColor;
    Color borderColor = Colors.transparent;
    String displayText;

    if (isPast) {
      backgroundColor = AppTheme.lightTheme.colorScheme.surfaceContainerHighest
          .withOpacity(0.5);
      textColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant.withOpacity(
        0.5,
      );
      displayText = timeSlot;
    } else if (!isAvailable) {
      backgroundColor = AppTheme.lightTheme.colorScheme.error.withOpacity(0.1);
      textColor = AppTheme.lightTheme.colorScheme.error;
      displayText = 'Tidak Tersedia';
    } else if (isSelected) {
      backgroundColor = AppTheme.lightTheme.colorScheme.primary;
      textColor = AppTheme.lightTheme.colorScheme.onPrimary;
      borderColor = AppTheme.lightTheme.colorScheme.primary;
      displayText = timeSlot;
    } else {
      backgroundColor = AppTheme.lightTheme.colorScheme.primary.withOpacity(
        0.1,
      );
      textColor = AppTheme.lightTheme.colorScheme.primary;
      displayText = timeSlot;
    }

    return GestureDetector(
      onTap:
          (isAvailable && !isPast) ? () => onTimeSlotSelected(timeSlot) : null,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isAvailable && !isPast && !isSelected) ...[
              Text(
                timeSlot,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Rp ${_formatPrice(price)}',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: textColor.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ] else if (isSelected) ...[
              CustomIconWidget(iconName: 'check', color: textColor, size: 16),
              SizedBox(height: 0.5.h),
              Text(
                timeSlot,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ] else ...[
              Text(
                displayText,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isPast)
                Text(
                  'Rp ${_formatPrice(price)}',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: textColor.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  bool _isTimeSlotPast(String timeSlot) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    if (selectedDay.isAfter(today)) {
      return false;
    }

    if (selectedDay.isBefore(today)) {
      return true;
    }

    final timeParts = timeSlot.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final slotDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
      minute,
    );

    return slotDateTime.isBefore(now);
  }

  String _formatPrice(double price) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    return format.format(price).trim();
  }
}
