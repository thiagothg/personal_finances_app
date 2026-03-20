# Flutter — Add Inter Typography (Google Fonts)

## Contexto do projeto

App de finanças pessoais em Flutter com as seguintes cores já definidas:

```dart
class AppColors {
  static const Color primary        = Color(0xff4F46E5); // índigo
  static const Color primaryDark    = Color(0xff4338CA);
  static const Color secondary      = Color(0xff06B6D4);
  static const Color lightBackground = Color(0xffF5F5FF);
  static const Color lightSurface   = Color(0xffFFFFFF);
  static const Color darkBackground  = Color(0xff0F0E1A);
  static const Color darkSurface     = Color(0xff1A1830);
  static const Color darkCard        = Color(0xff232140);
  static const Color success         = Color(0xff16A34A);
  static const Color warning         = Color(0xffD97706);
  static const Color error           = Color(0xffDC2626);
  static const Color info            = Color(0xff0EA5E9);
}
```

---

## O que precisa ser feito

### 1. Adicionar dependência no `pubspec.yaml`

```yaml
dependencies:
  google_fonts: ^6.2.1
```

Rodar `flutter pub get` após adicionar.

---

### 2. Criar o arquivo `lib/core/theme/text_theme.dart`

Criar a função `buildTextTheme` com a fonte **Inter** do Google Fonts, adaptando cores para light e dark mode:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

TextTheme buildTextTheme({required bool isDark}) {
  final onSurface = isDark
      ? const Color(0xffE0E0FF)
      : const Color(0xff1E1B4B);
  final body = isDark
      ? const Color(0xffC4C4D4)
      : const Color(0xff374151);
  final muted = isDark
      ? const Color(0xff8884A8)
      : const Color(0xff6B7280);

  return GoogleFonts.interTextTheme().copyWith(
    displayLarge: GoogleFonts.inter(
      fontSize: 32, fontWeight: FontWeight.w700,
      color: onSurface, letterSpacing: -0.5,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 26, fontWeight: FontWeight.w700,
      color: onSurface, letterSpacing: -0.3,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 22, fontWeight: FontWeight.w600,
      color: onSurface,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 18, fontWeight: FontWeight.w600,
      color: onSurface,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w500,
      color: onSurface,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16, fontWeight: FontWeight.w400,
      color: body, height: 1.6,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14, fontWeight: FontWeight.w400,
      color: body, height: 1.5,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12, fontWeight: FontWeight.w400,
      color: muted,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 14, fontWeight: FontWeight.w500,
      color: AppColors.primary,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 11, fontWeight: FontWeight.w500,
      color: muted, letterSpacing: 0.5,
    ),
  );
}
```

---

### 3. Atualizar `lib/core/theme/theme.dart`

Importar o `buildTextTheme` e plugar nos dois temas:

```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'text_theme.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary:     AppColors.primary,
    secondary:   AppColors.secondary,
    surface:     AppColors.lightSurface,
    background:  AppColors.lightBackground,
    error:       AppColors.error,
    onPrimary:   Colors.white,
    onSecondary: Colors.white,
    onSurface:   Color(0xff1E1B4B),
    brightness:  Brightness.light,
  ),
  scaffoldBackgroundColor: AppColors.lightBackground,
  textTheme: buildTextTheme(isDark: false),
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary:     AppColors.primary,
    secondary:   AppColors.secondary,
    surface:     AppColors.darkSurface,
    background:  AppColors.darkBackground,
    error:       AppColors.error,
    onPrimary:   Colors.white,
    onSecondary: Colors.white,
    onSurface:   Color(0xffE0E0FF),
    brightness:  Brightness.dark,
  ),
  scaffoldBackgroundColor: AppColors.darkBackground,
  textTheme: buildTextTheme(isDark: true),
);
```

---

### 4. Usar no `main.dart`

```dart
MaterialApp(
  theme: lightTheme,
  darkTheme: darkTheme,
  themeMode: ThemeMode.system,
  home: const HomeScreen(),
);
```

---

## Uso nos widgets

```dart
// Usar estilo do tema
Text(
  'R\$ 12.480,00',
  style: Theme.of(context).textTheme.displayLarge,
)

// Sobrescrever pontualmente
Text(
  'Saldo positivo',
  style: Theme.of(context).textTheme.titleMedium?.copyWith(
    color: AppColors.success,
  ),
)

// Tag de categoria (labelSmall em uppercase)
Text(
  'ALIMENTAÇÃO',
  style: Theme.of(context).textTheme.labelSmall,
)
```

---

## Referência dos estilos

| Token          | Tamanho | Peso | Uso principal                  |
|----------------|---------|------|--------------------------------|
| displayLarge   | 32px    | 700  | Valor do saldo principal       |
| displayMedium  | 26px    | 700  | Totais e destaques             |
| headlineMedium | 22px    | 600  | Títulos de seção               |
| titleLarge     | 18px    | 600  | Cabeçalhos de card             |
| titleMedium    | 16px    | 500  | Nome de transação              |
| bodyLarge      | 16px    | 400  | Texto corrido principal        |
| bodyMedium     | 14px    | 400  | Descrições e subtítulos        |
| bodySmall      | 12px    | 400  | Timestamps e notas             |
| labelLarge     | 14px    | 500  | Botões e links de ação         |
| labelSmall     | 11px    | 500  | Tags de categoria (uppercase)  |
