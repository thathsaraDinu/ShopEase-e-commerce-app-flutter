import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import './models/models.dart';
import './entities/entities.dart';
import './user_repo.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseUserRepo extends ChangeNotifier implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  FirebaseUserRepo({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<MyUser> getUser() {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<void> setUserData(MyUser myuser) async {
    try {
      await usersCollection.doc(myuser.uid).set(myuser.toEntity().toDocument());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Directly rethrow the FirebaseAuthException
      throw e;
    }
  }

  @override
  Future<MyUser> signUp(
      {required MyUser myuser, required String password}) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: myuser.email, password: password);
      myuser.uid = user.user!.uid;

      // Store user details in Firestore
      await usersCollection.doc(myuser.uid).set(myuser.toEntity().toDocument());
      return myuser;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  @override
  Future<void> updateUser(MyUser user) async {
    try {
      await usersCollection.doc(user.uid).update(user.toEntity().toDocument());

      // Store user details in Firestore
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Stream<MyUser> get user {
    return _firebaseAuth.authStateChanges().flatMap((firebaseUser) async* {
      if (firebaseUser == null) {
        yield MyUser.empty;
      } else {
        yield await usersCollection.doc(firebaseUser.uid).get().then((doc) {
          if (doc.exists) {
            return MyUser.fromEntity(MyUserEntity.fromDocument(doc.data()!));
          } else {
            return MyUser.empty;
          }
        });
      }
    });
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  Future<User?> signInWithGoogle() async {
    try {
      // Attempt to sign in with Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // The user canceled the sign-in process
        return null; // Or handle accordingly
      }

      // Retrieve authentication credentials
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Return the signed-in user
      return userCredential.user;
    } catch (e) {
      // Handle specific error cases
      print("Error signing in with Google: $e");
      throw Exception(
          "Failed to sign in with Google: $e"); // Custom error message
    }
  }

  /// Map error to custom message
  @override
  String mapErrorToMessage(Object error) {
    print("Error type: ${error.runtimeType}, Error: $error");

    if (error is FirebaseAuthException) {
      print("Error code: ${error.code}");
      switch (error.code) {
        case 'wrong-password':
          return 'The password is incorrect. Please try again.';
        case 'user-not-found':
          return 'No user found with this email address.';
        case 'email-already-in-use':
          return 'This email address is already in use.';
        case 'invalid-email':
          return 'The email address is invalid.';
        case 'weak-password':
          return 'The password is too weak. Please choose a stronger password.';
        case 'invalid-credential':
          return 'The email or password is invalid';
        default:
          return 'An unexpected error occurred. Please try again later.';
      }
    } else {
      return 'An internal error occurred. Please try again.';
    }
  }
}
