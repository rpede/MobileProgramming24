class FizzBuzzer {
  Stream<String> generate() async* {
    var n = 0;
    while (true) {
      n++;
      if (n % 15 == 0) yield "Fizz Buzz";
      else if (n % 3 == 0) yield "Fizz";
      else if (n % 5 == 0) yield "Buzz";
      else yield n.toString();
    }
  }
}
