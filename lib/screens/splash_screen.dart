import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preference/screens/onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(
        const Duration(seconds: 3),
            () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OnboardScreen(),
              ),
          );
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Lottie.asset(
            'assets/Animation - 1745797678541.json'
        ),
      ),
    );
  }
}
