import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Food extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final String categoryId;
  final int price;
  final int createdAt;
  final int updatedAt;
  final bool isLive;
  final Map<String, dynamic> createdBy;
  final List<String> ingridients;

  const Food({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.categoryId,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.isLive,
    required this.createdBy,
    required this.ingridients,
  });

  Food copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? description,
    String? categoryId,
    int? price,
    int? createdAt,
    int? updatedAt,
    bool? isLive,
    Map<String, dynamic>? createdBy,
    List<String>? ingridients,
  }) {
    return Food(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLive: isLive ?? this.isLive,
      createdBy: createdBy ?? this.createdBy,
      ingridients: ingridients ?? this.ingridients,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
      'categoryId': categoryId,
      'price': price,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isLive': isLive,
      'createdBy': createdBy,
      'ingridients': ingridients,
    };
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      categoryId: map['categoryId'] ?? '',
      price: map['price'] ?? 0,
      createdAt: map['createdAt'] ?? 0,
      updatedAt: map['updatedAt'] ?? 0,
      isLive: map['isLive'] ?? false,
      createdBy: Map<String, dynamic>.from(map['createdBy']),
      ingridients: List<String>.from(map['ingridients']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Food.fromJson(String source) => Food.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Food(id: $id, title: $title, imageUrl: $imageUrl, description: $description, categoryId: $categoryId, price: $price, createdAt: $createdAt, updatedAt: $updatedAt, isLive: $isLive, createdBy: $createdBy, ingridients: $ingridients)';
  }

  @override
  List<Object> get props {
    return [
      id,
      title,
      imageUrl,
      description,
      categoryId,
      price,
      createdAt,
      updatedAt,
      isLive,
      createdBy,
      ingridients,
    ];
  }
}