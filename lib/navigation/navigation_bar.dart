import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shape_shifter_mobile/data/controllers/documents_list_controller.dart';
import 'package:shape_shifter_mobile/pages/documents_page/documents_page.dart';
import 'package:shape_shifter_mobile/pages/setup_page/setup_page.dart';

import '../data/repository/documents_repository.dart';

class HomeNavigationBar extends StatefulWidget {
  const HomeNavigationBar({super.key});

  @override
  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  int _selectedTab = 0;
  final List<Map<String, dynamic>> _pages = [
    {
     "page": ChangeNotifierProvider(
        create: (_) =>
            DocListController(query: const DocQuery(sortBy: "date_down")),
        child: const DocumentsPage(),
      ),
      "name": "Документы",
      "iconData": Iconsax.document,
    },
    {
      "page": SetupPage(),
      "name": "Настройки",
      "iconData": Iconsax.setting_2,
    },
  ];

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  getNavigatorBarItem(String label, IconData icon) {
    return BottomNavigationBarItem(
      icon: Container(
        width: 35,
        height: 35,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 30,
        ),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    List<BottomNavigationBarItem> bottomNavigatorBarItems = [];
    for (dynamic page in _pages) {
      bottomNavigatorBarItems.add(getNavigatorBarItem(page["name"], page["iconData"]));
    }

    return Scaffold(
      body: _pages[_selectedTab]["page"],
      bottomNavigationBar: Container(
        height: 75,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (index) => _changeTab(index),
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.inversePrimary,
          showUnselectedLabels: false,
          items: bottomNavigatorBarItems,
        ),
      ),
    );
  }
}
