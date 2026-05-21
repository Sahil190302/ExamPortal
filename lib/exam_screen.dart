import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'result_screen.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() =>
      _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {

  //---------------------------------------------------------
  // VARIABLES
  //---------------------------------------------------------

  List<dynamic> allQuestions = [];

  int currentQuestionIndex = 0;

  Map<int, String> selectedAnswers = {};

  bool isLoading = true;

  int obtainedMarks = 0;

int cutoffMarks = 20;

bool isPassed = false;

  //---------------------------------------------------------
  // TIMER
  //---------------------------------------------------------

  Timer? timer;

  int totalSeconds = 60 * 60;

  //---------------------------------------------------------
  // INIT
  //---------------------------------------------------------

  @override
  void initState() {
    super.initState();

    loadQuestions();
    startTimer();
  }

  //---------------------------------------------------------
  // LOAD QUESTIONS
  //---------------------------------------------------------

  Future<void> loadQuestions() async {

  try {

    //---------------------------------------------------------
    // LOAD JSON FILES
    //---------------------------------------------------------

    String challengeJson =
        await rootBundle.loadString(
      'assets/challenge_test.json',
    );

    String normalJson =
        await rootBundle.loadString(
      'assets/questions.json',
    );

    //---------------------------------------------------------
    // DECODE
    //---------------------------------------------------------

    List<dynamic> challengeQuestions =
        jsonDecode(challengeJson);

    List<dynamic> normalQuestions =
        jsonDecode(normalJson);

    //---------------------------------------------------------
    // FILTER VALID QUESTIONS
    //---------------------------------------------------------

    List<dynamic> validChallengeQuestions =
        challengeQuestions.where((question) {

      try {

        //---------------------------------------------------------
        // VALIDATION
        //---------------------------------------------------------

        bool hasProblem =
            question["Problem"] != null &&
            question["Problem"]
                .toString()
                .trim()
                .isNotEmpty;

        bool hasOptions =
            question["options"] != null &&
            question["options"]
                .toString()
                .contains("a");

        bool hasCorrect =
            question["correct"] != null;

        return
            hasProblem &&
            hasOptions &&
            hasCorrect;

      } catch (e) {

        return false;
      }

    }).toList();

    //---------------------------------------------------------
    // FILTER SECOND JSON
    //---------------------------------------------------------

    List<dynamic> validNormalQuestions =
        normalQuestions.where((question) {

      try {

        return
            question["question"] != null &&
            question["A"] != null &&
            question["B"] != null &&
            question["C"] != null &&
            question["D"] != null &&
            question["answer"] != null;

      } catch (e) {

        return false;
      }

    }).toList();

    //---------------------------------------------------------
    // MERGE
    //---------------------------------------------------------

    allQuestions = [
      ...validChallengeQuestions,
      ...validNormalQuestions,
    ];

    //---------------------------------------------------------
    // SHUFFLE
    //---------------------------------------------------------

    allQuestions.shuffle();

    //---------------------------------------------------------
    // TAKE 50
    //---------------------------------------------------------

    allQuestions =
        allQuestions.take(50).toList();

    setState(() {
      isLoading = false;
    });

  } catch (e) {

    debugPrint(e.toString());
  }
}

  //---------------------------------------------------------
  // TIMER
  //---------------------------------------------------------

  void startTimer() {

    timer = Timer.periodic(
      const Duration(seconds: 1),

      (timer) {

        if (totalSeconds > 0) {

          setState(() {
            totalSeconds--;
          });

        } else {

          timer.cancel();

          autoSubmitExam();
        }
      },
    );
  }

  //---------------------------------------------------------
  // FORMAT TIMER
  //---------------------------------------------------------

  String formatTime(int seconds) {

    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    return
        "${minutes.toString().padLeft(2, '0')}:"
        "${remainingSeconds.toString().padLeft(2, '0')}";
  }

  //---------------------------------------------------------
  // GET QUESTION
  //---------------------------------------------------------

  dynamic get currentQuestion =>
      allQuestions[currentQuestionIndex];

  //---------------------------------------------------------
  // OPTIONS
  //---------------------------------------------------------

  List<Map<String, String>> getOptions(
      dynamic question) {

    //---------------------------------------------------------
    // FIRST JSON FORMAT
    //---------------------------------------------------------

    if (question.containsKey("options")) {

      String optionsString =
          question["options"];

      List<String> splitOptions =
          optionsString.split(",");

      return splitOptions.map((option) {

        String trimmed =
            option.trim();

        String key =
            trimmed.substring(0, 1);

        String value =
            trimmed.substring(3);

        return {
          "key": key,
          "value": value,
        };

      }).toList();
    }

    //---------------------------------------------------------
    // SECOND JSON FORMAT
    //---------------------------------------------------------

    return [
      {
        "key": "A",
        "value": question["A"],
      },
      {
        "key": "B",
        "value": question["B"],
      },
      {
        "key": "C",
        "value": question["C"],
      },
      {
        "key": "D",
        "value": question["D"],
      },
    ];
  }

  //---------------------------------------------------------
  // SUBMIT EXAM
  //---------------------------------------------------------

Future<void> submitExam() async {

  timer?.cancel();

  //---------------------------------------------------------
  // CALCULATE MARKS
  //---------------------------------------------------------

  obtainedMarks = 0;

  for (int i = 0; i < allQuestions.length; i++) {

    dynamic question = allQuestions[i];

    String selectedAnswer =
        selectedAnswers[i] ?? "";

    //---------------------------------------------------------
    // GET CORRECT ANSWER
    //---------------------------------------------------------

    String correctAnswer = "";

    if (question.containsKey("correct")) {

      correctAnswer =
          question["correct"]
              .toString()
              .trim()
              .toLowerCase();

    } else {

      correctAnswer =
          question["answer"]
              .toString()
              .trim()
              .toUpperCase();
    }

    //---------------------------------------------------------
    // COMPARE
    //---------------------------------------------------------

    if (selectedAnswer
            .trim()
            .toLowerCase() ==
        correctAnswer) {

      obtainedMarks++;
    }
  }

  //---------------------------------------------------------
  // PASS CHECK
  //---------------------------------------------------------

  isPassed =
      obtainedMarks >= cutoffMarks;

  //---------------------------------------------------------
  // SAVE SUBMISSION
  //---------------------------------------------------------

  SharedPreferences prefs =
      await SharedPreferences.getInstance();

  String email =
      prefs.getString("currentUserEmail") ?? "";

  await prefs.setBool(
    "${email}_submitted",
    true,
  );

  //---------------------------------------------------------
  // NAVIGATE
  //---------------------------------------------------------

  Navigator.pushReplacement(
    context,

    MaterialPageRoute(
      builder: (_) => ResultScreen(
        marks: obtainedMarks,
        cutoffMarks: cutoffMarks,
        isPassed: isPassed,
      ),
    ),
  );
}

  //---------------------------------------------------------
  // AUTO SUBMIT
  //---------------------------------------------------------

  void autoSubmitExam() {

    submitExam();
  }

  //---------------------------------------------------------
  // SUBMIT DIALOG
  //---------------------------------------------------------

  void showSubmitDialog() {

    showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),

          title: const Text(
            "Submit Exam",
          ),

          content: const Text(
            "Are you sure you want to submit the examination?",
          ),

          actions: [

            TextButton(
              onPressed: () {

                Navigator.pop(context);
              },

              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {

                Navigator.pop(context);

                submitExam();
              },

              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xff5B67F1),
              ),

              child: const Text(
                "Submit",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  //---------------------------------------------------------
  // DISPOSE
  //---------------------------------------------------------

  @override
  void dispose() {

    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //---------------------------------------------------------
    // LOADING
    //---------------------------------------------------------

    if (isLoading) {

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    //---------------------------------------------------------
    // QUESTION
    //---------------------------------------------------------

    final question = currentQuestion;

    final options = getOptions(question);

    return Scaffold(

      backgroundColor:
          const Color(0xffF5F7FB),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(

            children: [

              //---------------------------------------------------------
              // TOP BAR
              //---------------------------------------------------------

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      const Text(
                        "Aptitude Examination",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        "Question ${currentQuestionIndex + 1}/50",
                        style: TextStyle(
                          color:
                              Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  //---------------------------------------------------------
                  // TIMER
                  //---------------------------------------------------------

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(18),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.04),

                          blurRadius: 10,
                          offset:
                              const Offset(0, 5),
                        ),
                      ],
                    ),

                    child: Row(
                      children: [

                        const Icon(
                          Icons.timer_outlined,
                          color:
                              Color(0xff5B67F1),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          formatTime(
                              totalSeconds),

                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,

                            color:
                                Color(0xff5B67F1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              //---------------------------------------------------------
              // QUESTION CARD
              //---------------------------------------------------------

              Expanded(
                child: SingleChildScrollView(
                  child: Container(

                    width: double.infinity,

                    padding:
                        const EdgeInsets.all(22),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(28),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.03),

                          blurRadius: 10,
                          offset:
                              const Offset(0, 5),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        //---------------------------------------------------------
                        // CATEGORY
                        //---------------------------------------------------------

                        if (question["category"] !=
                            null)

                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),

                            decoration:
                                BoxDecoration(
                              color:
                                  const Color(
                                      0xffEEF1FF),

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          30),
                            ),

                            child: Text(
                              question[
                                  "category"],

                              style:
                                  const TextStyle(
                                color: Color(
                                    0xff5B67F1),

                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),

                        const SizedBox(height: 25),

                        //---------------------------------------------------------
                        // QUESTION
                        //---------------------------------------------------------

                        Text(
                          question["Problem"] ??
                              question["question"],

                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,

                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 30),

                        //---------------------------------------------------------
                        // OPTIONS
                        //---------------------------------------------------------

                        ...options.map((option) {

                          bool isSelected =
                              selectedAnswers[
                                      currentQuestionIndex] ==
                                  option["key"];

                          return GestureDetector(

                            onTap: () {

                              setState(() {

                                selectedAnswers[
                                        currentQuestionIndex] =
                                    option["key"]!;
                              });
                            },

                            child: Container(

                              margin:
                                  const EdgeInsets
                                      .only(
                                bottom: 18,
                              ),

                              padding:
                                  const EdgeInsets
                                      .all(18),

                              decoration:
                                  BoxDecoration(

                                color: isSelected
                                    ? const Color(
                                        0xffEEF1FF)
                                    : Colors.white,

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            18),

                                border: Border.all(
                                  color: isSelected
                                      ? const Color(
                                          0xff5B67F1)
                                      : Colors
                                          .grey
                                          .shade300,

                                  width: 1.5,
                                ),
                              ),

                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [

                                  Container(
                                    height: 32,
                                    width: 32,

                                    decoration:
                                        BoxDecoration(

                                      color: isSelected
                                          ? const Color(
                                              0xff5B67F1)
                                          : Colors
                                              .grey
                                              .shade200,

                                      shape: BoxShape
                                          .circle,
                                    ),

                                    child: Center(
                                      child: Text(
                                        option[
                                            "key"]!,

                                        style:
                                            TextStyle(
                                          color: isSelected
                                              ? Colors
                                                  .white
                                              : Colors
                                                  .black,

                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                      width: 15),

                                  Expanded(
                                    child: Text(
                                      option[
                                          "value"]!,

                                      style:
                                          const TextStyle(
                                        fontSize:
                                            16,

                                        height:
                                            1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              //---------------------------------------------------------
              // BUTTONS
              //---------------------------------------------------------

              Row(
                children: [

                  //---------------------------------------------------------
                  // PREVIOUS
                  //---------------------------------------------------------

                  Expanded(
                    child: ElevatedButton(

                      onPressed:
                          currentQuestionIndex == 0
                              ? null
                              : () {

                                  setState(() {

                                    currentQuestionIndex--;
                                  });
                                },

                      style: ElevatedButton.styleFrom(
                        elevation: 0,

                        backgroundColor:
                            Colors.white,

                        foregroundColor:
                            const Color(
                                0xff5B67F1),

                        padding:
                            const EdgeInsets
                                .symmetric(
                          vertical: 16,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(18),
                        ),
                      ),

                      child: const Text(
                        "Previous",
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  //---------------------------------------------------------
                  // NEXT
                  //---------------------------------------------------------

                  Expanded(
                    child: ElevatedButton(

                      onPressed:
                          currentQuestionIndex == 49
                              ? null
                              : () {

                                  setState(() {

                                    currentQuestionIndex++;
                                  });
                                },

                      style: ElevatedButton.styleFrom(
                        elevation: 0,

                        backgroundColor:
                            const Color(
                                0xff5B67F1),

                        padding:
                            const EdgeInsets
                                .symmetric(
                          vertical: 16,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(18),
                        ),
                      ),

                      child: const Text(
                        "Next",

                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              //---------------------------------------------------------
              // SUBMIT BUTTON
              //---------------------------------------------------------

              SizedBox(
                width: double.infinity,
                height: 56,

                child: ElevatedButton(

                  onPressed:
                      showSubmitDialog,

                  style: ElevatedButton.styleFrom(
                    elevation: 0,

                    backgroundColor:
                        Colors.green,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                              18),
                    ),
                  ),

                  child: const Text(
                    "Submit Test",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
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
    );
  }
}