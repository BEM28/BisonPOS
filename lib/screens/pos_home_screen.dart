import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:bison_pos/models/product.dart';
import 'package:bison_pos/providers/auth_provider.dart';
import 'package:bison_pos/providers/product_provider.dart';
import 'package:bison_pos/providers/cart_provider.dart';
import 'package:bison_pos/screens/cart_sidebar.dart';
import 'package:bison_pos/screens/main_drawer.dart';

class PosHomeScreen extends StatefulWidget {
  const PosHomeScreen({super.key});

  @override
  State<PosHomeScreen> createState() => _PosHomeScreenState();
}

class _PosHomeScreenState extends State<PosHomeScreen> {
  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bison POS - ${user?.username ?? 'Kasir'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      drawer: const MainDrawer(),
      body: Row(
        children: [
          // Product List Area
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _buildSearchBar(),
                _buildCategoryFilter(),
                Expanded(child: _buildProductGrid()),
              ],
            ),
          ),
          // Cart Sidebar
          const Expanded(
            flex: 1,
            child: CartSidebar(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari produk...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.categories.length,
            itemBuilder: (context, index) {
              final cat = provider.categories[index];
              final isSelected = cat == _selectedCategory;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilterChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProductGrid() {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        // Filter by category
        var products = _selectedCategory == 'Semua'
            ? provider.products
            : provider.products.where((p) => p.category == _selectedCategory).toList();

        // Filter by search query
        if (_searchQuery.isNotEmpty) {
          products = products.where((p) => p.name.toLowerCase().contains(_searchQuery)).toList();
        }

        if (products.isEmpty) {
          return const Center(child: Text('Produk tidak ditemukan.'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              child: InkWell(
                onTap: () => _addToCart(product),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.grey[200],
                          child: const Center(child: Icon(Icons.image, size: 50)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                      Text(currencyFormatter.format(product.sellPrice)),
                      Text('Stok: ${product.totalStock}', style: TextStyle(color: product.totalStock < 10 ? Colors.red : Colors.grey)),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _addToCart(Product product) {
    if (product.totalStock <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stok habis')));
      return;
    }

    if (product.hasVariants) {
      _showVariantDialog(product);
    } else {
      Provider.of<CartProvider>(context, listen: false).addItem(product);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.name} ditambahkan'), duration: const Duration(milliseconds: 500)));
    }
  }

  void _showVariantDialog(Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pilih Varian - ${product.name}'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: product.variants.length,
              itemBuilder: (context, index) {
                final variant = product.variants[index];
                return ListTile(
                  title: Text(variant.name),
                  subtitle: variant.stock > 0 ? Text('+ Rp${variant.additionalPrice}') : const Text('Habis', style: TextStyle(color: Colors.red)),
                  onTap: variant.stock > 0 ? () {
                    Provider.of<CartProvider>(context, listen: false).addItem(product, variant: variant);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.name} (${variant.name}) ditambahkan'), duration: const Duration(milliseconds: 500)));
                  } : null,
                );
              },
            ),
          ),
        );
      }
    );
  }
}
