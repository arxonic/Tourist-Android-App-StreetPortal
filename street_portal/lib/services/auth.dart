import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_portal/utils/sp_user.dart';

class AuthService{
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  Future<String> signWithEmailPassword(String email, String password) async {
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed in";
    }catch(e){
      return "false";
    }
  }

  Future<String> registrationWithEmailPassword(String email, String password) async {
    try{
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "User created";
    }catch(e){
      return "false";
    }
  }

  Future logout() async {
    SpUser.id = "";
    SpUser.name = "";
    SpUser.email = "";
    await _firebaseAuth.signOut();
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

}
