import 'package:CredexEcom/components/product_tiles.dart';
import 'package:CredexEcom/pages/category_page.dart';
import 'package:CredexEcom/utils/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.category,
                    size: 24.0,
                    color: Color.fromARGB(255, 91, 0, 0),
                  ),
                  SizedBox(width: 8),
                  Text(
                    localizations.category,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _CategoryCircle(
                iconPath: 'lib/icons/furniture.png',
                title: localizations.furniture,
                backgroundColor: Colors.white,
              ),
              _CategoryCircle(
                iconPath: 'lib/icons/beauty.png',
                title: localizations.beauty,
                backgroundColor: Colors.white,
              ),
              _CategoryCircle(
                iconPath: 'lib/icons/grocery.png',
                title: localizations.grocery,
                backgroundColor: Colors.white,
              ),
              _CategoryCircle(
                iconPath: 'lib/icons/laptop.png',
                title: localizations.laptops,
                backgroundColor: Colors.white,
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bolt,
                    size: 24.0,
                    color: Color.fromARGB(255, 91, 0, 0),
                  ),
                  SizedBox(width: 8),
                  Text(
                    localizations.allProduct, 
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  _isGridView ? Icons.grid_view : Icons.list,
                  color: Color.fromARGB(255, 91, 0, 0),
                ),
                onPressed: _toggleView,
              ),
            ],
          ),
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              if (productProvider.isLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (productProvider.errorMessage.isNotEmpty) {
                return Center(child: Text(productProvider.errorMessage));
              } else if (productProvider.products.isEmpty) {
                return Center(child: Text(localizations.noProductsAvailable));
              } else {
                final products = productProvider.products;
                return Expanded(
                  child: _isGridView
                      ? GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.65,
                            crossAxisCount: 2,
                            crossAxisSpacing: 2.0,
                            mainAxisSpacing: 2.0,
                          ),
                          itemCount: products.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ProductTiles(
                              product: products[index],
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: products.length,
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.all(5),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ProductTiles(
                              product: products[index],
                            );
                          },
                        ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryCircle extends StatelessWidget {
  final String iconPath;
  final String title;
  final Color backgroundColor;

  const _CategoryCircle({
    required this.iconPath,
    required this.title,
    required this.backgroundColor,
  });

  void _navigateToCategory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryPage(category: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToCategory(context),
      child: Container(
        width: 60,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 216, 216, 216).withOpacity(0.2),
              blurRadius: 4.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 60,
              height: 60,
            ),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
