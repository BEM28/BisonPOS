import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:bison_pos/providers/auth_provider.dart';
import 'package:bison_pos/providers/attendance_provider.dart';
import 'package:bison_pos/screens/main_drawer.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    final attendanceProvider = Provider.of<AttendanceProvider>(context);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Absensi')),
        body: const Center(child: Text('Harap login terlebih dahulu')),
      );
    }

    final isClockedIn = attendanceProvider.isClockedIn(user.id);
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm');

    // Get today's records for the current user
    final today = DateTime.now();
    final userRecords = attendanceProvider.records.where((r) {
      return r.userId == user.id &&
             r.clockIn.year == today.year &&
             r.clockIn.month == today.month &&
             r.clockIn.day == today.day;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Absensi Karyawan'),
      ),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Icon(Icons.account_circle, size: 80, color: Colors.blue),
                    const SizedBox(height: 16),
                    Text(user.username, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('Role: ${user.role.name.toUpperCase()}', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 30),

                    // Mock face detection UI
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Area Deteksi Wajah', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isClockedIn ? Colors.red : Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          if (isClockedIn) {
                            attendanceProvider.clockOut(user.id);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil Clock Out')));
                          } else {
                            attendanceProvider.clockIn(user.id);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil Clock In')));
                          }
                        },
                        child: Text(isClockedIn ? 'CLOCK OUT' : 'CLOCK IN', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Riwayat Absensi Hari Ini', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: userRecords.isEmpty
                  ? const Center(child: Text('Belum ada data absensi hari ini'))
                  : ListView.builder(
                      itemCount: userRecords.length,
                      itemBuilder: (context, index) {
                        final record = userRecords[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.access_time),
                            title: Text('Clock In: ${dateFormatter.format(record.clockIn)}'),
                            subtitle: Text('Clock Out: ${record.clockOut != null ? dateFormatter.format(record.clockOut!) : 'Belum'}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
