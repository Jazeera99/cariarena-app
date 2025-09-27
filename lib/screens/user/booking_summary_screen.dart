import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/api_service.dart';
import '../../screens/user/payment_screen.dart';
import '../../widgets/booking_summary/booking_details_card.dart';
import '../../widgets/booking_summary/payment_method_card.dart';
import '../../widgets/booking_summary/pricing_card.dart';
import '../../widgets/booking_summary/special_requests_card.dart';
import '../../widgets/booking_summary/terms_acceptance_widget.dart';
import '../../widgets/booking_summary/user_info_card.dart';
import '../../widgets/booking_summary/venue_info_card.dart';

class BookingSummaryScreen extends StatefulWidget {
  final Map<String, dynamic> fieldData;
  final DateTime selectedDate;
  final List<String> selectedTimeSlots;
  final double totalPrice;
  final int totalDuration;

  const BookingSummaryScreen({
    super.key,
    required this.fieldData,
    required this.selectedDate,
    required this.selectedTimeSlots,
    required this.totalPrice,
    required this.totalDuration,
  });

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  final TextEditingController _specialRequestsController =
      TextEditingController();
  String _selectedPaymentMethod = "credit_card";
  bool _termsAccepted = false;
  bool _isProcessingPayment = false;

  Map<String, dynamic>? bookingSummary;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookingSummary();
  }

  Future<void> fetchBookingSummary() async {
    try {
      final data = await ApiService.getBookingSummary(
        fieldId: widget.fieldData['id'],
        date: widget.selectedDate,
        timeSlots: widget.selectedTimeSlots,
      );
      setState(() {
        bookingSummary = Map<String, dynamic>.from(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat ringkasan pesanan: $e')),
      );
    }
  }

  void _onEditUserInfo() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Edit Informasi"),
            content: Text("Fitur edit informasi pemesan akan segera tersedia."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  void _onTermsTap() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Syarat dan Ketentuan"),
            content: SingleChildScrollView(
              child: Text(
                "Dengan menggunakan layanan CourtBooker, Anda menyetujui syarat dan ketentuan berikut:\n\n1. Pembayaran harus dilakukan sebelum waktu yang ditentukan\n2. Pembatalan dapat dilakukan maksimal 2 jam sebelum waktu booking\n3. Pengguna bertanggung jawab atas kerusakan fasilitas\n4. Kebijakan privasi melindungi data pribadi pengguna\n\nUntuk informasi lengkap, silakan kunjungi website resmi kami.",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Tutup"),
              ),
            ],
          ),
    );
  }

  Future<void> _processPayment() async {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap setujui syarat dan ketentuan.")),
      );
      return;
    }

    setState(() => _isProcessingPayment = true);

    try {
      final pricing = bookingSummary?['pricing'] ?? {};
      final reservationData = {
        "field_id": widget.fieldData['id'],
        "date": widget.selectedDate.toIso8601String().substring(0, 10),
        "time_slots": widget.selectedTimeSlots,
        "special_requests": _specialRequestsController.text,
        "payment_method": _selectedPaymentMethod,
        "sub_total": pricing['field_price'] ?? 0,
        "service_fee": pricing['service_fee'] ?? 0,
        "final_amount": pricing['total'] ?? 0,
      };

      await ApiService().createReservation(reservationData);

      if (mounted) {
        // Pastikan semua field wajib String tidak null
        Map<String, dynamic> safeSummary = Map<String, dynamic>.from(
          bookingSummary!,
        );
        safeSummary['venue'] = Map<String, dynamic>.from(
          safeSummary['venue'] ?? {},
        )..updateAll((key, value) => value ?? '');
        safeSummary['booking'] = Map<String, dynamic>.from(
          safeSummary['booking'] ?? {},
        )..updateAll((key, value) => value ?? '');
        safeSummary['pricing'] = Map<String, dynamic>.from(
          safeSummary['pricing'] ?? {},
        )..updateAll((key, value) => value ?? 0);
        safeSummary['user'] = Map<String, dynamic>.from(
          safeSummary['user'] ?? {},
        )..updateAll((key, value) => value ?? '');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(summaryData: safeSummary),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memproses pembayaran: $e")));
    } finally {
      setState(() => _isProcessingPayment = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (bookingSummary == null) {
      return const Scaffold(
        body: Center(child: Text('Gagal memuat ringkasan pesanan.')),
      );
    }

    // Selalu gunakan default value agar tidak error null/String
    final venueData =
        (bookingSummary!['venue'] ?? widget.fieldData) as Map<String, dynamic>;
    final bookingData = Map<String, dynamic>.from(
      bookingSummary!['booking'] ?? {},
    );
    final pricingData = Map<String, dynamic>.from(
      bookingSummary!['pricing'] ?? {},
    );
    final userData = Map<String, dynamic>.from(bookingSummary!['user'] ?? {});

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color:
                AppTheme.lightTheme.appBarTheme.iconTheme?.color ??
                Colors.black,
            size: 24,
          ),
        ),
        title: Text(
          "Ringkasan Pesanan",
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/booking-calendar-screen');
            },
            icon: CustomIconWidget(
              iconName: 'edit',
              color:
                  AppTheme.lightTheme.appBarTheme.iconTheme?.color ??
                  Colors.black,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    VenueInfoCard(venueData: venueData),
                    BookingDetailsCard(bookingData: bookingData),
                    PricingBreakdownCard(pricingData: pricingData),
                    UserInfoCard(userData: userData, onEdit: _onEditUserInfo),
                    SpecialRequestsCard(
                      controller: _specialRequestsController,
                      onChanged: (value) {},
                    ),
                    PaymentMethodCard(
                      selectedMethod: _selectedPaymentMethod,
                      onMethodSelected: (method) {
                        setState(() {
                          _selectedPaymentMethod = method;
                        });
                      },
                      paymentMethods: [
                        {
                          "id": "credit_card",
                          "name": "Kartu Kredit/Debit",
                          "description": "Visa, Mastercard, JCB",
                          "icon":
                              "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
                        },
                        {
                          "id": "bank_transfer",
                          "name": "Transfer Bank",
                          "description": "BCA, Mandiri, BNI, BRI",
                          "icon":
                              "https://images.unsplash.com/photo-1554224155-6726b3ff858f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
                        },
                        {
                          "id": "e_wallet",
                          "name": "E-Wallet",
                          "description": "GoPay, OVO, DANA, LinkAja",
                          "icon":
                              "https://images.unsplash.com/photo-1563013544-824ae1b704d3?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
                        },
                      ],
                    ),
                    TermsAcceptanceWidget(
                      isAccepted: _termsAccepted,
                      onChanged: (value) {
                        setState(() {
                          _termsAccepted = value ?? false;
                        });
                      },
                      onTermsTap: _onTermsTap,
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        child: FloatingActionButton.extended(
          onPressed: _isProcessingPayment ? null : _processPayment,
          backgroundColor:
              _isProcessingPayment
                  ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  : AppTheme
                      .lightTheme
                      .floatingActionButtonTheme
                      .backgroundColor,
          foregroundColor:
              AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor,
          elevation: AppTheme.lightTheme.floatingActionButtonTheme.elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          label:
              _isProcessingPayment
                  ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 5.w,
                        height: 5.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme
                                    .lightTheme
                                    .floatingActionButtonTheme
                                    .foregroundColor ??
                                Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        "Memproses...",
                        style: AppTheme.lightTheme.textTheme.labelLarge
                            ?.copyWith(
                              color:
                                  AppTheme
                                      .lightTheme
                                      .floatingActionButtonTheme
                                      .foregroundColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  )
                  : Text(
                    "Bayar Sekarang - Rp ${pricingData['total'] ?? 0}",
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color:
                          AppTheme
                              .lightTheme
                              .floatingActionButtonTheme
                              .foregroundColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
