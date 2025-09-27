import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PromotionalCarouselWidget extends StatefulWidget {
  const PromotionalCarouselWidget({super.key});

  @override
  State<PromotionalCarouselWidget> createState() =>
      _PromotionalCarouselWidgetState();
}

class _PromotionalCarouselWidgetState extends State<PromotionalCarouselWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _promotions = [
    {
      "id": 1,
      "title": "Diskon 30% Hari Ini!",
      "subtitle": "Booking sekarang dan hemat lebih banyak",
      "discount": "30%",
      "imageUrl":
          "https://images.pexels.com/photos/3660204/pexels-photo-3660204.jpeg?auto=compress&cs=tinysrgb&w=800",
      "backgroundColor": AppTheme.lightTheme.colorScheme.secondary,
    },
    {
      "id": 2,
      "title": "Weekend Special",
      "subtitle": "Paket 3 jam hanya Rp 250.000",
      "discount": "25%",
      "imageUrl":
          "https://images.unsplash.com/photo-1544717297-fa95b6ee9643?auto=format&fit=crop&w=800&q=80",
      "backgroundColor": AppTheme.lightTheme.colorScheme.primary,
    },
    {
      "id": 3,
      "title": "Member Baru",
      "subtitle": "Gratis 1 jam untuk pendaftaran pertama",
      "discount": "FREE",
      "imageUrl":
          "https://images.pixabay.com/photos/2017/08/07/14/02/people-2604149_960_720.jpg",
      "backgroundColor": AppTheme.lightTheme.colorScheme.tertiary,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _nextPage();
        _startAutoSlide();
      }
    });
  }

  void _nextPage() {
    if (_currentPage < _promotions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _promotions.length,
              itemBuilder: (context, index) {
                final promotion = _promotions[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        (promotion["backgroundColor"] as Color).withValues(
                          alpha: 0.8,
                        ),
                        (promotion["backgroundColor"] as Color),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -10,
                        top: -10,
                        child: Container(
                          width: 25.w,
                          height: 25.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4.w,
                        top: 2.h,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            promotion["discount"] as String,
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                                  color: promotion["backgroundColor"] as Color,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              promotion["title"] as String,
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              promotion["subtitle"] as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                            ),
                            SizedBox(height: 2.h),
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to booking or promotion details
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor:
                                    promotion["backgroundColor"] as Color,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 1.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Text(
                                "Booking Sekarang",
                                style: AppTheme.lightTheme.textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _promotions.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                width: _currentPage == index ? 6.w : 2.w,
                height: 1.h,
                decoration: BoxDecoration(
                  color:
                      _currentPage == index
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
