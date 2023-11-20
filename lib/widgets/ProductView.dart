import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductViewShop extends StatelessWidget {
  final ProductModel data;

  const ProductViewShop(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image
          Container(
            height: 150.0, // Adjust the height based on your design
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(data.image!),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          // Product details
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title!,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '\$${data.price!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    
    
    // Row(
    //   children: [
    //     Box(
    //       height: width /3,
    //       width: width,
    //       margin: EdgeInsets.only(right: 10),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(8),
    //         image: DecorationImage(image: NetworkImage(data.image!), fit: BoxFit.fitHeight)
    //       ),
    //     ),
    //      Column(
    //       children: [
    //         Text(data.title==null?"": data.title!),
    //         Text(data.category==null?"": data.category!),
    //         Text('${data.price}'),
    //       ],
    //     )
      
    //   ],
    // );
  }
}