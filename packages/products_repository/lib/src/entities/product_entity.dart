import 'package:flutter/material.dart';

class ProductEntity {
  String pid;
  String name;
  double price;
  String description;
  String longDescription;
  double rating;
  int ratingCount;
  List<String> imageUrls;
  List<Color> colors = [];
  String type;

  ProductEntity({
    required this.pid,
    required this.name,
    required this.price,
    required this.description,
    required this.longDescription,
    required this.rating,
    required this.ratingCount,
    required this.imageUrls,
    required this.colors,
    required this.type,
  });

  static ProductEntity fromDocument(Map<String, Object?> doc, [String? id]) {
    return ProductEntity(
      pid: doc['pid'] as String? ?? '', // Provide default empty string if null
      name: doc['name'] as String? ?? 'Unknown Product', // Handle null case
      price:
          (doc['price'] as num?)?.toDouble() ?? 0.0, // Default to 0.0 if null
      description: doc['description'] as String? ?? '',
      longDescription: doc['longDescription'] as String? ?? '',
      rating: (doc['rating'] as num?)?.toDouble() ?? 0.0, // Handle null case
      ratingCount: doc['ratingCount'] as int? ?? 0, // Default to 0 if null
      imageUrls: List<String>.from(
          doc['imageUrls'] as List? ?? []), // Handle null list
      colors: (doc['colorsAsDecimal'] as List?)
              ?.map((colorCode) =>
                  Color(colorCode as int)) // Convert color code to Color
              .toList() ??
          [], // Convert to Color
      type: doc['type'] as String? ?? 'unknown', // Default to 'unknown'
    );
  }
}
