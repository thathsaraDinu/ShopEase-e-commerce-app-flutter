import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:products_repository/products_repository.dart';

class WishlistEntity {
  final String userId;
  final List<DocumentReference> productRefs;

  WishlistEntity({
    required this.userId,
    required this.productRefs,
  });

  /// Converts the WishlistEntity to a Firestore-compatible document.
  Map<String, dynamic> toDocument() {
    return {
      'userId': userId,
      'productRefs': productRefs.map((productRef) => productRef).toList(),
    };
  }

  /// Constructs a WishlistEntity from a Firestore document.
  static WishlistEntity fromDocument(Map<String, dynamic> doc) {
    return WishlistEntity(
      userId: doc['userId'] as String,
      productRefs:
          (doc['productRefs'] as List<dynamic>?) // Handle the list of references
                  ?.map((ref) => ref as DocumentReference<Object?>)
                  .toList() ??
              [], // Fallback to an empty list if null
    );
  }


}
