String dayType(int day) {
  // Use switch to determine if the day is a weekday or weekend
  switch (day) {
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
      return 'Weekday';
    case 6:
    case 7:
      return 'Weekend';
    default:
      throw ArgumentError('Invalid day');
  }
}
