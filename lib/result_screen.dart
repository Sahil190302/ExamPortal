import 'package:flutter/material.dart';

import 'dashboard_screen.dart';

class ResultScreen extends StatelessWidget {

  final int marks;
  final int cutoffMarks;
  final bool isPassed;

  const ResultScreen({
    super.key,
    required this.marks,
    required this.cutoffMarks,
    required this.isPassed,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xffF5F7FB),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(22),

          child: Container(

            width: double.infinity,

            padding: const EdgeInsets.all(28),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(32),

              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withOpacity(0.05),

                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [

                  //---------------------------------------------------------
                  // ICON
                  //---------------------------------------------------------

                  Container(
                    height: 130,
                    width: 130,

                    decoration: BoxDecoration(

                      color: isPassed
                          ? Colors.green
                              .withOpacity(0.12)
                          : Colors.red
                              .withOpacity(0.12),

                      shape: BoxShape.circle,
                    ),

                    child: Icon(

                      isPassed
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,

                      size: 80,

                      color: isPassed
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),

                  const SizedBox(height: 30),

                  //---------------------------------------------------------
                  // TITLE
                  //---------------------------------------------------------

                  Text(

                    isPassed
                        ? "Congratulations"
                        : "Better Luck Next Time",

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,

                      color: isPassed
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),

                  const SizedBox(height: 25),

                  //---------------------------------------------------------
                  // MESSAGE
                  //---------------------------------------------------------

                  Text(

                    isPassed

                        ? "Your Test is successfully examined by our AI experts.\n\nCongratulations! You have successfully cleared the Test.\n\nYou will be notified by HR Team regarding next round."

                        : "Your Test is successfully examined by our AI experts.\n\nThankyou for participating in the test.\n\nUnfortunately you are not going to be proceed towards next round.\n\nWe wish you best for future endeavours.",

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 35),

                  //---------------------------------------------------------
                  // SCORE CARD
                  //---------------------------------------------------------

                  Container(

                    padding: const EdgeInsets.all(22),

                    decoration: BoxDecoration(

                      color: const Color(0xffF5F7FB),

                      borderRadius:
                          BorderRadius.circular(22),
                    ),

                    child: Column(
                      children: [

                        scoreTile(
                          title: "Your Marks",
                          value: "$marks / 50",
                        ),

                        const SizedBox(height: 18),

                        scoreTile(
                          title: "Cutoff Marks",
                          value: "$cutoffMarks / 50",
                        ),

                        const SizedBox(height: 18),

                        scoreTile(
                          title: "Result Status",
                          value:
                              isPassed
                                  ? "Qualified"
                                  : "Not Qualified",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  //---------------------------------------------------------
                  // BUTTON
                  //---------------------------------------------------------

                  SizedBox(
                    width: double.infinity,
                    height: 58,

                    child: ElevatedButton(

                      onPressed: () {

                        Navigator.pushAndRemoveUntil(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                const DashboardScreen(),
                          ),

                          (route) => false,
                        );
                      },

                      style:
                          ElevatedButton.styleFrom(

                        elevation: 0,

                        backgroundColor:
                            const Color(0xff5B67F1),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  18),
                        ),
                      ),

                      child: const Text(
                        "Back To Dashboard",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //---------------------------------------------------------
  // SCORE TILE
  //---------------------------------------------------------

  Widget scoreTile({
    required String title,
    required String value,
  }) {

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [

        Text(
          title,

          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
          ),
        ),

        Text(
          value,

          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xff1B1D28),
          ),
        ),
      ],
    );
  }
}