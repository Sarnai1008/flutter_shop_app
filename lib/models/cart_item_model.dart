import 'package:json_annotation/json_annotation.dart';

part 'cart_item_model.g.dart';

@JsonSerializable()
class CartResponse {
  final int? id;
  final int? userId;
  String? date;
  List<ProductItem>? products;

  CartResponse({this.id, this.userId, this.date, this.products});

  factory CartResponse.fromJson(Map<String, dynamic> json) =>
      _$CartResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CartResponseToJson(this);

  static List<CartResponse> fromList(List<dynamic> data) =>
      data.map((e) => CartResponse.fromJson(e)).toList();
}

@JsonSerializable()
class ProductItem {
  final int? productId;
  int? quantity;

  ProductItem({this.productId, this.quantity});

  factory ProductItem.fromJson(Map<String, dynamic> json) =>
      _$ProductItemFromJson(json);

  Map<String, dynamic> toJson() => _$ProductItemToJson(this);

  static List<ProductItem> fromList(List<dynamic> data) =>
      data.map((e) => ProductItem.fromJson(e)).toList();
}
