import 'package:flutter/material.dart';
import 'package:shared_preference/screens/home_screen.dart';
import 'package:shared_preference/screens/login_screen.dart';

import 'core/shared_pref_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.startDb();
  checkIsLogged();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IsLogged? const HomeScreen() : const LoginScreen(),
    );
  }
}

bool IsLogged = false;

checkIsLogged() {
  bool isLogin = SharedPrefHelper.getIsLogin()?? false;
  if (isLogin){
    IsLogged = true;
  } else {
    IsLogged = false;
  }
}