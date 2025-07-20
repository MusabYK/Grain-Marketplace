import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../core/errors/failures.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

abstract class AuthRepository {
  Future<Either<Failure, User>> registerWithEmailAndPassword(
    String email,
    String password,
    String userType,
  );
  Future<Either<Failure, User>> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Either<Failure, void>> signOut();
  Stream<fb_auth.User?> get authStateChanges;
  Future<Either<Failure, User?>> getCurrentUser();
}
