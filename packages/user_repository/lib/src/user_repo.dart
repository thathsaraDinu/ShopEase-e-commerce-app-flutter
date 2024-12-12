import './models/user.dart';

abstract class UserRepository {
  /// Stream of the authenticated user's data.
  Stream<MyUser> get user;

  /// Updates user data in the database.
  Future<void> updateUser(MyUser user);

  /// Signs up a new user with the given credentials.
  /// Returns the created `MyUser` object on success.
  Future<MyUser> signUp({
    required MyUser myuser,
    required String password,
  });

  /// Signs in an existing user with email and password.
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sets initial user data in the database after signup.
  Future<void> setUserData(MyUser user);

  /// Signs out the currently authenticated user.
  Future<void> signOut();

  /// Maps errors to user-friendly error messages.
  String mapErrorToMessage(Object error);
}
