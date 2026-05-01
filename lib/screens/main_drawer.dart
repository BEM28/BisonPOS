import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bison_pos/models/user.dart';
import 'package:bison_pos/providers/auth_provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;

    final isAdminOrManager = user?.role == UserRole.admin || user?.role == UserRole.manager;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Bison POS',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'User: ${user?.username ?? 'Guest'}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'Role: ${user?.role.name.toUpperCase() ?? ''}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.fingerprint),
            title: const Text('Absensi Karyawan'),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)?.settings.name != '/attendance') {
                 Navigator.pushReplacementNamed(context, '/attendance');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.point_of_sale),
            title: const Text('POS Kasir'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              if (ModalRoute.of(context)?.settings.name != '/pos') {
                 Navigator.pushReplacementNamed(context, '/pos');
              }
            },
          ),
          if (isAdminOrManager) ...[
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard Laporan'),
              onTap: () {
                Navigator.pop(context);
                if (ModalRoute.of(context)?.settings.name != '/dashboard') {
                   Navigator.pushReplacementNamed(context, '/dashboard');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Manajemen Produk'),
              onTap: () {
                Navigator.pop(context);
                if (ModalRoute.of(context)?.settings.name != '/manage_products') {
                   Navigator.pushReplacementNamed(context, '/manage_products');
                }
              },
            ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
