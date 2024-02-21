import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthRepository {
  FirebaseAuth auth = FirebaseAuth.instance;

  /// Creating Account
  void signUpWithEmailAndPassword(
      String email, String password, Function onSuccess) async {
    return auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((UserCredential credential) {
      debugPrint("Signed Up");
      onSuccess();
    }).onError((error, stackTrace) {
      debugPrint("$error");
    });
  }

  /// Login Account
  void signInWithEmailAndPassword(
      String email, String password, Function onSuccess) async {
    return auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((UserCredential credential) {
      debugPrint("Signed In");
      onSuccess();
    }).onError((error, stackTrace) {
      debugPrint("$error");
    });
  }

  /// EMail Verification
  void sendEmailVerification() {
    auth.currentUser?.sendEmailVerification();
  }

  // Getting the UserID
  String? getUserId() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return user.uid;
    } else {
      // User is not signed in
      return null;
    }
  }
}
