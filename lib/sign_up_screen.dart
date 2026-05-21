import 'package:exam_portal/services/auth_services.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              //-----------------------------------------
              // BACK BUTTON
              //-----------------------------------------

              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),

              const SizedBox(height: 10),

              //-----------------------------------------
              // TOP ICON
              //-----------------------------------------

              Center(
                child: Container(
                  height: 100,
                  width: 100,

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff5B67F1),
                        Color(0xff7A54FF),
                      ],
                    ),

                    borderRadius: BorderRadius.circular(28),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.25),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),

                  child: const Icon(
                    Icons.person_add_alt_1_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              //-----------------------------------------
              // TITLE
              //-----------------------------------------

              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1B1D28),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Register to start your aptitude examination.",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 35),

              //-----------------------------------------
              // NAME FIELD
              //-----------------------------------------

              const Text(
                "Full Name",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 12),

              customTextField(
                controller: nameController,
                hint: "Enter your full name",
                icon: Icons.person_outline_rounded,
              ),

              const SizedBox(height: 22),

              //-----------------------------------------
              // EMAIL FIELD
              //-----------------------------------------

              const Text(
                "Email",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 12),

              customTextField(
                controller: emailController,
                hint: "Enter your email",
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 22),

              //-----------------------------------------
              // PASSWORD FIELD
              //-----------------------------------------

              const Text(
                "Password",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 12),

              customPasswordField(
                controller: passwordController,
                hint: "Enter password",
                obscure: obscurePassword,

                onTap: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
              ),

              const SizedBox(height: 22),

              //-----------------------------------------
              // CONFIRM PASSWORD
              //-----------------------------------------

              const Text(
                "Confirm Password",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 12),

              customPasswordField(
                controller: confirmPasswordController,
                hint: "Confirm password",
                obscure: obscureConfirmPassword,

                onTap: () {
                  setState(() {
                    obscureConfirmPassword =
                        !obscureConfirmPassword;
                  });
                },
              ),

              const SizedBox(height: 35),

              //-----------------------------------------
              // SIGNUP BUTTON
              //-----------------------------------------

              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton(
                onPressed: () async {

  //-----------------------------------------
  // VALIDATION
  //-----------------------------------------

  if(nameController.text.isEmpty ||
      emailController.text.isEmpty ||
      passwordController.text.isEmpty ||
      confirmPasswordController.text.isEmpty){

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please fill all fields"),
      ),
    );

    return;
  }

  //-----------------------------------------
  // PASSWORD MATCH
  //-----------------------------------------

  if(passwordController.text !=
      confirmPasswordController.text){

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Passwords do not match"),
      ),
    );

    return;
  }

  //-----------------------------------------
  // SIGNUP
  //-----------------------------------------

  String response = await AuthService.signup(
    name: nameController.text.trim(),
    email: emailController.text.trim(),
    password: passwordController.text.trim(),
  );

  //-----------------------------------------
  // RESPONSE
  //-----------------------------------------

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(response),
    ),
  );

  //-----------------------------------------
  // NAVIGATE TO LOGIN
  //-----------------------------------------

  if(response == "Signup Success"){

    Navigator.pop(context);
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
                    "Create Account",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              //-----------------------------------------
              // LOGIN OPTION
              //-----------------------------------------

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 15,
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Color(0xff5B67F1),
                        fontWeight: FontWeight.bold,
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

  //---------------------------------------------------------
  // CUSTOM TEXT FIELD
  //---------------------------------------------------------

  Widget customTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {

    return Container(
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
        controller: controller,

        decoration: InputDecoration(
          hintText: hint,

          prefixIcon: Icon(
            icon,
            color: const Color(0xff5B67F1),
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),

          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
          ),
        ),
      ),
    );
  }

  //---------------------------------------------------------
  // CUSTOM PASSWORD FIELD
  //---------------------------------------------------------

  Widget customPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onTap,
  }) {

    return Container(
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
        controller: controller,
        obscureText: obscure,

        decoration: InputDecoration(
          hintText: hint,

          prefixIcon: const Icon(
            Icons.lock_outline_rounded,
            color: Color(0xff5B67F1),
          ),

          suffixIcon: IconButton(
            onPressed: onTap,

            icon: Icon(
              obscure
                  ? Icons.visibility_off
                  : Icons.visibility,

              color: Colors.grey.shade600,
            ),
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),

          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
          ),
        ),
      ),
    );
  }
}