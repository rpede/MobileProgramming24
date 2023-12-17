bool canBuyAlcohol(int yourAge, double alcoholPercentage) {
  if (yourAge >= 18) {
    return true;
  } else if (yourAge >= 16 && alcoholPercentage < 16.5) {
    return true;
  } else if (alcoholPercentage < 1.2) {
    return true;
  } else {
    return false;
  }
}
