import 'package:CredexEcom/components/product_tiles.dart';
import 'package:CredexEcom/pages/cart_page.dart';
import 'package:CredexEcom/pages/home_page.dart';
import 'package:CredexEcom/pages/profile_page.dart';
import 'package:CredexEcom/pages/search_page.dart';
import 'package:CredexEcom/utils/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  final String category;

  const CategoryPage({required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SearchPage()),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CartPage()),
          );
          break;
        case 3:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 91, 0, 0),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Padding(
          padding: const EdgeInsets.all(0),
          child: Row(
            children: [
              const Icon(Icons.explore, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                '${widget.category} Products',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          final products = productProvider.products
              .where((product) => product.category == widget.category.toLowerCase())
              .toList();

          if (productProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (productProvider.errorMessage.isNotEmpty) {
            return Center(child: Text(productProvider.errorMessage));
          } else if (products.isEmpty) {
            return const Center(child: Text('No products available.'));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.69,
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductTiles(
                  product: products[index],
                );
              },
            );
          }
        },
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.white,
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      //   selectedItemColor: const Color.fromARGB(255, 91, 0, 0),
      //   unselectedItemColor: Theme.of(context).colorScheme.onSurface,
      //   selectedFontSize: 10,
      //   unselectedFontSize: 10,
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search),
      //       label: 'Search',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: CartIcon(),
      //       label: 'Cart',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_circle),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),
    );
  }
}
