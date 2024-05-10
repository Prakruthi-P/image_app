import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image/screens/forgot_password.dart';
import 'package:image/screens/image_flutter.dart';
import 'package:image/screens/login_page.dart';
import 'package:image/screens/signup_page.dart';
import 'package:image/screens/splash_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "/image":(context)=>ImageFlutter(),
        "/login":(context)=>LoginPage(),
        "/Signup":(context)=>SignUp(),
        "/forgetPassword":(context)=>ForgotPassword(),
      },
      home:SplashScreen(
        child:LoginPage()
        ,
      )
      ,
    );
  }
}

