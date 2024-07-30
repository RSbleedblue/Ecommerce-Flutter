import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart'; 
import 'package:CredexEcom/utils/cart_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; 

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return cartProvider.items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        localizations.cartEmpty,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartProvider.items.length,
                        itemBuilder: (context, index) {
                          final cartItem = cartProvider.items[index];
                          return ListTile(
                            leading: CachedNetworkImage(
                              imageUrl: cartItem.product.thumbnail ?? 'https://via.placeholder.com/150',
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(color: Color.fromARGB(255, 91, 0, 0)),
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                            title: Text(
                              cartItem.product.title ?? 'No Title',
                              style: const TextStyle(fontSize: 12),
                            ),
                            subtitle: Text(
                              'Price: \$${cartItem.product.price?.toStringAsFixed(2) ?? '0.00'}\nQuantity: ${cartItem.quantity}',
                              style: const TextStyle(color: Color.fromARGB(255, 91, 0, 0), fontSize: 12),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  iconSize: 16,
                                  padding: const EdgeInsets.all(2),
                                  icon: const Icon(Icons.remove, color: Color.fromARGB(255, 91, 0, 0)),
                                  onPressed: () {
                                    cartProvider.deleteFromCart(cartItem.product);
                                  },
                                ),
                                IconButton(
                                  iconSize: 16,
                                  padding: const EdgeInsets.all(2),
                                  icon: const Icon(Icons.add, color: Color.fromARGB(255, 91, 0, 0)),
                                  onPressed: () {
                                    cartProvider.addToCart(cartItem.product);
                                  },
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 91, 0, 0),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Fluttertoast.showToast(
                                msg: "Order has been successfully placed",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              textStyle: const TextStyle(fontSize: 16),
                              side: const BorderSide(color: Color.fromARGB(255, 91, 0, 0)), 
                            ),
                            child: const Text(
                              'Pay Now',
                              style: TextStyle(color: Color.fromARGB(255, 91, 0, 0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
