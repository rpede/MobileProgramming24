class Acronym {
  static String abbreviate({required String text}) {
    return toTitleCase(text).replaceAll(RegExp(r"[^A-Z]"), '');
  }

  static String toTitleCase(String text) {
    return text
        .split(' ')
        .map((e) => e[0].toUpperCase() + e.substring(1))
        .toString();
  }
}
