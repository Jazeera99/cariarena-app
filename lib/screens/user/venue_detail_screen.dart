import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

import '../../core/app_export.dart';
import '../../widgets/venue_detail/image_gallery_widget.dart';
import '../../widgets/venue_detail/operating_hours_widget.dart';
import '../../widgets/venue_detail/reviews_widget.dart';
import '../../widgets/venue_detail/amenities_widget.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../services/api_service.dart';

class VenueDetailScreen extends StatefulWidget {
  final int fieldId;

  const VenueDetailScreen({super.key, required this.fieldId});

  @override
  State<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  bool _isBookmarked = false;
  Map<String, dynamic>? _fieldData;
  bool _isLoading = true;
  String? _errorMessage;
  final apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchVenueDetails();
  }

  String _formatPrice(dynamic price) {
    // Tangani harga yang berupa string (seperti dari API JSON)
    if (price is String) {
      // Coba parsing string ke double.
      final parsedPrice = double.tryParse(price);
      if (parsedPrice != null) {
        final formatter = NumberFormat.decimalPattern('id_ID');
        return formatter.format(parsedPrice);
      }
    }
    // Tangani harga yang sudah berupa angka (int atau double)
    else if (price is num) {
      final formatter = NumberFormat.decimalPattern('id_ID');
      return formatter.format(price);
    }

    // Tangani kasus null atau tipe data lain yang tidak valid
    return "0";
  }

  Future<void> _fetchVenueDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final Map<String, dynamic> rawResponse = await apiService.get(
        '/fields/${widget.fieldId}',
      );

      final data = rawResponse['data'];

      // Pastikan 'data' tidak null setelah diambil dari rawResponse,
      // terutama jika API bisa mengembalikan 'data': null
      if (data != null && data is Map<String, dynamic>) {
        setState(() {
          _fieldData = data;
          _isLoading = false;
        });
      } else {
        // Jika 'data' null atau bukan Map, anggap sebagai error format API
        setState(() {
          _errorMessage = 'Format data API tidak valid atau data kosong.';
          _isLoading = false;
        });
      }
    } catch (e) {
      // Semua Exception (gagal loading, status non-200, error jaringan, format salah)
      // sekarang ditangkap di blok catch ini.
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _fetchVenueDetails();
    if (_errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data venue berhasil diperbarui'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked
              ? 'Venue ditambahkan ke bookmark'
              : 'Venue dihapus dari bookmark',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareVenue() {
    if (_fieldData != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berbagi ${_fieldData!['name']}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _navigateToBooking() async {
    if (_fieldData == null) return;
    setState(() {
      _isLoading = true;
    });

    try {
      // Akses AuthProvider dengan listen: true agar rebuild jika user berubah
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (authProvider.user != null) {
        // Pengguna sudah login, langsung navigasi ke halaman booking
        setState(() {
          _isLoading = false;
        });
        Navigator.pushNamed(
          context,
          '/booking-calendar-screen',
          arguments: widget.fieldId,
        );
      } else {
        // Pengguna belum login, navigasi ke halaman login dan tunggu hasilnya
        setState(() {
          _isLoading = false;
        });
        final result = await Navigator.pushNamed(
          context,
          AppRoutes.loginScreen,
        );

        // Jika hasil dari halaman login menunjukkan login berhasil
        if (result == true) {
          // Langsung navigasi ke halaman booking setelah login berhasil
          Navigator.pushNamed(
            context,
            '/booking-calendar-screen',
            arguments: widget.fieldId,
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saat navigasi: $e')));
    }
  }

  void _openDirections() {
    if (_fieldData != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Membuka petunjuk arah ke ${_fieldData!['maps_url']}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildBottomBookingBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rp ${_formatPrice(_fieldData?['price_per_hour'])}/jam',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Harga mulai',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 4.w),
            ElevatedButton(
              onPressed: _navigateToBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.h),
                ),
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
              ),
              child: const Text('Pesan Sekarang'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName:
                            'sad_face', // Menggunakan nama ikon yang benar
                        size: 15.w,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Oops, ada kesalahan!',
                        style: AppTheme.lightTheme.textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        _errorMessage!,
                        style: AppTheme.lightTheme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      ElevatedButton.icon(
                        onPressed: _refreshData,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.primary,
                          foregroundColor:
                              AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : RefreshIndicator(
                onRefresh: _refreshData,
                child: CustomScrollView(
                  slivers: [
                    _buildSliverAppBar(),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildVenueInfo(),
                          VenueAmenitiesWidget(
                            amenities:
                                (_fieldData?['facilities'] as List<dynamic>?)
                                    ?.cast<Map<String, dynamic>>() ??
                                [],
                          ),
                          VenueOperatingHoursWidget(
                            operatingHours: {
                              'opening_time':
                                  _fieldData?['opening_time'] ?? 'N/A',
                              'closing_time':
                                  _fieldData?['closing_time'] ?? 'N/A',
                            },
                          ),
                          VenueReviewsWidget(
                            averageRating:
                                (_fieldData!['average_rating'] as num?)
                                    ?.toDouble() ??
                                0.0,
                            totalReviews: _fieldData!['reviews']?.length ?? 0,
                            recentReviews:
                                (_fieldData!['reviews'] as List<dynamic>?)
                                    ?.cast<Map<String, dynamic>>() ??
                                [],
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      bottomNavigationBar:
          _isLoading || _errorMessage != null ? null : _buildBottomBookingBar(),
    );
  }

  Widget _buildSliverAppBar() {
    if (_fieldData == null) {
      return const SliverAppBar();
    }

    final List<String> images =
        (_fieldData!['images'] as List<dynamic>?)?.cast<String>() ?? [];

    if (images.isEmpty) {
      return SliverAppBar(
        expandedHeight: 35.h,
        floating: false,
        pinned: true,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        leading: Container(
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface.withAlpha(230),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const CustomIconWidget(
              iconName: 'arrow_back',
              color: Colors.black,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface.withAlpha(230),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const CustomIconWidget(
                iconName: 'share',
                color: Colors.black,
                size: 24,
              ),
              onPressed: _shareVenue,
            ),
          ),
        ],
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'image_not_supported',
                    size: 15.w,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Tidak Ada Gambar',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final List<String> safeImages = images.isEmpty ? [''] : images;

    return SliverAppBar(
      expandedHeight: 35.h,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      leading: Container(
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface.withAlpha(230),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const CustomIconWidget(
            iconName: 'arrow_back',
            color: Colors.black,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface.withAlpha(230),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const CustomIconWidget(
              iconName: 'share',
              color: Colors.black,
              size: 24,
            ),
            onPressed: _shareVenue,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: VenueImageGalleryWidget(
          images: safeImages,
          venueName:
              _fieldData!['name'] as String? ?? 'Nama Venue Tidak Tersedia',
        ),
      ),
    );
  }

  Widget _buildVenueInfo() {
    if (_fieldData == null) {
      return Container();
    }

    final String venueName =
        _fieldData?['name'] as String? ?? 'Nama Tidak Tersedia';
    final String fullAddress =
        _fieldData?['full_address'] as String? ?? 'Alamat Tidak Tersedia';
    final num averageRating = _fieldData?['average_rating'] as num? ?? 0.0;
    final int reviewCount =
        (_fieldData?['reviews'] as List<dynamic>?)?.length ?? 0;
    final String description =
        _fieldData?['description'] as String? ?? 'Deskripsi tidak tersedia.';

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            venueName,
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 18,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  fullAddress,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.getWarningColor(true).withAlpha(25),
                  borderRadius: BorderRadius.circular(1.h),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      color: AppTheme.getWarningColor(true),
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: AppTheme.lightTheme.textTheme.labelMedium
                          ?.copyWith(
                            color: AppTheme.getWarningColor(true),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                '($reviewCount ulasan)',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _toggleBookmark,
                child: Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color:
                        _isBookmarked
                            ? AppTheme.lightTheme.colorScheme.primary.withAlpha(
                              25,
                            )
                            : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(1.h),
                    border: Border.all(
                      color:
                          _isBookmarked
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: _isBookmarked ? 'bookmark' : 'bookmark_border',
                    color:
                        _isBookmarked
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            description,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
