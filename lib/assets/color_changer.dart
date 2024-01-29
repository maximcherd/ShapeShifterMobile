import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColorChanger extends StatelessWidget {
  const ColorChanger({super.key});


  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ValueNotifier<ThemeMode>>(context);
    return IconButton(
      onPressed: () {
        themeNotifier.value = themeNotifier.value == ThemeMode.dark
            ? ThemeMode.light
            : ThemeMode.dark;
      },
      icon: Icon(themeNotifier.value == ThemeMode.dark
          ? Icons.dark_mode
          : Icons.light_mode),
    );
  }
}
