import 'package:exam_portal/exam_screen.dart';
import 'package:flutter/material.dart';

class InstructionScreen extends StatefulWidget {
  const InstructionScreen({super.key});

  @override
  State<InstructionScreen> createState() =>
      _InstructionScreenState();
}

class _InstructionScreenState
    extends State<InstructionScreen> {

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF5F7FB),

        title: const Text(
          "Exam Instructions",
          style: TextStyle(
            color: Color(0xff1B1D28),
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

        iconTheme: const IconThemeData(
          color: Color(0xff1B1D28),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(22),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            //-------------------------------------------------
            // TOP CARD
            //-------------------------------------------------

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(24),

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

                  Container(
                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color:
                          Colors.white.withOpacity(0.15),

                      borderRadius:
                          BorderRadius.circular(18),
                    ),

                    child: const Icon(
                      Icons.assignment_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    "Aptitude Test Instructions",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Read all instructions carefully before starting the examination.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            //-------------------------------------------------
            // TITLE
            //-------------------------------------------------

            const Text(
              "Please Follow These Rules",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff1B1D28),
              ),
            ),

            const SizedBox(height: 22),

            //-------------------------------------------------
            // INSTRUCTIONS
            //-------------------------------------------------

            Expanded(
              child: ListView(
                children: [

                  instructionTile(
                    "The examination contains 50 questions.",
                  ),

                  instructionTile(
                    "Each question carries 1 mark.",
                  ),

                  instructionTile(
                    "Every question is mandatory.",
                  ),

                  instructionTile(
                    "The exam duration is 60 minutes.",
                  ),

                  instructionTile(
                    "The exam contains Quantitative Aptitude, Reasoning and English Verbal sections.",
                  ),

                  instructionTile(
                    "The examination will auto-submit after time completion.",
                  ),

                  instructionTile(
                    "Once submitted, re-attempt is not allowed.",
                  ),

                  instructionTile(
                    "Do not refresh or close the application during exam.",
                  ),

                  instructionTile(
                    "Use Previous and Next buttons for navigation.",
                  ),
                ],
              ),
            ),

            //-------------------------------------------------
            // CHECKBOX
            //-------------------------------------------------

            Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(18),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.03),

                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),

              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Checkbox(
                    value: isChecked,

                    activeColor:
                        const Color(0xff5B67F1),

                    onChanged: (value) {

                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),

                  const SizedBox(width: 5),

                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 12),

                      child: Text(
                        "I agree to all terms and conditions of the examination.",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            //-------------------------------------------------
            // START BUTTON
            //-------------------------------------------------

            SizedBox(
              width: double.infinity,
              height: 58,

              child: ElevatedButton(

                onPressed: isChecked
                    ? () {

                        Navigator.pushReplacement(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                const ExamScreen(),
                          ),
                        );
                      }
                    : null,

                style: ElevatedButton.styleFrom(
                  elevation: 0,

                  backgroundColor:
                      const Color(0xff5B67F1),

                  disabledBackgroundColor:
                      Colors.grey.shade400,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                ),

                child: const Text(
                  "Start Test",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //---------------------------------------------------------
  // INSTRUCTION TILE
  //---------------------------------------------------------

  Widget instructionTile(String text) {

    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),

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

          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xff5B67F1),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text,
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