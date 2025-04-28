import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import '../core/shared_pref_helper.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  _OnboardScreenState createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen>
    with TickerProviderStateMixin {
  late AnimationController controller1;
  late AnimationController controller2;
  late Animation<double> animation1;
  late Animation<double> animation2;
  late Animation<double> animation3;
  late Animation<double> animation4;

  @override
  void initState() {
    super.initState();
    checkIsLogged();

    controller1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    animation1 = Tween<double>(begin: .1, end: .15).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut,
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller1.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller1.forward();
        }
      });

    animation2 = Tween<double>(begin: .02, end: .04).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    animation3 = Tween<double>(begin: .41, end: .38).animate(
      CurvedAnimation(
        parent: controller2,
        curve: Curves.easeInOut,
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller2.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller2.forward();
        }
      });

    animation4 = Tween<double>(begin: 170, end: 190).animate(
      CurvedAnimation(
        parent: controller2,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    Timer(const Duration(milliseconds: 2500), () {
      controller1.forward();
    });

    controller2.forward();
  }

  bool isLogged = false;

  checkIsLogged() async {
    bool isLogin = SharedPrefHelper.getIsLogin() ?? false;

    if (isLogin) {
      isLogged = true;
    } else {
      isLogged = false;
    }

  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [

              // Background shapes

              Positioned(
                top: size.height * (animation2.value + .58),
                left: size.width * .21,
                child: CustomPaint(painter: MyPainter(50)),
              ),
              Positioned(
                top: size.height * .98,
                left: size.width * .1,
                child: CustomPaint(painter: MyPainter(animation4.value - 30)),
              ),
              Positioned(
                top: size.height * .5,
                left: size.width * (animation2.value + .8),
                child: CustomPaint(painter: MyPainter(30)),
              ),
              Positioned(
                top: size.height * animation3.value,
                left: size.width * (animation1.value + .1),
                child: CustomPaint(painter: MyPainter(60)),
              ),
              Positioned(
                top: size.height * .1,
                left: size.width * .8,
                child: CustomPaint(painter: MyPainter(animation4.value)),
              ),

              // Full screen blur
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    color: Colors.black.withOpacity(0.05),
                  ),
                ),
              ),

              // Text and Button
              Positioned(
                top: size.height * .1,
                right: size.width * .1,
                left: size.width * .1,
                child: const Text(
                  'Do your\ntasks\nquickly\nand easy',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 64,
                    fontWeight: FontWeight.w300,
                  ),
                  maxLines: 4,
                  textAlign: TextAlign.start,
                ),
              ),

              Positioned(
                top: size.height * .52,
                right: size.width * .2,
                left: size.width * .1,
                child: const Text(
                  'Your tasks, your rules, our support.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),

              Positioned(
                bottom: size.height * .26,
                left: size.width * .28,
                right: size.width * .28,
                child: InkWell(
                  highlightColor: Colors.white,
                  splashColor: Colors.white,
                  onTap: () {
                    if (isLogged) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: size.width / 7,
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
                      'Start',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                      ),
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

// Painter
class MyPainter extends CustomPainter {
  final double radius;

  MyPainter(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xffca87f4), Color(0xff9464c8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
        Rect.fromCircle(center: const Offset(0, 0), radius: radius),
      );

    canvas.drawCircle(Offset.zero, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
