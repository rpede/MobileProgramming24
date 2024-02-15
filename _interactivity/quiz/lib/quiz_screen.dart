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
  bool done = false;

  Quiz get questions => widget.quiz;

  _onOptionPressed(String answer) {
    setState(() {
      questions[index].answered = answer;
    });
  }

  _onNextPressed() {
    assert(index < questions.length - 1);
    setState(() {
      index++;
    });
  }

  _onDonePressed(BuildContext context) {
    setState(() {
      done = true;
    });
    final correct =
        questions.where((element) => element.answered == element.correct);
    final allCorrect = correct.length == questions.length;
    final controller = showBottomSheet(
        context: context,
        builder: (context) => _buildBottomSheet(context, allCorrect));
    Future.delayed(const Duration(seconds: 5))
        .then((_) => controller.close())
        .then((value) {
      setState(() {
        index = 0;
        done = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[index];
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Quiz")),
      body: Column(
        children: [
          ..._buildProgress(),
          _buildQuestion(context, currentQuestion),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _buildOptions(currentQuestion),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: _buildActionButton(currentQuestion),
    );
  }

  List<Widget> _buildProgress() {
    final number = index + 1;
    final total = questions.length;
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

  Widget _buildQuestion(BuildContext context, Question question) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child:
          Text(question.text, style: Theme.of(context).textTheme.headlineLarge),
    );
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

  Widget? _buildActionButton(Question currentQuestion) {
    if (done || currentQuestion.answered == null) return null;
    if (index < questions.length - 1) {
      return TextButton(onPressed: _onNextPressed, child: const Text("Next"));
    } else {
      return Builder(
        builder: (context) => TextButton(
            onPressed: () => _onDonePressed(context),
            child: const Text("Done")),
      );
    }
  }

  Widget _buildBottomSheet(BuildContext context, bool allCorrect) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Container(
        color: allCorrect ? Colors.green : Colors.red,
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                  allCorrect
                      ? "Hurray 🥳, you are a true expert!"
                      : "😥 you can do better!",
                  style: textTheme.headlineSmall),
            ])),
      ),
    );
  }
}
