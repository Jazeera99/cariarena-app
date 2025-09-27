import 'package:flutter/foundation.dart';
import '../models/field_model.dart';

class FieldProvider with ChangeNotifier {
  List<Field> _fields = [];
  List<Field> _userFields = [];
  bool _isLoading = false;

  List<Field> get fields => _fields;
  List<Field> get userFields => _userFields;
  bool get isLoading => _isLoading;

  FieldProvider() {
    // Initialize with dummy data
    _loadDummyData();
  }

  void _loadDummyData() {
    _fields = [
      Field(
        id: 1,
        categoryId: '',
        name: 'Lapangan Futsal Merdeka',
        description:
            'Lapangan futsal dengan rumput sintetis berkualitas tinggi',
        imageUrl: 'https://picsum.photos/400/300?random=1',
        pricePerHour: 150000,
        location: 'Jakarta Pusat',
        city: '',
        fullAddress: '',
        isAvailable: true,
        openingTime: '',
        closingTime: '',
        facilities: ['Parkir', 'Toilet', 'Mushola', 'Kantin'],
        schedules: [],
        averageRating: 4.5,
        images: null,
        categories: null,
      ),
      Field(
        id: 2,
        categoryId: '',
        name: 'Lapangan Basket Senayan',
        description: 'Lapangan basket standar internasional',
        imageUrl: 'https://picsum.photos/400/300?random=2',
        pricePerHour: 200000,
        location: 'Jakarta Selatan',
        city: '',
        fullAddress: '',
        isAvailable: true,
        openingTime: '',
        closingTime: '',
        facilities: ['Parkir', 'Toilet', 'Loker', 'Kafe'],
        schedules: [],
        averageRating: 4.8,
        images: null,
        categories: null,
      ),
      Field(
        id: 3,
        categoryId: '',
        name: 'Lapangan Badminton GOR Bulutangkis',
        description: 'Lapangan badminton dengan flooring profesional',
        imageUrl: 'https://picsum.photos/400/300?random=3',
        pricePerHour: 80000,
        location: 'Jakarta Timur',
        city: '',
        fullAddress: '',
        isAvailable: true,
        openingTime: '',
        closingTime: '',
        facilities: ['Parkir', 'Toilet', 'AC', 'Drinking Water'],
        schedules: [],
        averageRating: 4.3,
        images: null,
        categories: null,
      ),
      Field(
        id: 4,
        categoryId: '',
        name: 'Lapangan Tenis Kemayoran',
        description: 'Lapangan tenis dengan permukaan acrylic',
        imageUrl: 'https://picsum.photos/400/300?random=4',
        pricePerHour: 250000,
        location: 'Jakarta Utara',
        city: '',
        fullAddress: '',
        isAvailable: true,
        openingTime: '',
        closingTime: '',
        facilities: ['Parkir', 'Toilet', 'Cafe', 'Pro Shop'],
        schedules: [],
        averageRating: 4.6,
        images: null,
        categories: null,
      ),
    ];

    _userFields = [
      Field(
        id: 5,
        categoryId: '',
        name: 'Lapangan Futsal Saya',
        description: 'Lapangan futsal milik sendiri',
        imageUrl: 'https://picsum.photos/400/300?random=5',
        pricePerHour: 120000,
        location: 'Jakarta Barat',
        city: '',
        fullAddress: '',
        isAvailable: true,
        openingTime: '',
        closingTime: '',
        facilities: ['Parkir', 'Toilet', 'Mushola'],
        schedules: [],
        averageRating: 4.2,
        images: null,
        categories: null,
      ),
    ];
  }

  Future<void> fetchFields() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addField(Field field) async {
    _userFields.add(field);
    notifyListeners();
  }

  Future<void> updateField(Field field) async {
    final index = _userFields.indexWhere((f) => f.id == field.id);
    if (index != -1) {
      _userFields[index] = field;
      notifyListeners();
    }
  }

  Future<void> deleteField(String fieldId) async {
    _userFields.removeWhere((field) => field.id == fieldId);
    notifyListeners();
  }
}
