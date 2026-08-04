import 'package:flutter/material.dart';

const tutorLanguageFontFamily = 'Kurale';

ThemeData buildLightTheme() {
  const seedColor = Color(0xFF2F6F73);

  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
    fontFamily: tutorLanguageFontFamily,
    useMaterial3: true,
  );
}
