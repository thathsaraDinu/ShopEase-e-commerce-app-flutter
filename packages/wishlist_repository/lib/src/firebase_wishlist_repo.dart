import 'package:flutter/foundation.dart';
import 'package:products_repository/products_repository.dart';
import 'entities/entities.dart';
import 'models/wishlist_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'wishlist_repo.dart';

class FirebaseWishlistRepo extends ChangeNotifier implements WishlistRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add an item to the wishlist
  Future<void> addWishlistItem(String userId, String productId) async {
    final wishlistQuery =
        _firestore.collection('wishlist').where('userId', isEqualTo: userId);
    final productRef = _firestore.doc('products/$productId');
    final querySnapshot = await wishlistQuery.get();

    if (querySnapshot.docs.isEmpty) {
      // Create a new wishlist entry if none exists for the user
      await _firestore.collection('wishlist').add({
        'userId': userId,
        'productRefs': [productRef],
      });
    } else {
      // Check the first (or only) wishlist document for existing productRefs
      final doc = querySnapshot.docs.first;
      final data = doc.data();

      // Safely handle missing or null productRefs
      final productRefs = (data['productRefs'] as List<dynamic>?)
              ?.map((ref) => ref as DocumentReference<Object?>)
              .toList() ??
          [];

      // Check if the product already exists in the wishlist
      final alreadyExists =
          productRefs.any((ref) => ref.path == productRef.path);
      if (alreadyExists)
        return; // Exit if the product is already in the wishlist

      // Add the product to the wishlist and update Firestore
      productRefs.add(productRef);
      await doc.reference.update({'productRefs': productRefs});
    }
  }

  // Delete an item from the wishlist
  Future<void> deleteWishlistItem(String userId, String productId) async {
    final querySnapshot = await _firestore
        .collection('wishlist')
        .where('userId', isEqualTo: userId)
        .where('productRefs',
            arrayContains: _firestore.doc('products/$productId'))
        .get();

    for (final doc in querySnapshot.docs) {
      await doc.reference.update({
        'productRefs':
            FieldValue.arrayRemove([_firestore.doc('products/$productId')]),
      });
    }
  }


  // Get wishlist items (products) for a specific user
  Stream<List<ProductModel>> getWishlistItems(String userId) {
    return _firestore
        .collection('wishlist')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      // Step 1: Extract all document references from the wishlist entries
      final productRefs = snapshot.docs.expand((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        final refs = data['productRefs'] as List<dynamic>? ?? [];
        return refs.whereType<
            DocumentReference<Object?>>(); // Filter only valid references
      }).toList();

      // Step 2: Resolve each DocumentReference into a ProductModel
      final productModels = await Future.wait(
        productRefs.map((ref) async {
          try {
            final docSnapshot = await ref.get();
            if (!docSnapshot.exists)
              return null; // Skip if document does not exist

            final productData =
                docSnapshot.data() as Map<String, dynamic>? ?? {};
            return ProductModel.fromEntity(
              ProductEntity.fromDocument(productData),
            );
          } catch (e) {
            print('Error fetching product data: $e');
            return null; // Skip invalid entries
          }
        }),
      );

      // Step 3: Filter out nulls and return the list of ProductModels
      return productModels.whereType<ProductModel>().toList();
    });
  }

  Stream<bool> isInWishListStream(String userId, String productId) {
    return _firestore
        .collection('wishlist')
        .where('userId', isEqualTo: userId)
        .where('productRefs',
            arrayContains: _firestore.doc('products/$productId'))
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }
}
