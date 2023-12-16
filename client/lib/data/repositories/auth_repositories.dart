import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  FirebaseAuth auth = FirebaseAuth.instance;

  /// Creating Account
  void signUpWithEmailAndPassword(
      String email, String password, Function onSuccess) async {
    return auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((UserCredential credential) {
      print("Signed Up");
      onSuccess();
    }).onError((error, stackTrace) {
      print("$error");
    });
  }

  /// Login Account
  void signInWithEmailAndPassword(
      String email, String password, Function onSuccess) async {
    return auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((UserCredential credential) {
      print("Signed In");
      onSuccess();
    }).onError((error, stackTrace) {
      print("$error");
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
