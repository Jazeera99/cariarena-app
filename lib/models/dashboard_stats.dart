class DashboardStats {
  final int totalBookings;
  final double totalSpent;
  final int upcomingBookings;
  final double rating;

  DashboardStats({
    required this.totalBookings,
    required this.totalSpent,
    required this.upcomingBookings,
    required this.rating,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalBookings: json['total_bookings'] as int,
      totalSpent: (json['total_spent'] as num).toDouble(),
      upcomingBookings: json['upcoming_bookings'] as int,
      rating: (json['average_rating'] as num).toDouble(),
    );
  }
}
