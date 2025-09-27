import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import '../../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/booking_calendar/booking_card_widget.dart';
import '../../widgets/booking_calendar/calendar_widget.dart';
import '../../widgets/booking_calendar/time_grid.dart';
import '../../../services/api_service.dart';

class BookingCalendarScreen extends StatefulWidget {
  final int fieldId;

  const BookingCalendarScreen({super.key, required this.fieldId});

  @override
  State<BookingCalendarScreen> createState() => _BookingCalendarScreenState();
}

class _BookingCalendarScreenState extends State<BookingCalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  final List<String> _selectedTimeSlots = [];
  Map<String, dynamic>? _fieldData;
  Map<String, Map<String, dynamic>> _timeSlots = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchVenueData();
  }

  Future<void> _fetchVenueData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Fetch field detail using the existing ApiService method
      final field = await ApiService().getFieldDetail(
        widget.fieldId.toString(),
      );

      // Convert Field object to Map for compatibility
      final fieldData = {
        'id': field.id,
        'name': field.name,
        'description': field.description,
        'opening_time': field.openingTime,
        'closing_time': field.closingTime,
        'price': field.pricePerHour,
        'schedules': field.schedules,
        'facilities': field.facilities,
        'image_url': field.imageUrl,
        'location': field.location,
        'city': field.city,
        'full_address': field.fullAddress,
      };

      // Filter booked schedules for the selected date
      final selectedDateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final bookedSchedules =
          field.schedules.where((schedule) {
            final scheduleDate = schedule['date'] ?? '';
            return scheduleDate == selectedDateStr;
          }).toList();

      setState(() {
        _fieldData = fieldData;
        _timeSlots = _generateTimeSlots(
          field.openingTime,
          field.closingTime,
          field.pricePerHour,
          bookedSchedules,
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching venue data: $e';
        _isLoading = false;
      });
    }
  }

  void _onTimeSlotSelected(String timeSlot) {
    setState(() {
      if (_selectedTimeSlots.contains(timeSlot)) {
        _selectedTimeSlots.remove(timeSlot);
      } else {
        _selectedTimeSlots.add(timeSlot);
        _selectedTimeSlots.sort(); // Mengurutkan pilihan waktu
      }
    });
  }

  void _handleDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedTimeSlots.clear();
    });
    _fetchVenueData();
  }

  void _handleProceedToPayment() {
    if (_selectedTimeSlots.isEmpty) {
      _showErrorMessage('Silakan pilih setidaknya satu waktu booking.');
      return;
    }

    // Validate if any selected slot is now unavailable
    final unavailableSlots =
        _selectedTimeSlots
            .where(
              (timeSlot) =>
                  !_timeSlots.containsKey(timeSlot) ||
                  !_timeSlots[timeSlot]!['available'],
            )
            .toList();

    if (unavailableSlots.isNotEmpty) {
      _showErrorMessage(
        'Waktu yang Anda pilih sudah terisi atau tidak valid. Silakan pilih waktu lain.',
      );
      return;
    }

    // Navigate to booking summary screen with booking details
    Navigator.pushNamed(
      context,
      AppRoutes.bookingSummaryScreen,
      arguments: {
        'fieldData': _fieldData,
        'selectedDate': _selectedDate,
        'selectedTimeSlots': _selectedTimeSlots,
        'totalPrice': _calculateTotalPrice(),
        'totalDuration': _calculateTotalDuration(),
      },
    );
  }

  // Calculate total price based on the number of selected slots.
  double _calculateTotalPrice() {
    if (_selectedTimeSlots.isEmpty || _fieldData == null) return 0.0;

    final int duration = _calculateTotalDuration();
    final double pricePerHour = (_fieldData!['price'] as num).toDouble();

    return duration * pricePerHour;
  }

  // Calculate total duration by counting the number of selected slots.
  int _calculateTotalDuration() {
    return _selectedTimeSlots.length;
  }

  // Format the selected time slots for display, showing each individual slot.
  String _formatTimeSlotsForDisplay() {
    if (_selectedTimeSlots.isEmpty) {
      return 'Pilih waktu';
    }
    _selectedTimeSlots.sort();
    return _selectedTimeSlots.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Jadwal')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    CalendarWidget(
                      selectedDate: _selectedDate,
                      onDateSelected: _handleDateSelected,
                      availableDates: const [],
                      unavailableDates: const [],
                    ),
                    SizedBox(height: 2.h),
                    TimeSlotGrid(
                      selectedDate: _selectedDate,
                      selectedTimeSlots: _selectedTimeSlots,
                      onTimeSlotSelected: _onTimeSlotSelected,
                      timeSlots: _timeSlots,
                      isLoading: _isLoading,
                    ),
                    SizedBox(height: 2.h),
                    if (_selectedTimeSlots.isNotEmpty && _fieldData != null)
                      BookingCard(
                        selectedDate: _selectedDate,
                        selectedTimeSlots: _selectedTimeSlots,
                        fieldData: _fieldData,
                        totalPrice: _calculateTotalPrice(),
                        totalDuration: _calculateTotalDuration(),
                        onProceedToPayment: _handleProceedToPayment,
                        isLoading: _isLoading,
                        timeSlots: _timeSlots,
                      ),
                  ],
                ),
              ),
    );
  }

  Map<String, Map<String, dynamic>> _generateTimeSlots(
    String openingTime,
    String closingTime,
    dynamic price,
    List<dynamic> bookedSchedules,
  ) {
    final Map<String, Map<String, dynamic>> slots = {};
    final bookedTimeSlots =
        bookedSchedules
            .map((s) => s['time_slot'].toString().substring(0, 5))
            .toSet();
    final openingHour = int.parse(openingTime.split(':')[0]);
    final closingHour = int.parse(closingTime.split(':')[0]);
    final parsedPrice = double.tryParse(price.toString()) ?? 0.0;

    for (int hour = openingHour; hour < closingHour; hour++) {
      String timeSlot = '${hour.toString().padLeft(2, '0')}:00';
      final isBooked = bookedTimeSlots.contains(timeSlot);
      slots[timeSlot] = {'available': !isBooked, 'price': parsedPrice};
    }
    return slots;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onError,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }
}
