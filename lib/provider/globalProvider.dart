import 'package:flutter/material.dart';
import 'package:shop_app/models/product_model.dart';

// ignore: camel_case_types
class Global_provider extends ChangeNotifier{
  List<ProductModel> products =[];
  List <ProductModel> cartItems = [];
  int currentIdx=0;

  void setProducts( List<ProductModel> data){
    products = data;
    notifyListeners();
  }

  void addCartItems(ProductModel item){
    if(cartItems.contains(item)){
      cartItems.remove(item);
    }
    else{
      cartItems.add(item);
    }
    notifyListeners();
  }

  void changeCurrentIdx(int idx){
    currentIdx=idx;
    notifyListeners();
  }

}