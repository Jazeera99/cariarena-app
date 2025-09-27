import 'package:flutter/material.dart';

class Availability {
  final String id;
  final String fieldId;
  final DateTime date;
  final List<TimeSlot> timeSlots;
  final DateTime createdAt;
  final DateTime updatedAt;

  Availability({
    required this.id,
    required this.fieldId,
    required this.date,
    required this.timeSlots,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      id: json['id'],
      fieldId: json['field_id'],
      date: DateTime.parse(json['date']),
      timeSlots:
          (json['time_slots'] as List)
              .map((slot) => TimeSlot.fromJson(slot))
              .toList(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'field_id': fieldId,
      'date': date.toIso8601String(),
      'time_slots': timeSlots.map((slot) => slot.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  List<TimeSlot> get availableSlots =>
      timeSlots.where((slot) => slot.isAvailable).toList();

  List<TimeSlot> get bookedSlots =>
      timeSlots.where((slot) => !slot.isAvailable).toList();

  bool isTimeSlotAvailable(TimeOfDay startTime, TimeOfDay endTime) {
    for (final slot in timeSlots) {
      if (slot.startTime == startTime && slot.endTime == endTime) {
        return slot.isAvailable;
      }
    }
    return false;
  }
}

class TimeSlot {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final bool isAvailable;
  final String? reservationId;

  TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    this.reservationId,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: _timeFromString(json['start_time']),
      endTime: _timeFromString(json['end_time']),
      isAvailable: json['is_available'],
      reservationId: json['reservation_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_time': _timeToString(startTime),
      'end_time': _timeToString(endTime),
      'is_available': isAvailable,
      'reservation_id': reservationId,
    };
  }

  String get formattedTime {
    return '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')} - ${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
  }

  static TimeOfDay _timeFromString(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static String _timeToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Duration get duration {
    final start = startTime.hour * 60 + startTime.minute;
    final end = endTime.hour * 60 + endTime.minute;
    return Duration(minutes: end - start);
  }

  double get durationInHours => duration.inMinutes / 60.0;
}
