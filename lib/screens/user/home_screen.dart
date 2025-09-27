import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../core/app_export.dart';
import '../../services/api_service.dart';
import '../../models/field_model.dart';
import '../../widgets/home_screen/bottom_navigation_widget.dart';
import '../../widgets/home_screen/empty_state_widget.dart';
import '../../widgets/home_screen/filter_chips_widget.dart';
import '../../widgets/home_screen/venue_card_widget.dart';
import '../../widgets/home_screen/filter_widget.dart';
import '../../widgets/home_screen/search_header_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final apiService = ApiService();
  bool _isLoading = false;
  String _selectedFilter = "Terdekat";
  List<Map<String, dynamic>> _venues = [];
  List<Map<String, dynamic>> _filteredVenues = [];
  bool _showEmptyState = false;

  List<String> _selectedFacilities = [];
  List<String> _selectedCategories = [];
  List<String> _allFacilities = [];
  List<String> _allCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchVenues();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Implementasi load more jika pakai pagination API
  }

  String _formatPrice(dynamic price) {
    if (price == null) {
      return "Rp 0";
    }
    // Menggunakan NumberFormat untuk memformat angka dengan pemisah titik
    // dan tanpa desimal.
    final formatter = NumberFormat.decimalPattern('id_ID');
    return "Rp ${formatter.format(price)}";
  }

  Future<void> _fetchVenues() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fields = await apiService.getFields();

      Set<String> facilitiesSet = {};
      Set<String> categoriesSet = {};

      _venues =
          fields.map<Map<String, dynamic>>((field) {
            // PERBAIKAN: Mengambil nama fasilitas dari list objek
            final venueFacilities =
                (field.facilities as List? ?? [])
                    .map((f) => f['name'] as String)
                    .toList();

            // PERBAIKAN: Mengambil nama kategori dari list objek
            final venueCategories =
                (field.categories ?? [])
                    .map((c) => c['name'] as String)
                    .toList();

            facilitiesSet.addAll(venueFacilities);
            categoriesSet.addAll(venueCategories);

            String imageUrl =
                "https://via.placeholder.com/400x200?text=No+Image";
            if (field.images != null && field.images!.isNotEmpty) {
              imageUrl = field.images![0];
            }

            return {
              "id": field.id ?? 0,
              "name": field.name ?? "-",
              "location": field.city ?? "-",
              "price": _formatPrice(field.pricePerHour),
              "rating": field.averageRating ?? 0.0,
              "distance": 0.0,
              "operatingHours":
                  (field.closingTime != null)
                      ? "${field.openingTime.substring(0, 5)} - ${field.closingTime.substring(0, 5)}"
                      : "-",
              "imageUrl": imageUrl,
              "isBookmarked": false,
              "isAvailable": field.isAvailable ?? true,
              "facilities": venueFacilities,
              "categories": venueCategories,
            };
          }).toList();

      _allFacilities = facilitiesSet.toList();
      _allCategories = categoriesSet.toList();

      _applyFilter(_selectedFilter);
      setState(() {
        _isLoading = false;
        _showEmptyState = _filteredVenues.isEmpty;
      });
      print('Venues fetched successfully!');
    } catch (e) {
      setState(() {
        _filteredVenues = List.from(_venues);
        _isLoading = false;
        _showEmptyState = true;
      });
      print('Error fetch venues: $e');
    }
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      List<Map<String, dynamic>> temp = List.from(_venues);

      switch (filter) {
        case "Terdekat":
          temp.sort(
            (a, b) =>
                (a["distance"] as double).compareTo(b["distance"] as double),
          );
          break;
        case "Harga":
          temp.sort((a, b) {
            final priceA =
                int.tryParse(
                  (a["price"] as String).replaceAll(RegExp(r'[^\d]'), ''),
                ) ??
                0;
            final priceB =
                int.tryParse(
                  (b["price"] as String).replaceAll(RegExp(r'[^\d]'), ''),
                ) ??
                0;
            return priceA.compareTo(priceB);
          });
          break;
        case "Rating":
          temp.sort(
            (a, b) => (b["rating"] as double).compareTo(a["rating"] as double),
          );
          break;
        case "Tersedia":
          temp = temp.where((venue) => venue["isAvailable"] == true).toList();
          break;
        default:
          break;
      }
      _filterByFacilitesAndCategories(temp);
    });
  }

  void _filterByFacilitesAndCategories(
    List<Map<String, dynamic>> venuesToFilter,
  ) {
    List<Map<String, dynamic>> temp = List.from(venuesToFilter);
    if (_selectedFacilities.isNotEmpty || _selectedCategories.isNotEmpty) {
      temp =
          temp.where((venue) {
            final venueFacilities = List<String>.from(
              venue['facilities'] ?? [],
            );
            final venueCategories = List<String>.from(
              venue['categories'] ?? [],
            );

            final facilitiesMatch =
                _selectedFacilities.isEmpty ||
                _selectedFacilities.every((f) => venueFacilities.contains(f));
            final categoriesMatch =
                _selectedCategories.isEmpty ||
                _selectedCategories.every((c) => venueCategories.contains(c));

            return facilitiesMatch && categoriesMatch;
          }).toList();
    }

    setState(() {
      _filteredVenues = temp;
      _showEmptyState = _filteredVenues.isEmpty;
    });
  }

  void _showFilterModal() async {
    final result = await showDialog(
      context: context,
      builder:
          (context) => FilterModalWidget(
            allFacilities: _allFacilities,
            allCategories: _allCategories,
            initialSelectedFacilities: _selectedFacilities,
            initialSelectedCategories: _selectedCategories,
          ),
    );

    if (result != null) {
      setState(() {
        _selectedFacilities = List.from(result['facilities']);
        _selectedCategories = List.from(result['categories']);
      });
      _filterByFacilitesAndCategories(_venues);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CariArena",
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SearchAndFilterWidget(onFilterTap: _showFilterModal),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 2.h)),
          SliverToBoxAdapter(
            child: FilterChipsWidget(onFilterSelected: _applyFilter),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 2.h)),
          _isLoading
              ? SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
              : _showEmptyState
              ? SliverToBoxAdapter(child: const EmptyStateWidget())
              : SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final venue = _filteredVenues[index];
                  return VenueCardWidget(
                    venue: venue,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/venue-detail-screen',
                        arguments: venue['id'] as int,
                      );
                    },
                    onBookmarkTap: () {},
                    onShareTap: () {},
                    onDirectionsTap: () {},
                  );
                }, childCount: _filteredVenues.length),
              ),
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),
        ],
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.bookingHistory);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.profileScreen);
              break;
          }
        },
      ),
    );
  }
}
