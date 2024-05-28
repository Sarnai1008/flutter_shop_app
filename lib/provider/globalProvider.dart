import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/models/cart_item_model.dart';
import 'package:shop_app/models/favoriteItem.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/models/users.dart';

class Global_provider extends ChangeNotifier {
  List<ProductModel> products = [];
  List<UserModel> users = [];
  CartResponse? cartItems;
  FavoriteItem? favorite;
  int currentIdx = 0;
  UserModel? user;
  String? token = "";

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  void setProducts(List<ProductModel> data) {
    products = data;
    for (var product in products) {
      if (favorite!.products.contains(product.id) ?? false) {
        product.isFavorite = true;
      } else {
        product.isFavorite = false;
      }
    }
    notifyListeners();
  }

  void setUsers(List<UserModel> data) {
    users = data;
    notifyListeners();
  }

  void setUser(UserModel data) {
    user = data;
    notifyListeners();
  }

  void setCartItems(CartResponse data) {
    cartItems = data;
    notifyListeners();
  }

  ProductModel? fetchProductById(int? id) {
    try {
      int index = products.indexWhere((product) => product.id == id);
      if (index == -1) {
        return null;
      }
      return products[index];
    } catch (e) {
      print("Error fetching product by ID: $e");
      return null;
    }
  }

  void addCartItems(ProductModel product) {
    if (user == null) {
      return;
    }
    int index = cartItems?.products
            ?.indexWhere((element) => element.productId == product.id) ??
        -1;
    if (index != -1) {
      cartItems?.products?[index].quantity =
          (cartItems?.products?[index].quantity ?? 0) + 1;
    } else {
      cartItems?.products?.add(ProductItem(productId: product.id, quantity: 1));
    }
    notifyListeners();
  }

  void increaseQuantity(int index) {
    if (cartItems != null &&
        cartItems!.products != null &&
        index < cartItems!.products!.length) {
      cartItems!.products![index].quantity =
          (cartItems!.products![index].quantity ?? 0) + 1;
      notifyListeners();
    }
  }

  void decreaseQuantity(int index) {
    if (cartItems != null &&
        cartItems!.products != null &&
        index < cartItems!.products!.length) {
      if (cartItems!.products![index].quantity! > 1) {
        cartItems!.products![index].quantity =
            (cartItems!.products![index].quantity ?? 0) - 1;
      } else {
        cartItems!.products!.removeAt(index);
      }
      notifyListeners();
    }
  }

  void changeCurrentIdx(int idx) {
    currentIdx = idx;
    notifyListeners();
  }

  void login({required String email, required String pwd}) {
    try {
      int index = users
          .indexWhere((user) => user.email == email && user.password == pwd);
      if (index != -1) {
        setUser(users[index]);
        notifyListeners();
      }
    } catch (e) {
      print("Login error: $e");
    }
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
    notifyListeners();
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: 'token');
    } catch (e) {
      print("Error getting token: $e");
      return null;
    }
  }

  Future<void> saveFav(FavoriteItem fav) async {
    favorite = fav;
    notifyListeners();
  }

  Future<void> toggleFavorite(ProductModel product) async {
    try {
      if (favorite == null) {
        favorite = FavoriteItem(products: [product.id]);
      } else {
        if (favorite!.products.contains(product.id)) {
          favorite!.products.remove(product.id);
        } else {
          favorite!.products.add(product.id);
        }
      }
      product.isFavorite = !product.isFavorite;
      notifyListeners();
    } catch (e) {
      print("Error toggling favorite: $e");
    }
  }

  Future<void> addComment(int? productId, String comment) async {
    ProductModel? product = fetchProductById(productId);
    if (product != null) {
      product.comments?.add(Comment(userId: user!.id, comment: comment));
      notifyListeners();
    }
  }
}
