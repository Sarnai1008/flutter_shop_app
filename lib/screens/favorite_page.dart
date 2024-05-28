import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/provider/globalProvider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Global_provider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Favorite'),
        ),
        body: ListView.builder(
          itemCount: provider.products.length,
          itemBuilder: (context, index) {
            ProductModel product = provider.products[index];
            if (product.isFavorite) {
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.network(product.image!),
                  title: Text(product.title!),
                  subtitle: Row(
                    children: [
                      Text('${product.category}'),
                      const SizedBox(width: 20),
                      Text('\$${product.price}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      if (provider.user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ehleed newterne uu!'),
                          ),
                        );
                        return;
                      }
                      provider.addCartItems(product);
                    },
                  ),
                ),
              );
            } else {
              const SizedBox();
            }
            return null;
          },
        ),
      );
    });
  }
}
