import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/models/cart_item_model.dart';
import 'package:shop_app/models/favoriteItem.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyRepository {
  final FirebaseFirestore firestore;

  MyRepository({required this.firestore});

  Future<List<ProductModel>> fetchProductData() async {
    try {
      CollectionReference productsRef =
          FirebaseFirestore.instance.collection('products');
      QuerySnapshot querySnapshot = await productsRef.get();

      List<ProductModel> products = querySnapshot.docs.map((doc) {
        return ProductModel(
          id: doc['id'],
          title: doc['title'],
          price: doc['price'],
          category: doc['category'],
          description: doc['description'],
          image: doc['image'],
          comments: (doc['comments'] as List<dynamic>).map((com) {
            return Comment(
              userId: com['userId'],
              comment: com['comment'],
            );
          }).toList(),
        );
      }).toList();
      return products;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<String> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user!.uid;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<CartResponse> fetchCartItems(int id) async {
    try {
      CollectionReference cartRef =
          FirebaseFirestore.instance.collection('cart');
      QuerySnapshot querySnapshot =
          await cartRef.where('id', isEqualTo: id).get();

      if (querySnapshot.docs.isEmpty) {
        return Future.error("Cart not found");
      }

      DocumentSnapshot doc = querySnapshot.docs.first;
      var productsData = doc['products'];

      if (productsData is! List<dynamic>) {
        return Future.error("Products field is not a list");
      }

      List<ProductItem> products = productsData.map((productData) {
        return ProductItem(
          productId: productData['productId'],
          quantity: productData['quantity'],
        );
      }).toList();

      CartResponse cart = CartResponse(
        id: doc['id'],
        userId: doc['userId'],
        date: doc['date'],
        products: products,
      );

      return cart;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> buyAllCartItems(int userId, CartResponse cart) async {
    try {
      CollectionReference cartRef = firestore.collection('cart');

      Map<String, dynamic> cartData = {
        'userId': userId,
        'date': "2024-05-28",
        'products': cart.products?.map((product) {
          return {
            'productId': product.productId,
            'quantity': product.quantity,
          };
        }).toList(),
      };

      QuerySnapshot querySnapshot =
          await cartRef.where('id', isEqualTo: cart.id).get();

      if (querySnapshot.docs.isEmpty) {
        return Future.error("Cart not found");
      }

      DocumentReference docRef = querySnapshot.docs.first.reference;
      await docRef.update(cartData);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> buyCartItems(String userId, CartResponse cart) async {
    return buyAllCartItems(int.parse(userId), cart);
  }

  Future<FavoriteItem> getFavoriteItems(int userId) async {
    try {
      CollectionReference favoritesRef = firestore.collection('favorites');
      QuerySnapshot querySnapshot =
          await favoritesRef.where('userId', isEqualTo: userId).get();

      if (querySnapshot.docs.isEmpty) {
        return Future.error("Favorites not found");
      }
      DocumentSnapshot doc = querySnapshot.docs.first;
      return FavoriteItem.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> setFavoriteItem(FavoriteItem favoriteItem) async {
    try {
      CollectionReference favoritesRef = firestore.collection('favorites');
      int? userId = favoriteItem.userId;
      if (userId != null) {
        await favoritesRef.doc(userId.toString()).set(favoriteItem.toMap());
      } else {
        throw Exception("Invalid userId");
      }
    } catch (e) {
      throw Exception("Error setting favorite item: $e");
    }
  }

  Future<void> addCommentToProduct(ProductModel product) async {
    try {
      print("Fetching product with ID: ${product.id}");

      DocumentReference productRef =
          firestore.collection('products').doc(product.id as String?);
      DocumentSnapshot productSnapshot = await productRef.get();

      if (!productSnapshot.exists) {
        print("Product not found with ID: ${product.id}");
        return Future.error("Product not found");
      }

      print("Product found: ${productSnapshot.data()}");

      List<Map<String, dynamic>> updatedComments =
          product.comments?.map((comment) {
                return {
                  'userId': comment?.userId,
                  'comment': comment?.comment,
                };
              }).toList() ??
              [];

      await productRef.update({'comments': updatedComments});

      print("Product comments updated successfully for ID: ${product.id}");
    } catch (e) {
      print("Error adding comment: $e");
      throw Exception("Error adding comment: $e");
    }
  }
}
