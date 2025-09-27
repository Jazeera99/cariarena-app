import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import '../../core/app_export.dart';
import '../../widgets/payment/bank_transfer_details.dart';
import '../../widgets/payment/card_input_form.dart';
import '../../widgets/payment/payment_method_card.dart';
import '../../widgets/payment/payment_status_widget.dart';
import '../../widgets/payment/payment_timer_widget.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> summaryData;
  const PaymentScreen({super.key, required this.summaryData});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = '';
  String _selectedBank = '';
  String _selectedEWallet = '';
  Map<String, String> _cardData = {};
  bool _isProcessing = false;
  String _paymentStatus = '';
  String _bookingReference = '';
  bool _showSecurityWarning = false;

  Map<String, dynamic> _realBookingData = {};

  // // Mock booking data
  // final Map<String, dynamic> _bookingData = {
  //   "bookingId": "BK240824001",
  //   "venueName": "Lapangan Badminton Senayan",
  //   "courtNumber": "Court 1",
  //   "date": "25 Agustus 2024",
  //   "time": "14:00 - 16:00",
  //   "duration": "2 jam",
  //   "pricePerHour": "Rp 120.000",
  //   "totalAmount": "Rp 240.000",
  //   "adminFee": "Rp 5.000",
  //   "finalAmount": "Rp 245.000",
  // };

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      "id": "card",
      "title": "Kartu Kredit/Debit",
      "subtitle": "Visa, Mastercard, American Express",
      "icon": "credit_card",
    },
    {
      "id": "bank_transfer",
      "title": "Transfer Bank",
      "subtitle": "BCA, Mandiri, BRI, BNI",
      "icon": "account_balance",
    },
    {
      "id": "ewallet",
      "title": "E-Wallet",
      "subtitle": "GoPay, OVO, DANA, ShopeePay",
      "icon": "account_balance_wallet",
    },
  ];

  final List<Map<String, dynamic>> _bankOptions = [
    {
      "id": "bca",
      "name": "BCA",
      "accountNumber": "1234567890",
      "accountName": "CourtBooker Indonesia",
    },
    {
      "id": "mandiri",
      "name": "Mandiri",
      "accountNumber": "9876543210",
      "accountName": "CourtBooker Indonesia",
    },
    {
      "id": "bri",
      "name": "BRI",
      "accountNumber": "5555666677",
      "accountName": "CourtBooker Indonesia",
    },
    {
      "id": "bni",
      "name": "BNI",
      "accountNumber": "1111222233",
      "accountName": "CourtBooker Indonesia",
    },
  ];

  final List<Map<String, dynamic>> _ewalletOptions = [
    {"id": "gopay", "name": "GoPay", "icon": "account_balance_wallet"},
    {"id": "ovo", "name": "OVO", "icon": "account_balance_wallet"},
    {"id": "dana", "name": "DANA", "icon": "account_balance_wallet"},
    {"id": "shopeepay", "name": "ShopeePay", "icon": "account_balance_wallet"},
  ];

  @override
  void initState() {
    super.initState();
    _generateBookingReference();

    _mapSummaryDataToDisplayData();

    // Show security warning after 2 seconds
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showSecurityWarning = true;
        });
      }
    });
  }

  String formatCurrency(dynamic amount) {
    if (amount == null) return 'Rp 0';

    final numberFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0, // Jika harga tidak ada koma
    );

    // Coba parse ke double/int terlebih dahulu
    final num value =
        (amount is String)
            ? (num.tryParse(amount.replaceAll('.', '').replaceAll(',', '')) ??
                0)
            : (amount as num);

    return numberFormat.format(value);
  }

  void _mapSummaryDataToDisplayData() {
    final summary = widget.summaryData;
    final booking = (summary['booking'] ?? {}) as Map<String, dynamic>;
    final pricing = (summary['pricing'] ?? {}) as Map<String, dynamic>;
    final field = booking['field'] ?? {};

    final List<dynamic> timeSlotsDynamic =
        booking['time_slots'] as List<dynamic>? ?? [];
    final List<String> slots =
        timeSlotsDynamic.map((e) => e.toString()).toList();

    final courtName = field['name'] ?? '-';
    final address = field['address'] ?? '-';
    final date = booking['date'] ?? '-';
    final timeString =
        slots.isNotEmpty
            ? (slots.length > 1
                ? '${slots.first} - ${slots.last}'
                : slots.first)
            : '-';
    final duration = "${slots.length} jam";
    final unitPrice = pricing['unit_price'] ?? pricing['field_price'] ?? 0;
    final subTotal = pricing['field_price'] ?? 0;
    final serviceFee = pricing['service_fee'] ?? 0;
    final tax = pricing['tax'] ?? 0;
    final total = pricing['total'] ?? 0;

    _realBookingData = {
      "bookingId": _bookingReference,
      "courtName": courtName,
      "address": address,
      "date": date,
      "time": timeString,
      "duration": duration,
      "pricePerHour": formatCurrency(unitPrice),
      "totalAmount": formatCurrency(subTotal),
      "adminFee": formatCurrency(serviceFee),
      "tax": formatCurrency(tax),
      "finalAmount": formatCurrency(total),
    };
  }

  void _generateBookingReference() {
    final now = DateTime.now();
    _bookingReference =
        'CB${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.millisecond}';
  }

  void _processPayment() async {
    if (_selectedPaymentMethod.isEmpty) {
      _showErrorSnackBar('Pilih metode pembayaran terlebih dahulu');
      return;
    }

    if (_selectedPaymentMethod == 'card' && _cardData.isEmpty) {
      _showErrorSnackBar('Lengkapi data kartu terlebih dahulu');
      return;
    }

    if (_selectedPaymentMethod == 'bank_transfer' && _selectedBank.isEmpty) {
      _showErrorSnackBar('Pilih bank terlebih dahulu');
      return;
    }

    if (_selectedPaymentMethod == 'ewallet' && _selectedEWallet.isEmpty) {
      _showErrorSnackBar('Pilih e-wallet terlebih dahulu');
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 3));

    // Simulate random payment result (80% success rate)
    final isSuccess = DateTime.now().millisecond % 10 < 8;

    setState(() {
      _isProcessing = false;
      _paymentStatus = isSuccess ? 'success' : 'failed';
    });

    if (isSuccess) {
      _showPaymentResult(
        'success',
        'Pembayaran Anda telah berhasil diproses. Booking telah dikonfirmasi dan Anda akan menerima email konfirmasi segera.',
      );
    } else {
      _showPaymentResult(
        'failed',
        'Pembayaran gagal diproses. Silakan periksa kembali data pembayaran Anda atau coba metode pembayaran lain.',
      );
    }
  }

  void _showPaymentResult(String status, String message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: status != 'processing',
      enableDrag: status != 'processing',
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: 90.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: PaymentStatusWidget(
              status: status,
              message: message,
              bookingReference: status == 'success' ? _bookingReference : null,
              onRetry: () {
                Navigator.pop(context);
                setState(() {
                  _paymentStatus = '';
                });
              },
              onViewBooking: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/booking-history-screen');
              },
            ),
          ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  void _showTimeoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Sesi Berakhir'),
            content: const Text(
              'Waktu pembayaran telah habis. Silakan buat booking baru.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home-screen',
                    (route) => false,
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _isProcessing ? _buildProcessingView() : _buildPaymentView(),
      bottomNavigationBar: _isProcessing ? null : _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        onPressed: () => _showExitConfirmation(),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 6.w,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pembayaran',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            _realBookingData["bookingId"],
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        if (_showSecurityWarning)
          Container(
            margin: EdgeInsets.only(right: 4.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'security',
                  color: AppTheme.getSuccessColor(true),
                  size: 5.w,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Aman',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.getSuccessColor(true),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildProcessingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20.w,
            height: 20.w,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Memproses Pembayaran',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Mohon tunggu, jangan tutup aplikasi',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Payment Timer
          Container(
            margin: EdgeInsets.all(4.w),
            child: PaymentTimerWidget(
              initialDuration: const Duration(minutes: 30),
              onTimeout: _showTimeoutDialog,
            ),
          ),

          // Booking Summary
          _buildBookingSummary(),

          // Payment Methods
          _buildPaymentMethods(),

          // Payment Details
          if (_selectedPaymentMethod == 'card') _buildCardForm(),
          if (_selectedPaymentMethod == 'bank_transfer') _buildBankTransfer(),
          if (_selectedPaymentMethod == 'ewallet') _buildEWalletOptions(),

          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildBookingSummary() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withValues(
              alpha: 0.1,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Booking',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildSummaryRow('Venue', _realBookingData["venueName"] ?? '-'),
          _buildSummaryRow('Lapangan', _realBookingData["courtName"] ?? '-'),
          _buildSummaryRow('Alamat', _realBookingData["address"] ?? '-'),
          _buildSummaryRow('Tanggal', _realBookingData["date"] ?? '-'),
          _buildSummaryRow('Waktu', _realBookingData["time"] ?? '-'),
          _buildSummaryRow('Durasi', _realBookingData["duration"] ?? '-'),
          Divider(height: 3.h),
          _buildSummaryRow('Harga per jam', _realBookingData["pricePerHour"]),
          _buildSummaryRow('Biaya layanan', _realBookingData["adminFee"]),
          Divider(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Pembayaran',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                _realBookingData["finalAmount"],
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
            child: Text(
              'Pilih Metode Pembayaran',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ..._paymentMethods.map(
            (method) => PaymentMethodCard(
              title: method["title"],
              subtitle: method["subtitle"],
              iconName: method["icon"],
              isSelected: _selectedPaymentMethod == method["id"],
              onTap: () {
                setState(() {
                  _selectedPaymentMethod = method["id"];
                  _selectedBank = '';
                  _selectedEWallet = '';
                  _cardData = {};
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardForm() {
    return Container(
      margin: EdgeInsets.all(4.w),
      child: CardInputForm(
        onCardDataChanged: (cardData) {
          setState(() {
            _cardData = cardData;
          });
        },
      ),
    );
  }

  Widget _buildBankTransfer() {
    return Container(
      margin: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Bank',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ..._bankOptions.map(
            (bank) => PaymentMethodCard(
              title: 'Bank ${bank["name"]}',
              subtitle: 'Transfer ke rekening ${bank["name"]}',
              iconName: 'account_balance',
              isSelected: _selectedBank == bank["id"],
              onTap: () {
                setState(() {
                  _selectedBank = bank["id"];
                });
              },
            ),
          ),
          if (_selectedBank.isNotEmpty) ...[
            SizedBox(height: 2.h),
            BankTransferDetails(
              bankName:
                  _bankOptions.firstWhere(
                    (bank) => bank["id"] == _selectedBank,
                  )["name"],
              accountNumber:
                  _bankOptions.firstWhere(
                    (bank) => bank["id"] == _selectedBank,
                  )["accountNumber"],
              accountName:
                  _bankOptions.firstWhere(
                    (bank) => bank["id"] == _selectedBank,
                  )["accountName"],
              amount: _realBookingData["finalAmount"],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEWalletOptions() {
    return Container(
      margin: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih E-Wallet',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ..._ewalletOptions.map(
            (ewallet) => PaymentMethodCard(
              title: ewallet["name"],
              subtitle: 'Bayar dengan ${ewallet["name"]}',
              iconName: ewallet["icon"],
              isSelected: _selectedEWallet == ewallet["id"],
              onTap: () {
                setState(() {
                  _selectedEWallet = ewallet["id"];
                });
              },
            ),
          ),
          if (_selectedEWallet.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary.withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Anda akan diarahkan ke aplikasi ${_ewalletOptions.firstWhere((e) => e["id"] == _selectedEWallet)["name"]} untuk menyelesaikan pembayaran.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withValues(
              alpha: 0.1,
            ),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _realBookingData["finalAmount"],
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _selectedPaymentMethod.isNotEmpty ? _processPayment : null,
                child: const Text('Bayar Sekarang'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Batalkan Pembayaran?'),
            content: const Text(
              'Apakah Anda yakin ingin membatalkan proses pembayaran? Booking Anda akan dibatalkan.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
                child: Text(
                  'Ya, Batalkan',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
