import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:bison_pos/models/product.dart';
import 'package:bison_pos/providers/product_provider.dart';
import 'package:bison_pos/screens/main_drawer.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddProductDialog(context),
          )
        ],
      ),
      drawer: const MainDrawer(),
      body: ListView.builder(
        itemCount: provider.products.length,
        itemBuilder: (context, index) {
          final product = provider.products[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.inventory, size: 40),
              title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${product.category} • Stok: ${product.totalStock}'),
              trailing: Text(currencyFormatter.format(product.sellPrice)),
            ),
          );
        },
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final categoryCtrl = TextEditingController();
    final sellPriceCtrl = TextEditingController();
    final costPriceCtrl = TextEditingController();
    final stockCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Produk Baru'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nama Produk'),
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: categoryCtrl,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: sellPriceCtrl,
                    decoration: const InputDecoration(labelText: 'Harga Jual'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: costPriceCtrl,
                    decoration: const InputDecoration(labelText: 'Harga Modal'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: stockCtrl,
                    decoration: const InputDecoration(labelText: 'Stok Awal'),
                    keyboardType: TextInputType.number,
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
                  final newProduct = Product(
                    id: const Uuid().v4(),
                    name: nameCtrl.text,
                    category: categoryCtrl.text,
                    sellPrice: double.parse(sellPriceCtrl.text),
                    costPrice: double.parse(costPriceCtrl.text),
                    baseStock: int.parse(stockCtrl.text),
                  );
                  Provider.of<ProductProvider>(context, listen: false).addProduct(newProduct);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produk berhasil ditambahkan')));
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
