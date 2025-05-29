import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled12/features/app/splash_screen/splash_screen.dart';
import 'package:untitled12/features/user_auth/presentation/pages/home_page.dart';
import 'package:untitled12/features/user_auth/presentation/pages/login_page.dart';
import 'package:untitled12/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:untitled12/features/user_auth/presentation/pages/welcome_page.dart';
import 'package:untitled12/features/user_auth/presentation/pages/consts.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCsHDQtI9DItQgSqwy45_y2xG9tDGxuER8",
        appId: "1:540215271818:web:8b22d4aee01acdce862873",
        messagingSenderId: "540215271818",
        projectId: "flutter-firebase-9c136",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

Future<void> _setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      routes: {
        '/':
            (context) => SplashScreen(
              child: WelcomePage(), // Changed from LoginPage to WelcomePage
            ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/welcome': (context) => WelcomePage(), // Add this route
      },
    );
  }
}
