import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_export.dart';

class FilterModalWidget extends StatefulWidget {
  final List<String> allFacilities;
  final List<String> allCategories;
  final List<String> initialSelectedFacilities;
  final List<String> initialSelectedCategories;

  const FilterModalWidget({
    super.key,
    required this.allFacilities,
    required this.allCategories,
    required this.initialSelectedFacilities,
    required this.initialSelectedCategories,
  });

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  late List<String> _selectedFacilities;
  late List<String> _selectedCategories;

  @override
  void initState() {
    super.initState();
    _selectedFacilities = List.from(widget.initialSelectedFacilities);
    _selectedCategories = List.from(widget.initialSelectedCategories);
  }

  void _onFacilityChipSelected(String facility, bool isSelected) {
    setState(() {
      if (isSelected) {
        if (!_selectedFacilities.contains(facility)) {
          _selectedFacilities.add(facility);
        }
      } else {
        _selectedFacilities.remove(facility);
      }
    });
  }

  void _onCategoryChipSelected(String category, bool isSelected) {
    setState(() {
      if (isSelected) {
        if (!_selectedCategories.contains(category)) {
          _selectedCategories.add(category);
        }
      } else {
        _selectedCategories.remove(category);
      }
    });
  }

  void _applyFilters() {
    Navigator.of(context).pop({
      'facilities': _selectedFacilities,
      'categories': _selectedCategories,
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedFacilities.clear();
      _selectedCategories.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filter Pencarian",
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      size: 20.sp,
                      color: AppTheme.lightTheme.colorScheme.onSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Text(
                "Fasilitas",
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children:
                    widget.allFacilities.map((facility) {
                      final isSelected = _selectedFacilities.contains(facility);
                      return ChoiceChip(
                        label: Text(facility),
                        selected: isSelected,
                        selectedColor: AppTheme.lightTheme.colorScheme.primary,
                        backgroundColor:
                            isSelected
                                ? null
                                : Colors
                                    .lightGreen[100], // Background hijau muda jika belum dipilih
                        labelStyle: TextStyle(
                          color:
                              isSelected
                                  ? Colors.white
                                  : Colors
                                      .black, // Teks hitam jika belum dipilih
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide.none,
                        ),
                        onSelected: (isSelected) {
                          _onFacilityChipSelected(facility, isSelected);
                        },
                      );
                    }).toList(),
              ),
              SizedBox(height: 3.h),
              Text(
                "Kategori",
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children:
                    widget.allCategories.map((category) {
                      final isSelected = _selectedCategories.contains(category);
                      return ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        selectedColor: AppTheme.lightTheme.colorScheme.primary,
                        backgroundColor:
                            isSelected
                                ? null
                                : Colors
                                    .lightGreen[100], // Background hijau muda jika belum dipilih
                        labelStyle: TextStyle(
                          color:
                              isSelected
                                  ? Colors.white
                                  : Colors
                                      .black, // Teks hitam jika belum dipilih
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide.none,
                        ),
                        onSelected: (isSelected) {
                          _onCategoryChipSelected(category, isSelected);
                        },
                      );
                    }).toList(),
              ),
              SizedBox(height: 5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetFilters,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                      ),
                      child: Text(
                        "Reset",
                        style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                      ),
                      child: Text(
                        "Terapkan",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
