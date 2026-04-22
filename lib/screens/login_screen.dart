import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bison_pos/models/user.dart';
import 'package:bison_pos/providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login POS')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Pilih Peran untuk Login:', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context, UserRole.admin, 'Admin User'),
              child: const Text('Login sebagai Admin'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _login(context, UserRole.manager, 'Manager User'),
              child: const Text('Login sebagai Manager'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _login(context, UserRole.kasir, 'Kasir User'),
              child: const Text('Login sebagai Kasir'),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
              child: const Text('Kembali'),
            )
          ],
        ),
      ),
    );
  }

  void _login(BuildContext context, UserRole role, String name) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    auth.login(User(id: DateTime.now().millisecondsSinceEpoch.toString(), username: name, role: role));
    Navigator.pushReplacementNamed(context, '/pos');
  }
}
