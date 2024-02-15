import 'package:flutter/material.dart';

import 'quiz_model.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Quiz")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text("What is Dart?",
                style: Theme.of(context).textTheme.headlineLarge),
          ),
          Expanded(
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                OutlinedButton(
                  onPressed: () {},
                  child: Text("Ranged weapon"),
                ),
                FilledButton(
                  onPressed: () {},
                  child: Text("Programming language"),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}
