import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/provider/globalProvider.dart';
import 'package:shop_app/repository/repository.dart';

class BagsPage extends StatefulWidget {
  const BagsPage({super.key});
  @override
  State<BagsPage> createState() => _BagsPageState();
}

class _BagsPageState extends State<BagsPage> {
  @override
  Widget build(BuildContext context) {
    Future<List<ProductModel>> getCartItems() async {
      final globalProvider =
          Provider.of<Global_provider>(context, listen: false);
      List<ProductModel> products = [];

      for (var cartItem in globalProvider.cartItems!.products!) {
        ProductModel? product =
            globalProvider.fetchProductById(cartItem.productId);
        if (product != null) {
          product.count = cartItem.quantity!;
          products.add(product);
        }
      }

      return products;
    }

    Future<void> buyAllItems(
        BuildContext context, List<ProductModel> products) async {
      final provider = Provider.of<Global_provider>(context, listen: false);
      final repository = Provider.of<MyRepository>(context, listen: false);

      if (provider.user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in first!'),
          ),
        );
        return;
      }

      double total = products.fold(0.0, (sum, item) {
        return sum + (item.price ?? 0) * (item.count);
      });

      if (total > 0) {
        try {
          await repository.buyCartItems(
              provider.user!.id!.toString(), provider.cartItems!);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Purchase successful.'),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Purchase failed: $e'),
            ),
          );
        }
      }
    }

    return FutureBuilder<List<ProductModel>>(
      future: getCartItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          List<ProductModel> products = snapshot.data ?? [];

          return Scaffold(
            appBar: AppBar(
              title: const Text('My Bag'),
            ),
            body: Consumer<Global_provider>(
              builder: (context, provider, child) {
                double total = products.fold(0.0, (sum, item) {
                  return sum + (item.price ?? 0) * (item.count ?? 0);
                });

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    var cartItem = products[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: cartItem.image != null
                            ? Image.network(
                                cartItem.image!,
                                width: 50,
                                height: 50,
                              )
                            : const SizedBox(
                                width: 50,
                                height: 50,
                                child: Placeholder(),
                              ),
                        title: Text(
                          cartItem.title ?? 'No Title',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            const Text("Size: M"),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    provider.decreaseQuantity(index);
                                    setState(() {});
                                  },
                                ),
                                Text('${cartItem.count}'),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    provider.increaseQuantity(index);
                                    setState(() {});
                                  },
                                ),
                                const Spacer(flex: 2),
                                Text(
                                  'Price: \$${(cartItem.price ?? 0) * (cartItem.count ?? 0)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<Global_provider>(
                    builder: (context, provider, child) {
                      double total = products.fold(0.0, (sum, item) {
                        return sum + (item.price ?? 0) * (item.count ?? 0);
                      });
                      return Text(
                        'Total: \$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: () => buyAllItems(context, products),
                    child: const Text('Buy All'),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return const Center(
            child: SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
