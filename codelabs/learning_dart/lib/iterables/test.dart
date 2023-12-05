// import "package:collection/collection.dart";
// import "./solution.dart";
// import "../mock_result.dart";

// const _result = result;

const List<Person> people = [
  (id: 1, name: "Guillaume Strasse", language: "Danish", age: 41),
  (id: 2, name: "Anestassia Echallie", language: "English", age: 47),
  (id: 3, name: "Laura Ringsell", language: "Swedish", age: 14),
  (id: 4, name: "Huey Ragsdall", language: "Latvian", age: 78),
  (id: 5, name: "Winny Pouton", language: "Danish", age: 72),
  (id: 6, name: "Franzen Fahy", language: "Swedish", age: 86),
  (id: 7, name: "Killie Spatoni", language: "English", age: 16),
  (id: 8, name: "Damaris Grebner", language: "Swedish", age: 39),
  (id: 9, name: "Haleigh Rheubottom", language: "Georgian", age: 99),
  (id: 10, name: "Anabel Bariball", language: "English", age: 13),
  (id: 11, name: "Lettie Toon", language: "Danish", age: 55),
  (id: 12, name: "Ginger Alsopp", language: "Danish", age: 75),
  (id: 13, name: "Lee Gazey", language: "English", age: 30),
  (id: 14, name: "Timotheus Gosnall", language: "English", age: 82),
  (id: 15, name: "Elsworth Huntly", language: "Korean", age: 9)
];

class TestCase<T> {
  final String name;
  final T Function(List<Person> people) func;
  final Equality<T> equality;
  final T expected;

  const TestCase(
    this.name,
    this.func,
    this.equality,
    this.expected,
  );
}

final List<TestCase> testCases = [
  TestCase("anyKids", anyKids, DefaultEquality(), true),
  TestCase("anyYoungsters", anyYoungsters, DefaultEquality(), true),
  TestCase("firstYoungster", firstYoungster, DefaultEquality(),
      (id: 3, name: "Laura Ringsell", language: "Swedish", age: 14)),
  TestCase("mapToIds", mapToIds, IterableEquality(),
      List.generate(15, (index) => index + 1)),
  TestCase(
      "findIdByName",
      (people) => findIdByName(people, name: "Lettie Toon"),
      DefaultEquality(),
      11),
  TestCase(
      "mostSpokenLanguage", mostSpokenLanguage, DefaultEquality(), "English"),
  TestCase("top3MostSpokenLanguages", top3MostSpokenLanguages,
      IterableEquality(), ["English", "Danish", "Swedish"])
];

void main() {
  final results = testCases.map((e) {
    final actual = e.func(people);
    final success = e.equality.equals(actual, e.expected);
    return (e, success: success, actual: actual);
  });
  results.forEach((e) {
    if (e.success) {
      print("\x1B[32m✅ ${e.$1.name}\x1B[0m");
    } else {
      print("\x1B[31m❌ ${e.$1.name}\x1B[0m");
      print("Expected: ${e.$1.expected}");
      print("Actual: ${e.actual}");
    }
  });
  if (results.every((element) => element.success)) {
    _result(true, ["Hurray, you did it 🥳"]);
  } else {
    _result(false, ["Not there yet!"]);
  }
}
