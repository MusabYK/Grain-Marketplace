import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.pricePerUnit,
    required super.unit, // e.g., 'kg', 'ton'
    required super.quantityAvailable,
    required super.farmerId,
    // required super.farmerPhone,
    required super.imageUrl,
    required super.postedDate,
    super.location,
    super.status, // e.g., 'available', 'sold'
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
      unit: json['unit'],
      quantityAvailable: (json['quantityAvailable'] as num).toDouble(),
      farmerId: json['farmerId'],
      // farmerPhone: json['farmerPhone'],
      imageUrl: json['imageUrl'],
      postedDate: DateTime.parse(json['postedDate']),
      location: json['location'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pricePerUnit': pricePerUnit,
      'unit': unit,
      'quantityAvailable': quantityAvailable,
      'farmerId': farmerId,
      'imageUrl': imageUrl,
      'postedDate': postedDate.toIso8601String(),
      'location': location,
      'status': status,
    };
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      pricePerUnit: product.pricePerUnit,
      unit: product.unit,
      quantityAvailable: product.quantityAvailable,
      farmerId: product.farmerId,
      // farmerPhone: product.farmerPhone,
      imageUrl: product.imageUrl,
      postedDate: product.postedDate,
      location: product.location,
      status: product.status,
    );
  }

  /// Overrides the copyWith method from the base Product class
  /// to ensure it returns a ProductModel instance.
  @override
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? pricePerUnit,
    String? unit,
    double? quantityAvailable,
    String? farmerId,
    String? farmerPhone,
    String? imageUrl,
    DateTime? postedDate,
    String? location,
    String? status,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      unit: unit ?? this.unit,
      quantityAvailable: quantityAvailable ?? this.quantityAvailable,
      farmerId: farmerId ?? this.farmerId,
      // farmerPhone: farmerPhone ?? this.farmerPhone,
      imageUrl: imageUrl ?? this.imageUrl,
      postedDate: postedDate ?? this.postedDate,
      location: location ?? this.location,
      status: status ?? this.status,
    );
  }
}
