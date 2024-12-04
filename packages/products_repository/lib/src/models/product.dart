import 'package:flutter/material.dart';

import '../entities/product_entity.dart';

class ProductModel {
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

  ProductModel({
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

  // Static method for creating an empty ProductModel
  static final ProductModel empty = ProductModel(
    pid: '',
    name: '',
    price: 0.0,
    description: '',
    longDescription: '',
    rating: 0.0,
    ratingCount: 0,
    imageUrls: [],
    colors: [],
    type: '',
  );

  // Convert ProductEntity to ProductModel
  static ProductModel fromEntity(ProductEntity entity) {
    return ProductModel(
      pid: entity.pid,
      name: entity.name,
      price: entity.price,
      description: entity.description,
      longDescription: entity.longDescription,
      rating: entity.rating,
      ratingCount: entity.ratingCount,
      imageUrls: entity.imageUrls,
      colors: entity.colors,
      type: entity.type,
    );
  }
}
