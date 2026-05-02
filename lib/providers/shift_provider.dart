import 'package:flutter/material.dart';

class Shift {
  final String id;
  final String employeeName;
  final DateTime startTime;
  final DateTime endTime;
  final String role;

  Shift({
    required this.id,
    required this.employeeName,
    required this.startTime,
    required this.endTime,
    required this.role,
  });
}

class ShiftProvider extends ChangeNotifier {
  final List<Shift> _shifts = [
    Shift(
      id: 's1',
      employeeName: 'Kasir Pagi',
      startTime: DateTime.now().copyWith(hour: 8, minute: 0),
      endTime: DateTime.now().copyWith(hour: 16, minute: 0),
      role: 'Kasir',
    ),
    Shift(
      id: 's2',
      employeeName: 'Manager Operasional',
      startTime: DateTime.now().copyWith(hour: 10, minute: 0),
      endTime: DateTime.now().copyWith(hour: 18, minute: 0),
      role: 'Manager',
    ),
  ];

  List<Shift> get shifts => _shifts;

  void addShift(Shift shift) {
    _shifts.add(shift);
    notifyListeners();
  }
}
