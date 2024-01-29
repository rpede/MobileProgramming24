// import './solution.dart';
// import '../mock_result.dart';

// final _result = result;

typedef TestCase = (String, dynamic);

void main() {
  final testCases = <TestCase>[
    ('12', 'A'),
    ('10', 'B'),
    ('7', 'C'),
    ('4', 'D'),
    ('02', 'E'),
    ('00', 'Fx'),
    ('-3', 'F'),
  ];
  final results = testCases.map((testCase) {
    final (String input, String expected) = testCase;
    final actual = convertGrade(input);
    if (actual == expected) {
      return (true, ['"$input" converted to "$expected"']);
    } else {
      return (
        false,
        ['"$input" got converted to "$actual", but should be "$expected"']
      );
    }
  }).toList();
  if (results.every((element) => element.$1)) {
    _result(true, results.expand((e) => e.$2).toList());
  } else {
    _result(false, results.firstWhere((e) => e.$1 == false).$2);
  }
}
