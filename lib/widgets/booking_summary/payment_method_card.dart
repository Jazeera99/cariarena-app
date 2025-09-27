import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PaymentMethodCard extends StatelessWidget {
  final String selectedMethod;
  final Function(String) onMethodSelected;
  final List<Map<String, dynamic>> paymentMethods;

  const PaymentMethodCard({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
    required this.paymentMethods,
  });

  @override
  Widget build(BuildContext context) {
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
              "Metode Pembayaran",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 3.h),
            ...paymentMethods.map((method) => _buildPaymentOption(method)),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(Map<String, dynamic> method) {
    final bool isSelected = selectedMethod == method["id"];

    return GestureDetector(
      onTap: () => onMethodSelected(method["id"] as String),
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color:
              isSelected
                  ? AppTheme.lightTheme.colorScheme.primaryContainer.withValues(
                    alpha: 0.1,
                  )
                  : Colors.transparent,
        ),
        child: Row(
          children: [
            CustomImageWidget(
              imageUrl: method["icon"] as String,
              width: 10.w,
              height: 6.h,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method["name"] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  if (method["description"] != null) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      method["description"] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              width: 5.w,
              height: 5.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.dividerColor,
                  width: 2,
                ),
                color:
                    isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : Colors.transparent,
              ),
              child:
                  isSelected
                      ? CustomIconWidget(
                        iconName: 'check',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 12,
                      )
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
