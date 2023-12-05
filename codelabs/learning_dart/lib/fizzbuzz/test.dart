// import "./solution.dart";
// import "../mock_result.dart";

// const _result = result;

void main() async {
  const expected =
      "1, 2, Fizz, 4, Buzz, Fizz, 7, 8, Fizz, Buzz, 11, Fizz, 13, 14, Fizz Buzz, 16, 17, Fizz, 19, Buzz, Fizz, 22, 23, Fizz, Buzz, 26, Fizz, 28, 29, Fizz Buzz, 31, 32, Fizz, 34, Buzz";
  final Stream sequence = FizzBuzzer().generate();
  final String actual = await sequence.take(35).join(", ");
  final success = actual == expected;
  if (success) {
    _result(true, ["Hurray, you did it 🥳"]);
  } else {
    _result(false, ["Incorrect, try again!"]);
  }
}
