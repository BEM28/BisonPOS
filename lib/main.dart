import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bison_pos/providers/auth_provider.dart';
import 'package:bison_pos/providers/product_provider.dart';
import 'package:bison_pos/providers/cart_provider.dart';
import 'package:bison_pos/providers/order_provider.dart';
import 'package:bison_pos/screens/login_screen.dart';
import 'package:bison_pos/screens/pos_home_screen.dart';
import 'package:bison_pos/screens/customer_menu_screen.dart';

void main() {
  runApp(const BisonPosApp());
}

class BisonPosApp extends StatelessWidget {
  const BisonPosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProxyProvider<ProductProvider, OrderProvider>(
          create: (context) => OrderProvider(Provider.of<ProductProvider>(context, listen: false)),
          update: (context, productProvider, previous) => previous ?? OrderProvider(productProvider),
        ),
      ],
      child: MaterialApp(
        title: 'Bison POS',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const InitialRoutingScreen(),
          '/login': (context) => const LoginScreen(),
          '/pos': (context) => const PosHomeScreen(),
          '/customer': (context) => const CustomerMenuScreen(),
        },
      ),
    );
  }
}

class InitialRoutingScreen extends StatelessWidget {
  const InitialRoutingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // For demo purposes, we will provide two buttons to either go to POS or Customer App
    return Scaffold(
      appBar: AppBar(title: const Text('Bison POS Selection')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Login Staff (POS)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/customer'),
              child: const Text('Pelanggan (Scan to Order)'),
            ),
          ],
        ),
      ),
    );
  }
}
