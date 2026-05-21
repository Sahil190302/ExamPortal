import 'dart:async';

import 'package:exam_portal/login_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Exam App',

      theme: ThemeData(
        useMaterial3: true,

        scaffoldBackgroundColor:
            const Color(0xffF5F7FB),

        fontFamily: 'Poppins',
      ),

      home: const SplashScreen(),
    );
  }
}

//=========================================================
// SPLASH SCREEN
//=========================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    navigateToLogin();
  }

  //---------------------------------------------------------
  // NAVIGATION
  //---------------------------------------------------------

  void navigateToLogin() {

    Timer(
      const Duration(seconds: 3),

      () {

        Navigator.pushReplacement(
          context,

          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(

          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              Color(0xff5B67F1),
              Color(0xff7A54FF),
              Color(0xff9C6BFF),
            ],
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 30,
            ),

            child: Column(
              children: [

                //-------------------------------------------------
                // TOP SPACE
                //-------------------------------------------------

                const Spacer(),

                //-------------------------------------------------
                // LOGO CONTAINER
                //-------------------------------------------------

                Center(
                  child: Container(
                    height: 150,
                    width: 150,

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(40),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.15),

                          blurRadius: 25,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),

                    child: const Icon(
                      Icons.school_rounded,
                      size: 80,
                      color: Color(0xff5B67F1),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                //-------------------------------------------------
                // APP NAME
                //-------------------------------------------------

                const Text(
                  "Aptitude Exam App",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 14),

                //-------------------------------------------------
                // SUBTITLE
                //-------------------------------------------------

                const Text(
                  "Practice aptitude, reasoning and verbal examinations with real-time test experience.",
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),

                const Spacer(),

                //-------------------------------------------------
                // LOADING INDICATOR
                //-------------------------------------------------

                Column(
                  children: [

                    const SizedBox(
                      height: 28,
                      width: 28,

                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Loading...",
                      style: TextStyle(
                        color: Colors.white
                            .withOpacity(0.9),

                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}