import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
        const Duration(seconds: 3),
            () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => widget.child!),
                  (route) => false
          );
        }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green, // Full green background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Short White.png', // Your logo image path
              height: 150, // Adjust size as needed
              width: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
