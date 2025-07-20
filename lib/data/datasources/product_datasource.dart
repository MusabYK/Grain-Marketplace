import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../../core/errors/failures.dart';
import '../models/product_model.dart';
import '../../core/constants/app_constants.dart';

abstract class ProductDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String productId);
  Future<ProductModel> addProduct(ProductModel product, File? imageFile);
  Future<void> updateProduct(ProductModel product, File? imageFile);
  Future<void> deleteProduct(String productId);
  Future<List<ProductModel>> getFarmerProducts(String farmerId);
}

class ProductDataSourceImpl implements ProductDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;

  ProductDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseStorage? firebaseStorage,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.productsCollection)
          .get();
      return querySnapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerFailure('Failed to fetch products: $e');
    }
  }

  @override
  Future<ProductModel> getProductById(String productId) async {
    try {
      final docSnapshot = await _firestore
          .collection(AppConstants.productsCollection)
          .doc(productId)
          .get();
      if (!docSnapshot.exists) {
        throw ServerFailure('Product not found.');
      }
      return ProductModel.fromJson(docSnapshot.data()!);
    } catch (e) {
      throw ServerFailure('Failed to fetch product: $e');
    }
  }

  @override
  Future<ProductModel> addProduct(ProductModel product, File? imageFile) async {
    try {
      String? imageUrl;
      if (imageFile != null) {
        final ref = _firebaseStorage.ref().child(
          'product_images/${product.id}_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        await ref.putFile(imageFile);
        imageUrl = await ref.getDownloadURL();
      }

      final productToAdd = product.copyWith(imageUrl: imageUrl);
      await _firestore
          .collection(AppConstants.productsCollection)
          .doc(product.id)
          .set(productToAdd.toJson());
      return productToAdd;
    } catch (e) {
      throw ServerFailure('Failed to add product: $e');
    }
  }

  @override
  Future<void> updateProduct(ProductModel product, File? imageFile) async {
    try {
      String? imageUrl = product.imageUrl;
      if (imageFile != null) {
        final ref = _firebaseStorage.ref().child(
          'product_images/${product.id}_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        await ref.putFile(imageFile);
        imageUrl = await ref.getDownloadURL();
      }

      final updatedProduct = product.copyWith(imageUrl: imageUrl);
      await _firestore
          .collection(AppConstants.productsCollection)
          .doc(product.id)
          .update(updatedProduct.toJson());
    } catch (e) {
      throw ServerFailure('Failed to update product: $e');
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore
          .collection(AppConstants.productsCollection)
          .doc(productId)
          .delete();
    } catch (e) {
      throw ServerFailure('Failed to delete product: $e');
    }
  }

  @override
  Future<List<ProductModel>> getFarmerProducts(String farmerId) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.productsCollection)
          .where('farmerId', isEqualTo: farmerId)
          .get();
      return querySnapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerFailure('Failed to fetch farmer products: $e');
    }
  }
}
