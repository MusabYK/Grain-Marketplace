import 'package:dartz/dartz.dart'; // You might need to add dartz package for functional programming
import '../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';
import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl(this.authDataSource);

  @override
  Stream<fb_auth.User?> get authStateChanges => authDataSource.authStateChanges;

  @override
  Future<Either<Failure, User>> registerWithEmailAndPassword(
    String email,
    String password,
    String userType,
  ) async {
    try {
      final userModel = await authDataSource.registerWithEmailAndPassword(
        email,
        password,
        userType,
      );
      return Right(userModel);
    } on AuthFailure catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userModel = await authDataSource.signInWithEmailAndPassword(
        email,
        password,
      );
      return Right(userModel);
    } on AuthFailure catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await authDataSource.signOut();
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userModel = await authDataSource.getCurrentUser();
      return Right(userModel);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
