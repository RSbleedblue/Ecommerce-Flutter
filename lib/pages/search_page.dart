import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CredexEcom/model/product_model.dart';
import 'package:CredexEcom/utils/product_provider.dart';
import 'package:CredexEcom/components/product_tiles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Product> _allProducts = [];
  List<Product> _displayedProducts = [];
  String _searchQuery = '';
  bool _isGridView = true; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      productProvider.fetchProducts().then((_) {
        setState(() {
          _allProducts = productProvider.products;
          _displayedProducts = _allProducts;
        });
      });
    });
  }

  void _searchProducts(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _displayedProducts = _allProducts; 
      } else {
        _displayedProducts = _allProducts.where((product) {
          final titleLower = product.title?.toLowerCase() ?? '';
          final descriptionLower = product.description?.toLowerCase() ?? '';
          final queryLower = query.toLowerCase();
          return titleLower.contains(queryLower) || descriptionLower.contains(queryLower);
        }).toList();
      }
    });
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        
        children: [

          Container(
            width: 330,
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: Row(
              children: [
                
                const Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 91, 0, 0),
                ),
                Expanded(
                  
                  child: Padding(
                    
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      
                      onChanged: _searchProducts,
                      decoration: InputDecoration(
                        
                        labelText: AppLocalizations.of(context)!.search,
                        labelStyle: TextStyle(color: Color.fromARGB(255, 91, 0, 0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
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
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (productProvider.errorMessage.isNotEmpty) {
                  return Center(child: Text(productProvider.errorMessage));
                } else if (_searchQuery.isEmpty) {
                  return Center(child: Image.asset('lib/images/123.gif', width: 500, height: 500),);
                } else if (_displayedProducts.isEmpty) {
                  return Center(child: Text('No products found.'));
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _isGridView
                        ? GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 0.72,
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                            ),
                            itemCount: _displayedProducts.length,
                            itemBuilder: (context, index) {
                              final product = _displayedProducts[index];
                              return ProductTiles(product: product);
                            },
                          )
                        : ListView.builder(
                            itemCount: _displayedProducts.length,
                            itemBuilder: (context, index) {
                              final product = _displayedProducts[index];
                              return ProductTiles(product: product);
                            },
                          ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
