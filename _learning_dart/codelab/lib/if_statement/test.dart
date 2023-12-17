// import './solution.dart';
// import '../mock_result.dart';

// final _result = result;

void main() {
  final List<(int, double, bool)> testCases = [
    (15, 5.0, false),
    (16, 16.5, false),
    (16, 16.4, true),
    (17, 16.5, false),
    (17, 16.4, true),
    (18, 37, true),
  ];
  final results = testCases.map((e) {
    final (age, alc, expected) = e;
    final bool actual = canBuyAlcohol(age, alc);
    final success = actual == expected;
    final msg =
        'A person aged $age ${expected ? "can" : "can not"} buy beverages with $alc% alcohol';
    return (success, msg);
  });
  if (results.any((element) => !element.$1)) {
    _result(false, results.where((e) => !e.$1).map((e) => e.$2).toList());
  } else {
    _result(true, results.map((e) => e.$2).toList());
  }
}
