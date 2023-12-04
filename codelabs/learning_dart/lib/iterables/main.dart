import "package:collection/collection.dart";

typedef Person = ({int id, String name, String language, int age});

bool anyKids(List<Person> people) {
  // returns `true` if anyone is under 13, otherwise `false`
}

bool anyYoungsters(List<Person> people) {
  // return `true` if anyone is older than 13 but younger than 18
}

Person firstYoungster(List<Person> people) {
  // return the first person between 13 and 18
}

List<int> mapToIds(List<Person> people) {
  // return a list of IDs for each person
}

int findIdByName(List<Person> people, {required String name}) {
  // return the `id` of the first person matching the given `name`
}

String? mostSpokenLanguage(List<Person> people) {
  // return the most spoken language for all the people
}

List<String> top3MostSpokenLanguages(List<Person> people) {
  // return the 3 most spoken languages
}
