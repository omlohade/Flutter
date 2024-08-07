import'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

class StartScreen extends StatelessWidget{
  const StartScreen (this.startQuiz, {super.key});

  final void Function() startQuiz;

  @override
  Widget build(context){
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
              'assets/images/quiz-logo.png',
              width:300,
              color:const Color.fromARGB(157, 253, 251, 251),
              ),
          // Opacity(
          //   opacity: 0.6,
          //   child :Image.asset(
          //     'assets/images/quiz-logo.png',
          //     width:300)
          // ),
          const SizedBox(height: 80),
          const Text(
            'Learn Flutter the fun way!',
            style: TextStyle(
              color: Color.fromARGB(255, 225, 201, 250),
              fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed:startQuiz,
              // onPressed:  (){
              //   startQuiz();
              // },
             style:OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
             ),
             icon: const Icon(Icons.arrow_right_alt),
             label: const Text('Start Quiz',
             ),
             ),
        ],
      ),
    );
  }
}