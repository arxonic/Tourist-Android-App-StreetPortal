import 'package:firebase_auth/firebase_auth.dart';

class SpUser{
  static late String id;
  static late String name;
  static late String email;

  SpUser(User? user){
    id = user!.uid;
    name = user.email!.split("@").first;
    email = user.email!;
  }
}