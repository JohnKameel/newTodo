import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preference/core/shared_pref_helper.dart';
import 'package:shared_preference/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserName();
  }

  loadUserName() {
    String? usernameDB = SharedPrefHelper.getUserName();
    setState(() {
      username = usernameDB ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Welcome $username',
          style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 32,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/Animation - 1745883415011.json'),
            const Text(
              'Nothing here yet..',
              style: const TextStyle(color: Colors.black),
            ),
            ElevatedButton(
              onPressed: () async {
                await SharedPrefHelper.clear();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
