import 'package:flutter/material.dart';
import 'package:quiz_app/start_screen.dart';
import 'package:quiz_app/questions_screen.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});
  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  var activeScreen = 'start-screen';
  // Widget? activeScreen ;

  void switchScreen() {
    setState(() {
      activeScreen = 'questions_screen';
    });
  }

  @override
  Widget build(context) {
    Widget screenWidget =StartScreen(switchScreen);
    
    if (activeScreen == 'questions_screen'){
       screenWidget = const QuestionsScreen(); 
    }
             

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 82, 23, 185),
                Color.fromARGB(255, 104, 57, 186),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: screenWidget,
          // child: activeScreen == 'start-screen'
          //     ? StartScreen(switchScreen)
          //     : const QuestionsScreen(),
        ),
      ),
    );
  }
}