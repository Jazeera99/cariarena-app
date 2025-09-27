import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/user/home_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/user/venue_detail_screen.dart';
import '../screens/user/booking_calendar.dart';
import '../screens/user/booking_summary_screen.dart';
import '../screens/user/booking_history_screen.dart';
import '../screens/user/profile_screen.dart';

class AppRoutes {
  static const String initial = homeScreen;
  static const String homeScreen = '/home-screen';
  static const String venueDetailScreen = '/venue-detail-screen';
  static const String loginScreen = '/login-screen';
  static const String registerScreen = '/register-screen';
  static const String bookingHistory = '/booking-history';
  static const String profileScreen = '/profile-screen';
  static const String resetPasswordScreen = '/reset-password';
  static const String bookingCalendarScreen = '/booking-calendar-screen';
  static const String bookingSummaryScreen = '/booking-summary-screen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case registerScreen:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case venueDetailScreen:
        final fieldId = settings.arguments as int?;
        if (fieldId != null) {
          return MaterialPageRoute(
            builder: (_) => VenueDetailScreen(fieldId: fieldId),
          );
        }
        return _errorRoute();
      case bookingCalendarScreen:
        final fieldId = settings.arguments as int?;
        if (fieldId != null) {
          return MaterialPageRoute(
            builder: (_) => BookingCalendarScreen(fieldId: fieldId),
          );
        }
        return _errorRoute();
      case bookingSummaryScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null) {
          return MaterialPageRoute(
            builder:
                (_) => BookingSummaryScreen(
                  fieldData: args['fieldData'],
                  selectedDate: args['selectedDate'],
                  selectedTimeSlots: args['selectedTimeSlots'],
                  totalPrice: args['totalPrice'],
                  totalDuration: args['totalDuration'],
                ),
          );
        }
        return _errorRoute();
      case bookingHistory:
        return MaterialPageRoute(builder: (_) => const BookingHistoryScreen());
      // return _errorRoute();
      case profileScreen:
        return MaterialPageRoute(
          builder: (context) {
            // Menggunakan FutureBuilder untuk menunggu token
            return FutureBuilder<String?>(
              future: const FlutterSecureStorage().read(key: 'auth_token'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final authToken = snapshot.data;
                  if (authToken != null) {
                    return ProfileScreen(authToken: authToken);
                  } else {
                    // Jika tidak ada token, arahkan pengguna ke halaman login
                    return const LoginScreen();
                  }
                }
                // Tampilkan loading screen saat menunggu
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              },
            );
          },
        );
      case resetPasswordScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null &&
            args.containsKey('token') &&
            args.containsKey('email')) {
          return MaterialPageRoute(
            builder:
                (_) => ResetPasswordScreen(
                  token: args['token'],
                  email: args['email'],
                ),
          );
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Halaman tidak ditemukan')),
          ),
    );
  }
}
