class Field {
  final int id;
  final String? venueId;
  final String categoryId;
  final String name;
  final String? location;
  final String city;
  final String? province;
  final String fullAddress;
  final double? latitude;
  final double? longitude;
  final String? mapsUrl;
  final String description;
  final double pricePerHour;
  final String? imageUrl;
  final bool isAvailable;
  final String openingTime;
  final String closingTime;
  final List<dynamic> facilities;
  final List<dynamic> schedules;
  final double? averageRating;
  final List<String>? images;
  final List<dynamic>? categories;

  Field({
    required this.id,
    this.venueId,
    required this.categoryId,
    required this.name,
    this.location,
    required this.city,
    this.province,
    required this.fullAddress,
    this.latitude,
    this.longitude,
    required this.description,
    this.mapsUrl,
    required this.pricePerHour,
    this.imageUrl,
    required this.isAvailable,
    required this.openingTime,
    required this.closingTime,
    required this.facilities,
    required this.schedules,
    this.averageRating,
    this.images,
    this.categories,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'],
      venueId: json['venue_id'],
      categoryId: json['category_id'] ?? '',
      name: json['name'] ?? '',
      // PERBAIKAN: Tangani null untuk `location`
      location: json['location'],
      city: json['city'] ?? '',
      province: json['province'],
      fullAddress: json['full_address'] ?? '',
      description: json['description'] ?? '',
      // PERBAIKAN: Tangani null untuk `latitude` dan konversi ke double
      latitude: (json['latitude'] as num?)?.toDouble(),
      // PERBAIKAN: Tangani null untuk `longitude` dan konversi ke double
      longitude: (json['longitude'] as num?)?.toDouble(),
      // PERBAIKAN: Tangani null untuk `mapsUrl`
      mapsUrl: json['maps_url'],
      // PERBAIKAN: Tangani `pricePerHour` yang mungkin String
      pricePerHour:
          (json['price_per_hour'] is String)
              ? double.tryParse(json['price_per_hour']) ?? 0.0
              : (json['price_per_hour'] as num?)?.toDouble() ?? 0.0,
      // PERBAIKAN: Tangani null untuk `imageUrl`
      imageUrl: json['image_url'],
      isAvailable: json['is_available'] ?? false,
      openingTime: json['opening_time'] ?? '',
      closingTime: json['closing_time'] ?? '',
      facilities: json['facilities'] ?? [],
      schedules: json['schedules'] ?? [],
      averageRating: (json['average_rating'] as num?)?.toDouble(),
      // PERBAIKAN: Tangani `images` yang mungkin null
      images:
          (json['images'] != null)
              ? List<String>.from(json["images"].map((x) => x))
              : null,
      categories: json['categories'],
    );
  }
}
