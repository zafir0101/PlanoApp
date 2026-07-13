import 'package:flutter/material.dart';

/// Paleta do Plano — minimalismo: branco e cinza como base,
/// verdes claros como acento, verde profundo para o plano ativo.
class PlanoColors {
  PlanoColors._();

  // Base
  static const background = Color(0xFFFAFAF8);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF2F4F2);
  static const border = Color(0xFFE7EAE7);

  // Texto
  static const textPrimary = Color(0xFF20261F);
  static const textSecondary = Color(0xFF8B928A);

  // Verdes
  static const green = Color(0xFF5FAE7F); // acento principal (claro)
  static const greenMid = Color(0xFF4C9C6D); // ícones e destaques
  static const greenSoft = Color(0xFFE8F3EC); // preenchimentos suaves
  static const greenDeep = Color(0xFF275E43); // tela de plano ativo
  static const greenDeeper = Color(0xFF1F4E37);
  static const onGreenDeep = Color(0xFFDFF0E6); // texto sobre verde profundo

  // Transparências (constantes para evitar APIs deprecadas)
  static const white70 = Color(0xB3FFFFFF);
  static const white15 = Color(0x26FFFFFF);
  static const white12 = Color(0x1FFFFFFF);
  static const white10 = Color(0x1AFFFFFF);
  static const white08 = Color(0x14FFFFFF);
  static const shadow = Color(0x14000000);

  // Barra de navegação suspensa
  static const navBackground = Color(0xBFFFFFFF); // ~75% branco
  static const navBorder = Color(0xA6FFFFFF);
}

ThemeData buildPlanoTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: PlanoColors.green)
        .copyWith(surface: PlanoColors.background),
    scaffoldBackgroundColor: PlanoColors.background,
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: PlanoColors.textPrimary,
      displayColor: PlanoColors.textPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: PlanoColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: PlanoColors.textPrimary,
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Color(0xE620261F),
      contentTextStyle: TextStyle(color: Colors.white, fontSize: 13.5),
    ),
  );
}
