import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final List<DateTime> availableDates;
  final List<DateTime> unavailableDates;

  const CalendarWidget({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.availableDates,
    required this.unavailableDates,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCalendarHeader(),
          SizedBox(height: 2.h),
          _buildWeekDaysHeader(),
          SizedBox(height: 1.h),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => _navigateMonth(-1),
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'chevron_left',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
          ),
        ),
        Text(
          _getMonthYearText(_currentMonth),
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        GestureDetector(
          onTap: () => _navigateMonth(1),
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekDaysHeader() {
    final weekDays = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
    return Row(
      children:
          weekDays.map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final firstWeekday = firstDayOfMonth.weekday % 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 42,
      itemBuilder: (context, index) {
        if (index < firstWeekday) {
          return const SizedBox();
        }

        final dayNumber = index - firstWeekday + 1;
        if (dayNumber > daysInMonth) {
          return const SizedBox();
        }

        final date = DateTime(
          _currentMonth.year,
          _currentMonth.month,
          dayNumber,
        );
        return _buildDateCell(date);
      },
    );
  }

  Widget _buildDateCell(DateTime date) {
    final isSelected = _isSameDay(date, widget.selectedDate);
    final isAvailable = widget.availableDates.any((d) => _isSameDay(d, date));
    final isUnavailable = widget.unavailableDates.any(
      (d) => _isSameDay(d, date),
    );
    final isPast = date.isBefore(
      DateTime.now().subtract(const Duration(days: 1)),
    );
    final isToday = _isSameDay(date, DateTime.now());

    Color backgroundColor = Colors.transparent;
    Color textColor = AppTheme.lightTheme.colorScheme.onSurface;
    Color? borderColor;

    if (isPast) {
      textColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant.withOpacity(
        0.5,
      );
    } else if (isSelected) {
      // Always show selected date with primary color, even if unavailable
      backgroundColor = AppTheme.lightTheme.colorScheme.primary;
      textColor = AppTheme.lightTheme.colorScheme.onPrimary;
    } else if (isAvailable) {
      backgroundColor = AppTheme.lightTheme.colorScheme.primary.withOpacity(
        0.1,
      );
      textColor = AppTheme.lightTheme.colorScheme.primary;
    } else if (isUnavailable) {
      backgroundColor =
          Colors.transparent; // Remove red background for unavailable dates
      textColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant.withOpacity(
        0.5,
      ); // Show as disabled text
    }

    if (isToday && !isSelected) {
      borderColor = AppTheme.lightTheme.colorScheme.primary;
    }

    return GestureDetector(
      onTap: isPast || isUnavailable ? null : () => widget.onDateSelected(date),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border:
              borderColor != null
                  ? Border.all(color: borderColor, width: 1.5)
                  : null,
        ),
        child: Center(
          child: Text(
            date.day.toString(),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateMonth(int direction) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + direction,
      );
    });
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getMonthYearText(DateTime date) {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
