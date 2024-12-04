import 'package:products_repository/products_repository.dart';

abstract class WishlistRepo {
  Future<void> addWishlistItem(String userId, String productId);
  Future<void> deleteWishlistItem(String item, String productId);
  Stream<List<ProductModel>> getWishlistItems(String userId);
}