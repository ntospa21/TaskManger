import 'package:firebase_auth/firebase_auth.dart';

import '../../data/models/user.dart';

abstract class UserRepository {
  Stream<User?> get user;

  Future<MyUser> signUp(MyUser user, String password);

  Future<void> signIn(String email, String password);

  Future<void> setUserData(MyUser user);

  Future<void> logOut();
}
