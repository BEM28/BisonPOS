import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:bison_pos/providers/customer_provider.dart';
import 'package:bison_pos/screens/main_drawer.dart';

class CustomerManagementScreen extends StatelessWidget {
  const CustomerManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CRM & Pelanggan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showAddCustomerDialog(context),
          )
        ],
      ),
      drawer: const MainDrawer(),
      body: ListView.builder(
        itemCount: provider.customers.length,
        itemBuilder: (context, index) {
          final customer = provider.customers[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getTierColor(customer.tier),
                child: const Icon(Icons.person, color: Colors.white),
              ),
              title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${customer.phone} • Points: ${customer.loyaltyPoints}'),
              trailing: Chip(
                label: Text(customer.tier.name.toUpperCase()),
                backgroundColor: _getTierColor(customer.tier).withAlpha((255 * 0.2).toInt()),
              ),
              onTap: () {
                // Feature extension: open detail CRM
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Detail for ${customer.name} clicked')));
              },
            ),
          );
        },
      ),
    );
  }

  Color _getTierColor(MembershipTier tier) {
    switch (tier) {
      case MembershipTier.bronze:
        return Colors.brown;
      case MembershipTier.silver:
        return Colors.grey.shade400;
      case MembershipTier.gold:
        return Colors.amber;
      case MembershipTier.platinum:
        return Colors.blueGrey;
    }
  }

  void _showAddCustomerDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Pelanggan Baru'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: phoneCtrl,
                    decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
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
                  final newCustomer = Customer(
                    id: const Uuid().v4(),
                    name: nameCtrl.text,
                    phone: phoneCtrl.text,
                  );
                  Provider.of<CustomerProvider>(context, listen: false).addCustomer(newCustomer);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pelanggan ditambahkan')));
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
