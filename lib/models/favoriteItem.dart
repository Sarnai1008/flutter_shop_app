class FavoriteItem {
  int? userId;
  final List<int?> products;

  FavoriteItem({this.userId, List<int?>? products}) : products = products ?? [];

  factory FavoriteItem.fromMap(Map<String, dynamic> data) {
    return FavoriteItem(
      userId: data['userId'] as int?,
      products: List<int>.from(data['products']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'products': products,
    };
  }
}
