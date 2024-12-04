import 'package:products_repository/products_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/entities.dart';

class Wishlist {
  final String userId;
  final List<DocumentReference> productRefs; // Stores Firestore references

  Wishlist({
    required this.userId,
    required this.productRefs,
  });

  static final empty = Wishlist(
    userId: '',
    productRefs: [],
  );

  /// Converts a Firestore document (entity) to a Wishlist object.
 static Wishlist fromEntity(WishlistEntity entity) {
    return Wishlist(
      userId: entity.userId,
      productRefs: entity.productRefs, // Directly assign the references
    );
  }



  /// Converts a Wishlist object to a WishlistEntity.
  WishlistEntity toEntity() {
    return WishlistEntity(
      userId: userId,
      productRefs: productRefs, // Pass the list of DocumentReferences
    );
  }
}
