import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:bison_pos/providers/shift_provider.dart';
import 'package:bison_pos/screens/main_drawer.dart';

class ShiftScheduleScreen extends StatelessWidget {
  const ShiftScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShiftProvider>(context);
    final timeFormatter = DateFormat('HH:mm');
    final dateFormatter = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Karyawan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddShiftDialog(context),
          )
        ],
      ),
      drawer: const MainDrawer(),
      body: ListView.builder(
        itemCount: provider.shifts.length,
        itemBuilder: (context, index) {
          final shift = provider.shifts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.schedule, color: Colors.blue),
              title: Text(shift.employeeName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${dateFormatter.format(shift.startTime)}\n${timeFormatter.format(shift.startTime)} - ${timeFormatter.format(shift.endTime)}'),
              trailing: Chip(label: Text(shift.role)),
            ),
          );
        },
      ),
    );
  }

  void _showAddShiftDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final roleCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Jadwal Shift'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nama Karyawan'),
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: roleCtrl,
                    decoration: const InputDecoration(labelText: 'Role (Kasir/Manager/dll)'),
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 10),
                  const Text('Waktu Shift: Mockup (Hari ini 08:00 - 16:00)', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('BATAL'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newShift = Shift(
                    id: const Uuid().v4(),
                    employeeName: nameCtrl.text,
                    role: roleCtrl.text,
                    startTime: DateTime.now().copyWith(hour: 8, minute: 0),
                    endTime: DateTime.now().copyWith(hour: 16, minute: 0),
                  );
                  Provider.of<ShiftProvider>(context, listen: false).addShift(newShift);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Jadwal ditambahkan')));
                }
              },
              child: const Text('SIMPAN'),
            )
          ],
        );
      }
    );
  }
}
