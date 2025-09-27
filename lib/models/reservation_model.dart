class Reservation {
  final int id;
  final String userId; // uuid
  final int fieldId;
  final DateTime startTime;
  final DateTime endTime;
  final double subTotal;
  final double serviceFee;
  final double finalAmount;
  final String status; // pending, paid, canceled, completed
  final String? specialRequests;
  final List<String>? timeSlots;
  final DateTime? paymentDeadline;
  final DateTime createdAt;
  final DateTime updatedAt;

  Reservation({
    required this.id,
    required this.userId,
    required this.fieldId,
    required this.startTime,
    required this.endTime,
    required this.subTotal,
    required this.serviceFee,
    required this.finalAmount,
    required this.status,
    this.specialRequests,
    this.timeSlots,
    this.paymentDeadline,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      fieldId: json['field_id'] as int,
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      subTotal: (json['sub_total'] as num).toDouble(),
      serviceFee: (json['service_fee'] ?? 0).toDouble(),
      finalAmount: (json['final_amount'] as num).toDouble(),
      status: json['status'] as String,
      specialRequests: json['special_requests'] as String?,
      timeSlots:
          json['time_slots'] != null
              ? List<String>.from(json['time_slots'])
              : null,
      paymentDeadline:
          json['payment_deadline'] != null
              ? DateTime.parse(json['payment_deadline'])
              : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'field_id': fieldId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'sub_total': subTotal,
      'service_fee': serviceFee,
      'final_amount': finalAmount,
      'status': status,
      'special_requests': specialRequests,
      'time_slots': timeSlots,
      'payment_deadline': paymentDeadline?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
