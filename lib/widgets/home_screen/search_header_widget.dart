import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_export.dart';

class SearchAndFilterWidget extends StatelessWidget {
  final VoidCallback onFilterTap;
  const SearchAndFilterWidget({super.key, required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSecondary,
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                  hintText: "Cari lapangan badminton...",
                  hintStyle: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontSize: 14.sp,
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 2.w),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              height: 5.h,
              width: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(Icons.filter_list, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
