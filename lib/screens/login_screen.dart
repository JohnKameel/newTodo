import 'package:flutter/material.dart';
import 'package:shared_preference/screens/home_screen.dart';
import '../core/shared_pref_helper.dart';
import '../widgets/custom_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Log in to ToDo App',
                style: TextStyle(
                    color: Color(0xffC67ED2),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                ),
              ),
              const Opacity(
                opacity: 0.5,
                child: Text(
                  'Welcome back! Sign in using your social\n'
                      'account or email to continue us',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              CustomTextFormField(
                hintText: 'Username',
                controller: usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Username';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                hintText: 'Password',
                isPassword: true,
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              InkWell(
                highlightColor: Colors.white,
                splashColor: Colors.white,
                onTap: () async {
                  await SharedPrefHelper.saveUserName(
                      usernameController.text);
                  await SharedPrefHelper.isLogin(true);
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  }
                },
                child: Container(
                  height: size.width / 7,
                  width: size.width / 2,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white, // Semi-transparent
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
