import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:street_portal/pages/map_object_screen.dart';
import 'package:street_portal/services/auth.dart';

import 'package:street_portal/utils/constants.dart';

import 'package:street_portal/pages/auth.dart';
import 'package:street_portal/pages/bottom_nav.dart';

import 'package:street_portal/pages/news_feed.dart';

import 'package:street_portal/pages/add.dart';

//import 'package:street_portal/pages/categories.dart';

import 'package:street_portal/pages/map.dart';

import 'package:street_portal/pages/expert_system.dart';
import 'package:street_portal/pages/answers.dart';
import 'package:street_portal/pages/answers_reverse.dart';

import 'package:street_portal/pages/account.dart';
import 'package:street_portal/utils/sp_user.dart';


// "Hunter Green":"346635",
// "White":"FFFFFF",
// "Alabaster":"D6E0D5",
// "Outer Space Crayola":"253832"
// unselectedItemColor: Color(0xff5F6368)

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StreetPortalApp());
}

class StreetPortalApp extends StatelessWidget {
  const StreetPortalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges,
            initialData: null
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
            shadowColor: mainColor
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Method(),

          '/auth': (context) => Auth(),
          '/bottomnav': (context) => BottomNav(pageIndex: 0),

          '/newsfeed': (context) => NewsFeed(),
          '/newsfeed/add_news': (context) => Add(),

          //'/categories': (context) => Categories(),

          '/map': (context) => Map(),
          '/map/map_object': (context) => MapObjectScreen(),

          '/expert_system': (context) => ExpertSystem(),
          '/expert_system/answers': (context) => Answers(),
          '/expert_system/answers_reverse': (context) => AnswersReverse(),

          '/account': (context) => Account(),
        },
      ),
    );
  }
}

class Method extends StatelessWidget {
  const Method({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      SpUser(firebaseUser);
      return BottomNav(pageIndex: 0);
    }else {
      return Auth();
    }
  }
}
