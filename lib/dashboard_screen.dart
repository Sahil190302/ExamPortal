import 'package:exam_portal/instructions_screen.dart';
import 'package:exam_portal/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  String userName = "";

  bool alreadySubmitted = false;

  @override
  void initState() {
    super.initState();

    loadUserData();
  }

  //---------------------------------------------------------
  // LOAD USER DATA
  //---------------------------------------------------------

  Future<void> loadUserData() async {

    userName = await AuthService.getUserName();

    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    String email =
        prefs.getString("currentUserEmail")?? "";

    alreadySubmitted =
        prefs.getBool("${email}_submitted") ?? false;

    setState(() {});
  }

  //---------------------------------------------------------
  // LOGOUT
  //---------------------------------------------------------

  Future<void> logout() async {

    await AuthService.logout();

    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),

      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      body: SafeArea(
        child: SingleChildScrollView(

          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 18,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              //-------------------------------------------------
              // TOP BAR
              //-------------------------------------------------

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      const Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        "Hey $userName 👋",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1B1D28),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(15),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.04),

                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),

                    child: IconButton(
                      onPressed: logout,

                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              //-------------------------------------------------
              // EXAM CARD
              //-------------------------------------------------

              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(

                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff5B67F1),
                      Color(0xff7A54FF),
                    ],
                  ),

                  borderRadius:
                      BorderRadius.circular(28),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple
                          .withOpacity(0.25),

                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    //-------------------------------------------------
                    // ICON
                    //-------------------------------------------------

                    Container(
                      padding: const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.15),

                        borderRadius:
                            BorderRadius.circular(18),
                      ),

                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),

                    const SizedBox(height: 22),

                    //-------------------------------------------------
                    // TITLE
                    //-------------------------------------------------

                    const Text(
                      "Aptitude Examination",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Test your aptitude, reasoning, verbal and quantitative skills.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 25),

                    //-------------------------------------------------
                    // INFO BOX
                    //-------------------------------------------------

                    Container(
                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(0.12),

                        borderRadius:
                            BorderRadius.circular(18),
                      ),

                      child: Column(
                        children: [

                          examTile(
                            icon: Icons.timer_outlined,
                            title: "Duration",
                            value: "60 Minutes",
                          ),

                          const SizedBox(height: 15),

                          examTile(
                            icon: Icons.quiz_outlined,
                            title: "Questions",
                            value: "50 Questions",
                          ),

                          const SizedBox(height: 15),

                          examTile(
                            icon: Icons.star_outline_rounded,
                            title: "Marks",
                            value: "50 Marks",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    //-------------------------------------------------
                    // START BUTTON
                    //-------------------------------------------------

                    SizedBox(
                      width: double.infinity,
                      height: 55,

                      child: ElevatedButton(

                        onPressed: alreadySubmitted
                            ? null
                            : () {

                                Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const InstructionScreen(),
                                  ),
                                );
                              },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor:
                              const Color(0xff5B67F1),

                          disabledBackgroundColor:
                              Colors.grey.shade400,

                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                        ),

                        child: Text(
                          alreadySubmitted
                              ? "Already Attempted"
                              : "Start Examination",

                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              //-------------------------------------------------
              // INSTRUCTIONS TITLE
              //-------------------------------------------------

              const Text(
                "Test Instructions",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1B1D28),
                ),
              ),

              const SizedBox(height: 20),

              //-------------------------------------------------
              // INSTRUCTIONS
              //-------------------------------------------------

              instructionTile(
                "Every question is mandatory.",
              ),

              instructionTile(
                "The test contains Quant, Reasoning and Verbal sections.",
              ),

              instructionTile(
                "Once submitted, the test cannot be attempted again.",
              ),

              instructionTile(
                "The exam will auto-submit after time completion.",
              ),

              instructionTile(
                "Do not close the application during examination.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  //---------------------------------------------------------
  // EXAM TILE
  //---------------------------------------------------------

  Widget examTile({
    required IconData icon,
    required String title,
    required String value,
  }) {

    return Row(
      children: [

        Icon(
          icon,
          color: Colors.white,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  //---------------------------------------------------------
  // INSTRUCTION TILE
  //---------------------------------------------------------

  Widget instructionTile(String title) {

    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      padding: const EdgeInsets.all(18),

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

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Container(
            margin: const EdgeInsets.only(top: 3),

            child: const Icon(
              Icons.check_circle_rounded,
              color: Color(0xff5B67F1),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}