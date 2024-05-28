import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/provider/globalProvider.dart';
import 'package:shop_app/repository/repository.dart';

class Product_detail extends StatelessWidget {
  final ProductModel product;
  const Product_detail(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController commentController = TextEditingController();
    return Consumer<Global_provider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(
                product.image!,
                height: 200,
              ),
              Text(
                product.title!,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(
                product.description!,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'PRICE: \$${product.price}',
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Comments',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ...product.comments!.map((comment) => ListTile(
                    title: Text(comment!.comment!),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        if (provider.user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ehleed newterne uu!'),
                            ),
                          );
                          return;
                        }
                        await provider.addComment(
                            product.id, commentController.text);
                        await Provider.of<MyRepository>(context, listen: false)
                            .addCommentToProduct(product);
                        commentController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
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
          child: const Icon(Icons.shopping_cart),
        ),
      );
    });
  }
}
