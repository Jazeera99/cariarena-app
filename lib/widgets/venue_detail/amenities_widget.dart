// Lokasi: lib/widgets/venue_detail/amenities_widget.dart

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';

class VenueAmenitiesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> amenities;

  const VenueAmenitiesWidget({super.key, required this.amenities});

  @override
  Widget build(BuildContext context) {
    if (amenities.isEmpty) {
      return Container();
    }

    final Map<String, IconData> amenityIcons = {
      'parking area': Icons.local_parking,
      'toilet': Icons.wc,
      'gallon of water': Icons.local_drink,
      'cafeteria': Icons.restaurant,
      'waiting area': Icons.chair,
      'meeting room': Icons.meeting_room,
      'ac': Icons.ac_unit,
      'musholla': Icons.mosque,
      'grandstand': Icons.stadium,
      'wifi': Icons.wifi,
    };

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fasilitas',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  amenities.map((amenity) {
                    final String amenityName =
                        (amenity['name'] as String? ?? 'N/A').toLowerCase();
                    final IconData iconData =
                        amenityIcons[amenityName] ?? Icons.help_outline;

                    return Padding(
                      padding: EdgeInsets.only(right: 2.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color:
                              AppTheme.lightTheme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(2.h),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              iconData,
                              color:
                                  AppTheme
                                      .lightTheme
                                      .colorScheme
                                      .onPrimaryContainer,
                              size: 18,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              amenityName,
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                    color:
                                        AppTheme
                                            .lightTheme
                                            .colorScheme
                                            .onPrimaryContainer,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
