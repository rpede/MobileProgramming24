import 'quiz_model.dart';

final Quiz quiz = [
  Question(
    "What is Flutter?",
    options: [
      "Cloud computing platform",
      "Insect",
      "UI framework",
      "Programming language"
    ],
    correct: "UI framework",
  ),
  Question("What platforms are supported by Flutter?",
      options: [
        "Desktop, web and mobile",
        "Mobile (iOS & Android)",
        "Only Android",
        "Web and mobile"
      ],
      correct: "Desktop, web and mobile"),
  Question(
    "Does Flutter render its UI in a WebView?",
    options: ["Yes", "No"],
    correct: 'No',
  ),
  Question(
    "What programming language are Flutter apps primarily written in?",
    options: [
      "Swift",
      "Dart",
      "Java",
      "TypeScript",
    ],
    correct: 'Dart',
  ),
  Question(
    'What is the widget tree in Flutter?',
    options: [
      "The hierarchy of UI elements in a Flutter app",
      "A visual representation of app screens",
      "A structure used for database storage",
    ],
    correct: 'The hierarchy of UI elements in a Flutter app',
  ),
  Question(
    "What is the purpose of the setState method in Flutter?",
    options: [
      "To set the state of the entire app",
      "To update the UI based on changes in the app's state",
      "To define the initial state of a Flutter widget",
    ],
    correct: "To update the UI based on changes in the app's state",
  ),
  Question(
    "What is the BuildContext used for?",
    options: [
      "Nothing",
      "Used to define color scheme of the app",
      "Data storage class for managing app state",
      "Provides information about the widget hierarchy",
    ],
    correct: "Provides information about the widget hierarchy",
  ),
];
