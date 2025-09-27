import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/booking_history/booking_card.dart';
import '../../widgets/booking_history/booking_filter_tabs.dart';
import '../../widgets/booking_history/empty_booking_state.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  int _selectedTabIndex = 0;
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  final String _searchQuery = '';

  // Mock booking data
  final List<Map<String, dynamic>> _allBookings = [
    {
      "id": 1,
      "booking_reference": "BK001234",
      "venue": {
        "id": 1,
        "name": "GOR Badminton Senayan",
        "image_url":
            "https://images.unsplash.com/photo-1544717297-fa95b6ee9643?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "location": "Jakarta Pusat",
      },
      "booking_date": "2025-08-25",
      "start_time": "2025-08-25T10:00:00",
      "end_time": "2025-08-25T12:00:00",
      "status": "confirmed",
      "total_amount": 120000.0,
      "court_number": "Court 1",
      "created_at": "2025-08-20T08:30:00",
    },
    {
      "id": 2,
      "booking_reference": "BK001235",
      "venue": {
        "id": 2,
        "name": "Badminton Arena Kelapa Gading",
        "image_url":
            "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "location": "Jakarta Utara",
      },
      "booking_date": "2025-08-22",
      "start_time": "2025-08-22T14:00:00",
      "end_time": "2025-08-22T16:00:00",
      "status": "completed",
      "total_amount": 100000.0,
      "court_number": "Court 3",
      "created_at": "2025-08-18T15:20:00",
    },
    {
      "id": 3,
      "booking_reference": "BK001236",
      "venue": {
        "id": 3,
        "name": "Sport Center Pondok Indah",
        "image_url":
            "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "location": "Jakarta Selatan",
      },
      "booking_date": "2025-08-26",
      "start_time": "2025-08-26T16:00:00",
      "end_time": "2025-08-26T18:00:00",
      "status": "pending payment",
      "total_amount": 150000.0,
      "court_number": "Court 2",
      "created_at": "2025-08-23T10:15:00",
    },
    {
      "id": 4,
      "booking_reference": "BK001237",
      "venue": {
        "id": 4,
        "name": "Badminton Club Menteng",
        "image_url":
            "https://images.unsplash.com/photo-1544717297-fa95b6ee9643?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "location": "Jakarta Pusat",
      },
      "booking_date": "2025-08-20",
      "start_time": "2025-08-20T09:00:00",
      "end_time": "2025-08-20T11:00:00",
      "status": "cancelled",
      "total_amount": 80000.0,
      "court_number": "Court 1",
      "created_at": "2025-08-15T12:45:00",
    },
    {
      "id": 5,
      "booking_reference": "BK001238",
      "venue": {
        "id": 5,
        "name": "Elite Badminton Center",
        "image_url":
            "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "location": "Jakarta Barat",
      },
      "booking_date": "2025-08-19",
      "start_time": "2025-08-19T18:00:00",
      "end_time": "2025-08-19T20:00:00",
      "status": "completed",
      "total_amount": 110000.0,
      "court_number": "Court 4",
      "created_at": "2025-08-14T09:30:00",
    },
  ];

  List<Map<String, dynamic>> get _filteredBookings {
    List<Map<String, dynamic>> filtered = _allBookings;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered.where((booking) {
            final venueName =
                (booking['venue'] as Map<String, dynamic>)['name'] as String;
            final bookingRef = booking['booking_reference'] as String;
            return venueName.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                bookingRef.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();
    }

    // Filter by status
    switch (_selectedTabIndex) {
      case 0: // Semua
        break;
      case 1: // Mendatang
        filtered =
            filtered.where((booking) {
              final status = booking['status'] as String;
              return status == 'confirmed' || status == 'pending payment';
            }).toList();
        break;
      case 2: // Selesai
        filtered =
            filtered
                .where((booking) => booking['status'] == 'completed')
                .toList();
        break;
      case 3: // Dibatalkan
        filtered =
            filtered
                .where((booking) => booking['status'] == 'cancelled')
                .toList();
        break;
    }

    // Sort by booking date (newest first)
    filtered.sort((a, b) {
      final dateA = DateTime.parse(a['booking_date'] as String);
      final dateB = DateTime.parse(b['booking_date'] as String);
      return dateB.compareTo(dateA);
    });

    return filtered;
  }

  String get _currentFilterName {
    const filterNames = ['Semua', 'Mendatang', 'Selesai', 'Dibatalkan'];
    return filterNames[_selectedTabIndex];
  }

  Future<void> _refreshBookings() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void _navigateToBookingDetail(Map<String, dynamic> booking) {
    // Navigate to booking detail screen
    Navigator.pushNamed(context, '/booking-detail-screen', arguments: booking);
  }

  void _handleCheckIn(Map<String, dynamic> booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Check-in berhasil untuk ${booking['booking_reference']}',
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _handleCancel(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Batalkan Booking'),
          content: Text(
            'Apakah Anda yakin ingin membatalkan booking ${booking['booking_reference']}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Booking ${booking['booking_reference']} berhasil dibatalkan',
                    ),
                    backgroundColor: AppTheme.lightTheme.colorScheme.error,
                  ),
                );
              },
              child: Text(
                'Ya, Batalkan',
                style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleReview(Map<String, dynamic> booking) {
    Navigator.pushNamed(context, '/review-screen', arguments: booking);
  }

  void _handleBookAgain(Map<String, dynamic> booking) {
    final venue = booking['venue'] as Map<String, dynamic>;
    Navigator.pushNamed(context, '/venue-detail-screen', arguments: venue);
  }

  void _navigateToSearch() {
    Navigator.pushNamed(context, '/home-screen');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredBookings = _filteredBookings;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Riwayat Booking',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: BookingSearchDelegate(
                  bookings: _allBookings,
                  onBookingSelected: _navigateToBookingDetail,
                ),
              );
            },
            icon: CustomIconWidget(
              iconName: 'search',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          IconButton(
            onPressed: () {
              // Show filter options
            },
            icon: CustomIconWidget(
              iconName: 'filter_list',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          BookingFilterTabs(
            selectedIndex: _selectedTabIndex,
            onTabChanged: _onTabChanged,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshBookings,
              color: AppTheme.lightTheme.colorScheme.primary,
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredBookings.isEmpty
                      ? EmptyBookingState(
                        filterType: _currentFilterName,
                        onSearchCourts: _navigateToSearch,
                      )
                      : ListView.builder(
                        padding: EdgeInsets.only(top: 1.h, bottom: 10.h),
                        itemCount: filteredBookings.length,
                        itemBuilder: (context, index) {
                          final booking = filteredBookings[index];
                          return BookingCard(
                            booking: booking,
                            onTap: () => _navigateToBookingDetail(booking),
                            onCheckIn: () => _handleCheckIn(booking),
                            onCancel: () => _handleCancel(booking),
                            onReview: () => _handleReview(booking),
                            onBookAgain: () => _handleBookAgain(booking),
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookingSearchDelegate extends SearchDelegate<Map<String, dynamic>?> {
  final List<Map<String, dynamic>> bookings;
  final Function(Map<String, dynamic>) onBookingSelected;

  BookingSearchDelegate({
    required this.bookings,
    required this.onBookingSelected,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: CustomIconWidget(
          iconName: 'clear',
          size: 24,
          color: AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: CustomIconWidget(
        iconName: 'arrow_back',
        size: 24,
        color: AppTheme.lightTheme.colorScheme.onSurface,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final filteredBookings =
        bookings.where((booking) {
          final venueName =
              (booking['venue'] as Map<String, dynamic>)['name'] as String;
          final bookingRef = booking['booking_reference'] as String;
          return venueName.toLowerCase().contains(query.toLowerCase()) ||
              bookingRef.toLowerCase().contains(query.toLowerCase());
        }).toList();

    if (filteredBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              size: 64,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 2.h),
            Text(
              'Tidak ada hasil untuk "$query"',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 1.h),
            Text(
              'Coba kata kunci lain atau kode booking',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredBookings.length,
      itemBuilder: (context, index) {
        final booking = filteredBookings[index];
        return BookingCard(
          booking: booking,
          onTap: () {
            close(context, booking);
            onBookingSelected(booking);
          },
        );
      },
    );
  }
}
