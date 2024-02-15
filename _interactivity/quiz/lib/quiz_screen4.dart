import 'package:flutter/material.dart';

import 'quiz_model.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;
  const QuizScreen({required this.quiz, super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int index = 0;
  Quiz get questions => widget.quiz;

  _onOptionPressed(String answer) {
    setState(() {
      questions[index].answered = answer;
    });
  }

  _onNextPressed() {
    if (index < questions.length - 1) {
      setState(() {
        index++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[index];
    final number = index + 1;
    final total = questions.length;
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Quiz")),
      body: Column(
        children: [
          ..._buildProgress(number, total),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: _buildQuestion(context, currentQuestion),
          ),
          Expanded(
            child: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _buildOptions(currentQuestion)),
            ),
          )
        ],
      ),
      floatingActionButton: _buildActionButton(currentQuestion),
    );
  }

  List<Widget> _buildProgress(int number, int total) {
    return [
      LinearProgressIndicator(value: number / total),
      const SizedBox(height: 8),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [const Text('Question:'), Text('$number of $total')],
        ),
      ),
      const Divider(),
    ];
  }

  List<Widget> _buildOptions(Question question) {
    return [
      for (final option in question.options)
        if (question.answered != option)
          OutlinedButton(
              onPressed: () => _onOptionPressed(option), child: Text(option))
        else
          FilledButton(
              onPressed: () => _onOptionPressed(option), child: Text(option))
    ];
  }

  Text _buildQuestion(BuildContext context, Question question) {
    return Text(question.text,
        style: Theme.of(context).textTheme.headlineLarge);
  }

  Widget? _buildActionButton(Question currentQuestion) {
    if (currentQuestion.answered == null) return null;
    return TextButton(onPressed: _onNextPressed, child: const Text("Next"));
  }
}
