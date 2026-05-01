import 'package:flutter/material.dart';

class AttendanceRecord {
  final String userId;
  final DateTime clockIn;
  final DateTime? clockOut;

  AttendanceRecord({
    required this.userId,
    required this.clockIn,
    this.clockOut,
  });

  AttendanceRecord copyWith({
    String? userId,
    DateTime? clockIn,
    DateTime? clockOut,
  }) {
    return AttendanceRecord(
      userId: userId ?? this.userId,
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
    );
  }
}

class AttendanceProvider extends ChangeNotifier {
  final List<AttendanceRecord> _records = [];

  List<AttendanceRecord> get records => _records;

  bool isClockedIn(String userId) {
    try {
      final lastRecord = _records.lastWhere((r) => r.userId == userId);
      return lastRecord.clockOut == null;
    } catch (e) {
      return false;
    }
  }

  void clockIn(String userId) {
    if (!isClockedIn(userId)) {
      _records.add(AttendanceRecord(userId: userId, clockIn: DateTime.now()));
      notifyListeners();
    }
  }

  void clockOut(String userId) {
    if (isClockedIn(userId)) {
      final index = _records.lastIndexWhere((r) => r.userId == userId);
      if (index != -1) {
        _records[index] = _records[index].copyWith(clockOut: DateTime.now());
        notifyListeners();
      }
    }
  }
}
