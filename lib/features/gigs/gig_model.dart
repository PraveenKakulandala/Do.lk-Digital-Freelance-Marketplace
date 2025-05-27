class Gig {
  final String? id;
  final String sellerId;
  final String sellerName;
  final String title;
  final String description;
  final double price;
  final String category;
  final List<String> images;
  final DateTime createdAt;
  final bool isActive;

  Gig({
    this.id,
    required this.sellerId,
    required this.sellerName,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.images,
    DateTime? createdAt,
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert Gig to Map
  Map<String, dynamic> toMap() {
    return {
      'sellerId': sellerId,
      'sellerName': sellerName,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'images': images,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  // Create Gig from Map
  factory Gig.fromMap(Map<String, dynamic> map, String id) {
    return Gig(
      id: id,
      sellerId: map['sellerId'] ?? '',
      sellerName: map['sellerName'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] as num).toDouble(),
      category: map['category'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
      isActive: map['isActive'] ?? true,
    );
  }

  // Optionally, you can add a copyWith method for easier updates
  Gig copyWith({
    String? id,
    String? sellerId,
    String? sellerName,
    String? title,
    String? description,
    double? price,
    String? category,
    List<String>? images,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Gig(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
