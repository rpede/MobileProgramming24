// Convert 7-step-scale used in Denmark to ECTS grading scale.
String convertGrade(String grade) => switch (grade) {
      '12' => 'A+',
      '10' => 'B',
      '7' => 'C',
      '4' => 'D',
      '02' => 'E',
      '00' => 'Fx',
      '-3' => 'F',
      _ => throw ArgumentError('Invalid grade')
    };
