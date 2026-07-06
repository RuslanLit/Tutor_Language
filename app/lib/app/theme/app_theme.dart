import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  const seedColor = Color(0xFF2F6F73);

  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
    useMaterial3: true,
  );
}
