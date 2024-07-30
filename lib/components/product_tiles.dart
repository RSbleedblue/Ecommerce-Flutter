import 'package:CredexEcom/pages/product_details/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:CredexEcom/model/product_model.dart';
import 'package:CredexEcom/utils/cart_provider.dart';
import 'package:fluttertoast/fluttertoast.dart'; 

class ProductTiles extends StatelessWidget {
  final Product product;
  const ProductTiles({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(products: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(116, 241, 241, 241),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(8),
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                AspectRatio(
                  aspectRatio: 1.8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(2),
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: product.thumbnail ?? 'https://via.placeholder.com/150',
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: Color.fromARGB(255, 91, 0, 0),),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.title ?? 'No Title',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  product.description ?? 'No description',
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 10.0,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 91, 0, 0),
                    fontSize: 14.0,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text('Add to Cart'),
                            content: Text('Do you want to add this item to the cart?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmed == true) {
                        Provider.of<CartProvider>(context, listen: false).addToCart(product);
                        Fluttertoast.showToast(
                          msg: "Item added to cart",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0
                        );
                      }
                    },
                    icon: Icon(
                      Icons.add,
                      color: const Color.fromARGB(255, 91, 0, 0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
