import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shape_shifter_mobile/assets/color_changer.dart';
import 'package:shape_shifter_mobile/data/model/document_model.dart';
import 'package:shape_shifter_mobile/main.dart';
import 'package:shape_shifter_mobile/pages/documents_page/documents_page.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  String title = "Настройки";

  Widget themeChangeButton(themeNotifier) {
    return IconButton(
      onPressed: () {
        themeNotifier.value = themeNotifier.value == ThemeMode.dark
            ? ThemeMode.light
            : ThemeMode.dark;
      },
      icon: Icon(
        themeNotifier.value == ThemeMode.dark
            ? Iconsax.sun_1
            : Iconsax.moon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ValueNotifier<ThemeMode>>(context);
    final theme = Theme.of(context);
    TextStyle textStyle = TextStyle(
      fontSize: 18,
      color: theme.colorScheme.onSurface,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0.0, 0.0),
                    blurRadius: 10.0,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      body: Scaffold(
        body: Column(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.outline,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Сменить тему:",
                    style: textStyle,
                  ),
                  const SizedBox(width: 30),
                  themeChangeButton(themeNotifier),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
