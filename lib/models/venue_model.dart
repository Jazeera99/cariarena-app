class Venue {
  final String id;
  final String name;
  final String address;
  final String city;
  final String? province; 

  Venue({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    this.province,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      province: json['province'] as String? ?? 'Tidak Ada Provinsi',
    );
  }
}
