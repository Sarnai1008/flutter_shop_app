import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/globalProvider.dart';

// ignore: must_be_immutable
class BagsPage extends StatelessWidget {

  BagsPage({super.key});
 
   @override
  Widget build(BuildContext context) {

      return Consumer<Global_provider>(
      builder: (context, provider, child) {
        double total = provider.cartItems.fold(0, (sum, item) => sum + (item.price!));
        return Scaffold(
            appBar: AppBar(
              title: Text('Cart'),
            ),
            body: ListView.builder(
              itemCount: provider.cartItems.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(
                      provider.cartItems[index].image!,
                      width: 50, // Adjust the width as needed
                      height: 50, // Adjust the height as needed
                    ),
                    title: Text(provider.cartItems[index].title!),
                    subtitle: Text('Quantity: ${provider.cartItems[index].count}'),
                    // You can add more details if needed, like the price
                  ),
                );
              },
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implement buy all logic
                      // For example, you might want to navigate to a checkout page
                      // or display a confirmation dialog.
                    },
                    child: Text('Buy All'),
                  ),
                ],
              ),
            ),
          );
      });
}
}