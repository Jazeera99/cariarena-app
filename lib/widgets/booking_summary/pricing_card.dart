import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PricingBreakdownCard extends StatelessWidget {
  final Map<String, dynamic> pricingData;

  const PricingBreakdownCard({super.key, required this.pricingData});

  @override
  Widget build(BuildContext context) {
    final courtFee = pricingData["field_price"] ?? 0;
    final serviceFee = pricingData["service_fee"] ?? 0;
    final tax = pricingData["tax"] ?? 0;
    final total = pricingData["total"] ?? 0;

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
              "Rincian Harga",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 3.h),
            // Gunakan kunci API "field_price"
            _buildPriceRow("Sewa Lapangan", "Rp $courtFee", false),
            SizedBox(height: 2.h),
            // Gunakan kunci API "service_fee"
            _buildPriceRow("Biaya Layanan", "Rp $serviceFee", false),
            SizedBox(height: 2.h),
            // Gunakan kunci API "tax"
            _buildPriceRow("Pajak", "Rp $tax", false),
            SizedBox(height: 2.h),
            Divider(color: AppTheme.lightTheme.dividerColor, thickness: 1),
            SizedBox(height: 2.h),
            _buildPriceRow("Total", "Rp $total", true),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String price, bool isTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color:
                isTotal
                    ? AppTheme.lightTheme.colorScheme.onSurface
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          price,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            fontSize: isTotal ? 16.sp : 14.sp,
            color:
                isTotal
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
