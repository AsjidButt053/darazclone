/// Product model representing an item in the catalog
class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String description;
  final String image;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    required this.image,
    required this.stock,
  });

  /// Create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      stock: json['stock'] as int,
    );
  }

  /// Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'description': description,
      'image': image,
      'stock': stock,
    };
  }

  /// Create a copy of Product with updated fields
  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? category,
    String? description,
    String? image,
    int? stock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      description: description ?? this.description,
      image: image ?? this.image,
      stock: stock ?? this.stock,
    );
  }
}
