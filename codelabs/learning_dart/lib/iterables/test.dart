/*
*/

void main() {
    final List<Person> people = [
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

  final Map<String, bool Function()> testCases = {
    "anyKids": () => anyKids(people),
    "anyYoungsters": () => anyYoungsters(people),
    "firstYoungster": () =>
        firstYoungster(people) ==
        (id: 3, name: "Laura Ringsell", language: "Swedish", age: 14),
    "mapToIds": () {
      final actual = mapToIds(people);
      final expected = List.generate(15, (index) => index + 1);
      return IterableEquality().equals(actual, expected);
    },
    "findIdByName": () => findIdByName(people, name: "Lettie Toon") == 11,
    "mostSpokenLanguage": () => mostSpokenLanguage(people) == "English",
    "top 3 most spoken languages": () => IterableEquality().equals(
        top3MostSpokenLanguages(people), ["English", "Danish", "Swedish"]),
  };

  final failures = testCases.map((key, value) {
    try {
      return MapEntry(key, value());
    } catch (e) {
      return MapEntry(key, false);
    }
  });
  failures.removeWhere((key, value) => value);
  if (failures.values.isNotEmpty) {
    _result(false, [...failures.keys]);
  } else {
    _result(true, ["Hurray, you did it 🥳"]);
  }
}

