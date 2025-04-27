import 'package:flutter/material.dart';
import 'package:shared_preference/screens/home_screen.dart';
import '../core/shared_pref_helper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Login'),
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              hintText: 'Username',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await SharedPrefHelper.saveUserName(usernameController.text);
              await SharedPrefHelper.isLogin(true);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
