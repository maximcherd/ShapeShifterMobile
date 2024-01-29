import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shape_shifter_mobile/assets/color_schemes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shape_shifter_mobile/navigation/navigation_bar.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ValueNotifier(ThemeMode.system)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ValueNotifier<ThemeMode>>();
    return MaterialApp(
      title: 'ShapeShifter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      themeMode: themeNotifier.value,
      home: const HomeNavigationBar(),
    );
  }
}
