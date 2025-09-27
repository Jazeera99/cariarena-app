class Review {
  final String id;
  final String userId;
  final String fieldId;
  final String venueId;
  final String reservationId;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userAvatar;
  final String userName;

  Review({
    required this.id,
    required this.userId,
    required this.fieldId,
    required this.venueId,
    required this.reservationId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    this.userAvatar,
    required this.userName,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['user_id'],
      fieldId: json['field_id'],
      venueId: json['venue_id'],
      reservationId: json['reservation_id'],
      rating: json['rating'].toDouble(),
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      userAvatar: json['user_avatar'],
      userName: json['user_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'field_id': fieldId,
      'venue_id': venueId,
      'reservation_id': reservationId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user_avatar': userAvatar,
      'user_name': userName,
    };
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years tahun yang lalu';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months bulan yang lalu';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }
}
