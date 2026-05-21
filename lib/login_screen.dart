import 'package:exam_portal/dashboard_screen.dart';
import 'package:exam_portal/services/auth_services.dart';
import 'package:exam_portal/sign_up_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 30),

              //-----------------------------------
              // TOP HEADER
              //-----------------------------------
              Center(
                child: Container(
                  height: 110,
                  width: 110,

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff5B67F1), Color(0xff7A54FF)],
                    ),

                    borderRadius: BorderRadius.circular(30),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),

                  child: const Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 55,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              //-----------------------------------
              // TITLE
              //-----------------------------------
              Center(
              child: Text(
                "Welcome ",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1B1D28),
                ),
              ),
              ),
              const SizedBox(height: 10),

              Text(
                "Login to continue your aptitude examination journey.",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              //-----------------------------------
              // EMAIL FIELD
              //-----------------------------------
              const Text(
                "Email",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: TextFormField(
                  controller: emailController,

                  keyboardType: TextInputType.emailAddress,

                  decoration: InputDecoration(
                    hintText: "Enter your email",

                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xff5B67F1),
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),

                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              //-----------------------------------
              // PASSWORD FIELD
              //-----------------------------------
              const Text(
                "Password",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,

                  decoration: InputDecoration(
                    hintText: "Enter your password",

                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      color: Color(0xff5B67F1),
                    ),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },

                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,

                        color: Colors.grey.shade600,
                      ),
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),

                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              //-----------------------------------
              // LOGIN BUTTON
              //-----------------------------------
              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton(
                  onPressed: () async {
                    //-----------------------------------
                    // VALIDATION
                    //-----------------------------------

                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all fields")),
                      );

                      return;
                    }

                    //-----------------------------------
                    // LOGIN
                    //-----------------------------------

                    String response = await AuthService.login(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );

                    //-----------------------------------
                    // SHOW MESSAGE
                    //-----------------------------------

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(response)));

                    //-----------------------------------
                    // NAVIGATION
                    //-----------------------------------

                    if (response == "Login Success") {
                      Navigator.pushReplacement(
                        context,

                        MaterialPageRoute(
                          builder: (_) => const DashboardScreen(),
                        ),
                      );
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    elevation: 0,

                    backgroundColor: const Color(0xff5B67F1),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              //-----------------------------------
              // SIGNUP
              //-----------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(builder: (_) => const SignupScreen()),
                      );
                    },

                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Color(0xff5B67F1),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
