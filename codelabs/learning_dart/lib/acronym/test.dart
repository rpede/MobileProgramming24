// import "./solution.dart";
// import "../mock_result.dart";

// const _result = result;

class TestCase {
  String text;
  String abbr;
  String msg;
  TestCase(this.text, {required this.abbr, required this.msg});
}

void main() {
  final testCases = [
    TestCase("Joint Photographic Experts Group",
        abbr: "JPEG", msg: "Abbreviates text with title case"),
    TestCase("Secure by Design",
        abbr: "SBD", msg: "Abbreviates text with lower case"),
    TestCase("HyperText Transfer Protocol Secure",
        abbr: "HTTPS", msg: "Abbreviates text with mixed case"),
    TestCase("Last in. First out", abbr: "LIFO", msg: "Ignores punctuation"),
    TestCase("You only live once 👶💣🪦", abbr: "YOLO", msg: "Ignores emojis")
  ];
  final failures = testCases.where(
      (testCase) => Acronym.abbreviate(text: testCase.text) != testCase.abbr);
  if (failures.isNotEmpty) {
    _result(false, [...failures.map((e) => e.msg)]);
  } else {
    _result(true, ["Hurray, you did it 🥳"]);
  }
}
