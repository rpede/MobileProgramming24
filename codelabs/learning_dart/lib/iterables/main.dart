import "package:collection/collection.dart";

typedef Person = ({int id, String name, String language, int age});

bool anyKids(List<Person> people) {
  // return `true` if anyone is under 13, otherwise `false`
  return false;
}

bool anyYoungsters(List<Person> people) {
  // return `true` if anyone is older than 13 but younger than 18
  return false;
}

Person? firstYoungster(List<Person> people) {
  // return the first person between 13 and 18
  return null;
}

List<int> mapToIds(List<Person> people) {
  // return a list of IDs for each person
  return [];
}

int findIdByName(List<Person> people, {required String name}) {
  // return the `id` of the first person matching the given `name`
  return 0;
}

String? mostSpokenLanguage(List<Person> people) {
  // return the most spoken language for all the people
  return null;
}

List<String> top3MostSpokenLanguages(List<Person> people) {
  // return the 3 most spoken languages
  return [];
}
