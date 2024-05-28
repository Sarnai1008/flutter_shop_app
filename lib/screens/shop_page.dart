import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/provider/globalProvider.dart';
import 'package:shop_app/repository/repository.dart';
import '../widgets/ProductView.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  late Future<List<ProductModel>> _productDataFuture;

  @override
  void initState() {
    super.initState();
    _productDataFuture = _getProductData();
  }

  Future<List<ProductModel>> _getProductData() async {
    try {
      final provider = Provider.of<Global_provider>(context, listen: false);
      if (provider.products.isEmpty) {
        List<ProductModel>? data =
            await Provider.of<MyRepository>(context, listen: false)
                .fetchProductData();
        provider.setProducts(data ?? []);
      }
      return provider.products;
    } catch (e) {
      throw Exception("Error fetching product data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: _productDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Бараанууд",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(223, 37, 37, 37),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 10,
                        children: snapshot.data!
                            .map((product) => ProductViewShop(product))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
