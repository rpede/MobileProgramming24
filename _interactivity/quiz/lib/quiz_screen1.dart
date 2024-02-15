import 'package:flutter/material.dart';

import 'quiz_model.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Quiz")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: _buildQuestion(context),
          ),
          Expanded(
            child: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.min, children: _buildOptions()),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildOptions() {
    return [
      OutlinedButton(
        onPressed: () {},
        child: Text("Ranged weapon"),
      ),
      FilledButton(
        onPressed: () {},
        child: Text("Programming language"),
      )
    ];
  }

  Text _buildQuestion(BuildContext context) {
    return Text("What is Dart?",
        style: Theme.of(context).textTheme.headlineLarge);
  }
}
