import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:bison_pos/providers/inventory_provider.dart';
import 'package:bison_pos/screens/main_drawer.dart';

class SupplyChainScreen extends StatelessWidget {
  const SupplyChainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InventoryProvider>(context);
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supply Chain & PO'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () => _showCreatePODialog(context),
          )
        ],
      ),
      drawer: const MainDrawer(),
      body: ListView.builder(
        itemCount: provider.purchaseOrders.length,
        itemBuilder: (context, index) {
          final po = provider.purchaseOrders[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('PO: ${po.productName}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Supplier: ${po.supplierName}\nQty: ${po.quantity} • Total: ${currencyFormatter.format(po.totalCost)}'),
              trailing: Chip(
                label: Text(po.status.toUpperCase()),
                backgroundColor: po.status == 'approved' ? Colors.green.shade200 : Colors.orange.shade200,
              ),
              onTap: () {
                if (po.status == 'pending') {
                  provider.updatePoStatus(po.id, 'approved');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PO Disetujui')));
                }
              },
            ),
          );
        },
      ),
    );
  }

  void _showCreatePODialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final supplierCtrl = TextEditingController();
    final productCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final costCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Buat Purchase Order Baru'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: supplierCtrl,
                    decoration: const InputDecoration(labelText: 'Nama Supplier'),
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: productCtrl,
                    decoration: const InputDecoration(labelText: 'Nama Produk'),
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: qtyCtrl,
                    decoration: const InputDecoration(labelText: 'Kuantitas'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: costCtrl,
                    decoration: const InputDecoration(labelText: 'Total Harga'),
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
                  final newPo = PurchaseOrder(
                    id: const Uuid().v4(),
                    supplierName: supplierCtrl.text,
                    productName: productCtrl.text,
                    quantity: int.parse(qtyCtrl.text),
                    totalCost: double.parse(costCtrl.text),
                  );
                  Provider.of<InventoryProvider>(context, listen: false).addPurchaseOrder(newPo);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PO berhasil dibuat')));
                }
              },
              child: const Text('BUAT PO'),
            )
          ],
        );
      }
    );
  }
}
