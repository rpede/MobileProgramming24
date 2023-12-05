import "package:collection/collection.dart";

typedef Person = ({int id, String name, String language, int age});

bool anyKids(List<Person> people) {
  return people.any((person) => person.age < 13);
}

bool anyYoungsters(List<Person> people) {
  return people.any((person) => person.age > 13 && person.age < 18);
}

Person? firstYoungster(List<Person> people) {
  try {
    return people.firstWhere((person) => person.age > 13 && person.age < 18);
  } on StateError {
    return null;
  }
}

List<int> mapToIds(List<Person> people) {
  return people.map((e) => e.id).toList();
}

int findIdByName(List<Person> people, {required String name}) {
  return people.where((e) => e.name == name).map((e) => e.id).single;
}

String? mostSpokenLanguage(List<Person> people) {
  final group = people.groupFoldBy((element) => element.language,
      (previous, element) => ((previous ?? 0) as num) + 1);
  return maxBy(group.entries, (p0) => p0.value)?.key;
}

List<String> top3MostSpokenLanguages(List<Person> people) {
  return people
      .groupFoldBy(
        (element) => element.language,
        (previous, element) => ((previous ?? 0) as num) + 1,
      )
      .entries
      .sortedBy((element) => element.value)
      .reversed
      .take(3)
      .map((e) => e.key)
      .toList();
}
