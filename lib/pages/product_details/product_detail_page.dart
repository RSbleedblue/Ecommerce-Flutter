import 'package:CredexEcom/model/product_model.dart';
import 'package:CredexEcom/utils/cart_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final Product products;
  const ProductDetailPage({super.key, required this.products});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  void addToCart() {
    if (quantity > 0) {
      final cartProvider = context.read<CartProvider>();
      cartProvider.addToCart(widget.products);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            content: const Text(
              "Successfully added to the cart",
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                child: const Text('OK', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, "/home");
                },
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double discountedPrice = widget.products.price! * (1 - widget.products.discountPercentage! / 100);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.grey[200],
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                ),
                items: widget.products.images?.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      );
                    },
                  );
                }).toList() ?? [],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow[800]),
                        const SizedBox(width: 5),
                        Text(
                          widget.products.rating?.toStringAsFixed(1) ?? 'N/A',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.products.title ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: widget.products.tags?.map((tag) {
                        return Chip(
                          label: Text(tag, style: TextStyle(fontSize: 12)),
                          backgroundColor: Colors.white,
                        );
                      }).toList() ?? [],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.local_shipping),
                              Text(widget.products.shippingInformation ?? "N/A", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(Icons.security),
                              Text("Secure", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(Icons.thumb_up),
                              Text("Quality", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Description",
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.products.description ?? 'No description',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 91, 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "\$${widget.products.price?.toStringAsFixed(2) ?? '0.00'}",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 214, 214, 214),
                    fontSize: 14,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.white,
                    decorationThickness: 2,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "\$${discountedPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: addToCart,
              style: ElevatedButton.styleFrom(
                // primary: Colors.white,
                // onPrimary: Colors.red,
              ),
              
              child: const Text("Add to Cart",style: TextStyle(color: Color.fromARGB(255, 91, 0, 0)),),
            ),
          ],
        ),
      ),
    );
  }
}
