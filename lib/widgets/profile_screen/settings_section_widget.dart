import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SettingsSectionWidget extends StatelessWidget {
  final bool notificationBookingReminders;
  final bool notificationPromotions;
  final bool notificationSystemUpdates;
  final bool isDarkMode;
  final String selectedLanguage;
  final ValueChanged<bool> onNotificationBookingChanged;
  final ValueChanged<bool> onNotificationPromotionsChanged;
  final ValueChanged<bool> onNotificationSystemChanged;
  final ValueChanged<bool> onDarkModeChanged;
  final VoidCallback onLanguageTap;
  final VoidCallback onPaymentMethodsTap;

  const SettingsSectionWidget({
    super.key,
    required this.notificationBookingReminders,
    required this.notificationPromotions,
    required this.notificationSystemUpdates,
    required this.isDarkMode,
    required this.selectedLanguage,
    required this.onNotificationBookingChanged,
    required this.onNotificationPromotionsChanged,
    required this.onNotificationSystemChanged,
    required this.onDarkModeChanged,
    required this.onLanguageTap,
    required this.onPaymentMethodsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Section
          _buildSectionTitle('Informasi Akun'),
          _buildSettingsCard([
            _buildSettingsTile(
              icon: Icons.person,
              title: 'Edit Profil',
              subtitle: 'Ubah informasi pribadi',
              onTap: () {},
              showArrow: true,
            ),
            _buildDivider(),
            _buildSettingsTile(
              icon: Icons.security,
              title: 'Keamanan Akun',
              subtitle: 'Ubah kata sandi dan keamanan',
              onTap: () {},
              showArrow: true,
            ),
          ]),

          SizedBox(height: 3.h),

          // Notifications Section
          _buildSectionTitle('Notifikasi'),
          _buildSettingsCard([
            _buildSwitchTile(
              icon: Icons.notifications,
              title: 'Pengingat Booking',
              subtitle: 'Notifikasi untuk booking Anda',
              value: notificationBookingReminders,
              onChanged: onNotificationBookingChanged,
            ),
            _buildDivider(),
            _buildSwitchTile(
              icon: Icons.local_offer,
              title: 'Penawaran Promo',
              subtitle: 'Dapatkan notifikasi promo terbaru',
              value: notificationPromotions,
              onChanged: onNotificationPromotionsChanged,
            ),
            _buildDivider(),
            _buildSwitchTile(
              icon: Icons.system_update,
              title: 'Update Sistem',
              subtitle: 'Notifikasi pembaruan aplikasi',
              value: notificationSystemUpdates,
              onChanged: onNotificationSystemChanged,
            ),
          ]),

          SizedBox(height: 3.h),

          // App Settings Section
          _buildSectionTitle('Pengaturan Aplikasi'),
          _buildSettingsCard([
            _buildSettingsTile(
              icon: Icons.language,
              title: 'Bahasa',
              subtitle: selectedLanguage,
              onTap: onLanguageTap,
              showArrow: true,
            ),
            _buildDivider(),
            _buildSwitchTile(
              icon: Icons.dark_mode,
              title: 'Mode Gelap',
              subtitle: 'Tema gelap untuk mata yang lebih nyaman',
              value: isDarkMode,
              onChanged: onDarkModeChanged,
            ),
          ]),

          SizedBox(height: 3.h),

          // Payment Section
          _buildSectionTitle('Pembayaran'),
          _buildSettingsCard([
            _buildSettingsTile(
              icon: Icons.payment,
              title: 'Metode Pembayaran',
              subtitle: 'Kelola kartu dan e-wallet',
              onTap: onPaymentMethodsTap,
              showArrow: true,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showArrow = false,
  }) {
    return ListTile(
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 5.w,
        ),
      ),
      title: Text(title, style: AppTheme.lightTheme.textTheme.titleSmall),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing:
          showArrow
              ? Icon(
                Icons.chevron_right,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              )
              : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withAlpha(26),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 5.w,
        ),
      ),
      title: Text(title, style: AppTheme.lightTheme.textTheme.titleSmall),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16.w,
      endIndent: 4.w,
      color: AppTheme.lightTheme.colorScheme.outline.withAlpha(51),
    );
  }
}
