import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/errors/failures.dart';
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';

abstract class AuthDataSource {
  Future<UserModel> registerWithEmailAndPassword(
    String email,
    String password,
    String userType,
    String name,
    String phone,
  );
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Stream<fb_auth.User?> get authStateChanges;
  Future<UserModel?> getCurrentUser();
}

class AuthDataSourceImpl implements AuthDataSource {
  final fb_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthDataSourceImpl({
    fb_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? fb_auth.FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<fb_auth.User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .get();
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  @override
  Future<UserModel> registerWithEmailAndPassword(
    String email,
    String password,
    String userType,
    String name,
    String phone,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = userCredential.user!.uid;
      final userModel = UserModel(
        uid: uid,
        email: email,
        userType: userType,
        name: name,
        phone: phone,
      );
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .set(userModel.toJson());
      return userModel;
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Registration failed.');
    } catch (e) {
      throw ServerFailure('An unexpected error occurred: $e');
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = userCredential.user!.uid;
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();
      return UserModel.fromJson(doc.data()!);
    } on fb_auth.FirebaseAuthException catch (e) {
      throw AuthFailure(e.message ?? 'Sign in failed.');
    } catch (e) {
      throw ServerFailure('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
