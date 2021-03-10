import 'package:dating_app/screens/home/chatPage.dart';
import 'package:dating_app/screens/home/findingPage.dart';
import 'package:dating_app/screens/home/loverProfile.dart';
import 'package:dating_app/screens/home/loverProfileSettings.dart';
import 'package:dating_app/screens/home/userProfileSettings.dart';
import 'package:dating_app/screens/wrapper.dart';
import 'package:dating_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/models/userData.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthService().user),
      ],
      child: MaterialApp(
        home: Wrapper(),
        initialRoute: '/home',
        routes: {
          '/home': (context) => Wrapper(),
          '/userProfileSettings': (context) => UserProfileSettings(),
          '/loverProfileSettings': (context) => LoverProfileSettings(),
          '/chatPage': (context) => ChatPage(),
          '/findingPage': (context) => FindingPage(),
          '/loverProfile': (context) => LoverProfile(),
      },
      ),
    );
  }
}