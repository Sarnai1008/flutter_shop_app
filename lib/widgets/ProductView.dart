import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/globalProvider.dart';
import 'package:shop_app/repository/repository.dart';
import 'package:shop_app/screens/product_detail.dart';
import '../models/product_model.dart';

class ProductViewShop extends StatelessWidget {
  final ProductModel data;

  const ProductViewShop(this.data, {super.key});
  _onTap(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => Product_detail(data)));
  }

  @override
  Widget build(BuildContext context) {
    print(data.comments?.length);
    return Consumer<Global_provider>(builder: (context, provider, child) {
      return InkWell(
        onTap: () => _onTap(context),
        child: Card(
          elevation: 4.0,
          margin: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 150.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(data.image!),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title!,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      data.category!,
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Text(
                          '\$${data.price!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 530.0),
                        IconButton(
                          onPressed: () async {
                            if (provider.user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Ehleed newterne uu!'),
                                ),
                              );
                              return;
                            }
                            await provider.toggleFavorite(data);
                            Provider.of<MyRepository>(context, listen: false)
                                .setFavoriteItem(provider.favorite!);
                          },
                          icon: Icon(
                            data.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: data.isFavorite ? Colors.red : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
