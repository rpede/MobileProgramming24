// import './solution.dart';
// import '../mock_result.dart';

// final _result = result;

typedef TestCase = (bool, List<String>) Function();

TestCase mappingTestCase(int input, String expected) {
  return () {
    final actual = dayType(input);
    return (actual == expected, ["Numeric value $input, is a $expected"]);
  };
}

TestCase errorTestCase(int input) {
  return () {
    var result = false;
    try {
      dayType(input);
    } on ArgumentError {
      result = true;
    }
    return (
      result,
      ['Numeric value $input should result in ArgumentError being thrown.']
    );
  };
}

void main() {
  final testCases = <TestCase>[
    mappingTestCase(1, "Weekday"),
    mappingTestCase(2, "Weekday"),
    mappingTestCase(3, "Weekday"),
    mappingTestCase(4, "Weekday"),
    mappingTestCase(5, "Weekday"),
    mappingTestCase(6, "Weekend"),
    mappingTestCase(7, "Weekend"),
    errorTestCase(0),
    errorTestCase(8),
  ].map((e) => e());
  if (testCases.every((element) => element.$1)) {
    _result(true, testCases.expand((e) => e.$2).toList());
  } else {
    _result(false, testCases.firstWhere((e) => e.$1 == false).$2);
  }
}
