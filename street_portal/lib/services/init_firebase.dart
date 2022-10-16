import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class initFirebase{
  initFirebase(){
    initFBS();
  }

  void initFBS() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

}