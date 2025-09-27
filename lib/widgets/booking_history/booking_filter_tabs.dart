import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BookingFilterTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;
  final List<String> tabs = const [
    'Semua',
    'Mendatang',
    'Selesai',
    'Dibatalkan',
  ];

  const BookingFilterTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children:
            tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              final isSelected = selectedIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTabChanged(index),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color:
                            isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      tab,
                      textAlign: TextAlign.center,
                      style: AppTheme.lightTheme.textTheme.labelMedium
                          ?.copyWith(
                            color:
                                isSelected
                                    ? AppTheme.lightTheme.colorScheme.onPrimary
                                    : AppTheme
                                        .lightTheme
                                        .colorScheme
                                        .onSurfaceVariant,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
