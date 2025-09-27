import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/app_export.dart';
import '../../models/dashboard_stats.dart';
import '../../services/api_service.dart';
import '../../routes/app_routes.dart';
import '../../widgets/home_screen/bottom_navigation_widget.dart';
import '../../widgets/profile_screen/actions_widget.dart';
import '../../widgets/profile_screen/logout_button_widget.dart';
import '../../widgets/profile_screen/profile_header_widget.dart';
import '../../widgets/profile_screen/settings_section_widget.dart';
import '../../widgets/profile_screen/statistics_cards_widget.dart';

class ProfileScreen extends StatefulWidget {
  final String authToken;
  const ProfileScreen({super.key, required this.authToken});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationBookingReminders = true;
  bool _notificationPromotions = false;
  bool _notificationSystemUpdates = true;
  bool _isDarkMode = false;
  String _selectedLanguage = 'Indonesian';
  String _userName = '';
  String _userEmail = '';
  String _userPhone = '';
  final storage = const FlutterSecureStorage();

  Map<String, dynamic>? _userStats;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchAndSetUserData();
  }

  // Mengubah nama metode agar lebih spesifik
  Future<void> _fetchAndSetUserData() async {
    try {
      // 1. Ambil token dari storage, ini adalah cara yang paling andal
      final authToken = await storage.read(key: 'authToken');

      if (authToken == null) {
        // Jika token tidak ada, atur status error dan keluar dari fungsi
        setState(() {
          _isLoading = false;
          _errorMessage = 'Silakan login kembali. Sesi Anda telah berakhir.';
        });
        // Tampilkan SnackBar untuk memberitahu pengguna
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_errorMessage)));
        return;
      }

      final responseData = await ApiService.fetchUserProfileAndStats(authToken);

      final userData = responseData['data']['user'] as Map<String, dynamic>;
      final statsData = responseData['data']['stats'] as Map<String, dynamic>;

      // final userProfile = await ApiService.getUserProfile(widget.authToken);
      // final userProfile = await ApiService.getUserData(widget.authToken);
      // final userStatistics = await ApiService.getUserStatistics(widget.authToken);

      setState(() {
        _userName = userData['name'] ?? '';
        _userEmail = userData['email'] ?? '';
        _userPhone = userData['phone'] ?? '';
        _userStats = statsData;
        _isLoading = false;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal mengambil data profil: $e';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_errorMessage)));
    }
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.bookingHistory);
        break;
      case 2:
        // Already on profile screen
        break;
    }
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Edit Profil',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: 'User',
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 2.h),
                TextFormField(
                  initialValue: 'user@email.com',
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 2.h),
                TextFormField(
                  initialValue: '+62 812 3456 7890',
                  decoration: const InputDecoration(
                    labelText: 'Nomor Telepon',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profil berhasil diperbarui'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih Bahasa',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 2.h),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Bahasa Indonesia'),
                  trailing:
                      _selectedLanguage == 'Indonesian'
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                  onTap: () {
                    setState(() {
                      _selectedLanguage = 'Indonesian';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('English'),
                  trailing:
                      _selectedLanguage == 'English'
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                  onTap: () {
                    setState(() {
                      _selectedLanguage = 'English';
                    });
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
    );
  }

  void _showPaymentMethods() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            height: 60.h,
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Metode Pembayaran',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 2.h),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.credit_card, color: Colors.blue),
                    title: const Text('**** **** **** 1234'),
                    subtitle: const Text('Visa - Berakhir 12/25'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {},
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.green,
                    ),
                    title: const Text('GoPay'),
                    subtitle: const Text('081234567890'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {},
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.blue,
                    ),
                    title: const Text('DANA'),
                    subtitle: const Text('081234567890'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {},
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Metode Pembayaran'),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Keluar Akun',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.loginScreen,
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Keluar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    // Gunakan _userStats yang sudah diisi oleh _fetchUserData
    if (_userStats == null) {
      // Tampilkan pesan error jika data gagal dimuat
      return Scaffold(
        body: Center(
          child: Text(
            _errorMessage.isNotEmpty ? _errorMessage : 'Data tidak tersedia',
          ),
        ),
      );
    }

    // Ambil data dari _userStats
    final _totalBookings = _userStats!['total_bookings'] as int;

    // PERBAIKAN: Nama kunci di backend adalah 'total_bookmarks'
    final _favoriteVenues = _userStats!['total_bookmarks'] as int;

    // PERBAIKAN: Konversi tipe data int menjadi String
    final _totalPayments = _userStats!['total_payments'].toString();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profil'),
        actions: [
          IconButton(
            onPressed: _showEditProfileDialog,
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeaderWidget(
              userName: _userName,
              userEmail: _userEmail,
              userPhone: _userPhone,
            ),
            SizedBox(height: 3.h),
            StatisticsCardsWidget(
              totalBookings: _totalBookings,
              favoriteVenues: _favoriteVenues,
              totalPayments: _totalPayments,
            ),
            SizedBox(height: 3.h),
            SettingsSectionWidget(
              notificationBookingReminders: _notificationBookingReminders,
              notificationPromotions: _notificationPromotions,
              notificationSystemUpdates: _notificationSystemUpdates,
              isDarkMode: _isDarkMode,
              selectedLanguage: _selectedLanguage,
              onNotificationBookingChanged: (value) {
                setState(() {
                  _notificationBookingReminders = value;
                });
              },
              onNotificationPromotionsChanged: (value) {
                setState(() {
                  _notificationPromotions = value;
                });
              },
              onNotificationSystemChanged: (value) {
                setState(() {
                  _notificationSystemUpdates = value;
                });
              },
              onDarkModeChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
              onLanguageTap: _showLanguageSelector,
              onPaymentMethodsTap: _showPaymentMethods,
            ),
            SizedBox(height: 3.h),
            const QuickActionsWidget(),
            SizedBox(height: 3.h),
            LogoutButtonWidget(onLogout: _showLogoutDialog),
            SizedBox(height: 10.h),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: 2,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
