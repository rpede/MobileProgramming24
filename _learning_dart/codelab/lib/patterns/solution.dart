bool canBuyAlcohol((int yourAge, double alcoholPercentage) purchase) =>
    switch (purchase) {
      (var age, _) when age >= 18 => true,
      (var age, var alc) when age >= 16 && alc < 16.5 => true,
      (var age, var alc) when age < 16 && alc < 1.2 => true,
      _ => false,
    };
