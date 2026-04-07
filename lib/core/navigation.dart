import 'package:flutter/material.dart';
import 'package:rankify/core/theme.dart';
import 'package:rankify/modules/home/home_page.dart';
import 'package:rankify/modules/pick/pick_page.dart';
import 'package:wolkarutils/wolkarutils.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});
  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  //STATE Current index
  int selectedIndex = 0;

  // App bar titles
  List<String> appBarTitles = ["Home", "Ranked", "Settings"];

  // App screens
  List<Widget> pages = [HomePage(), PickPage(), HomePage()];

  @override
  Widget build(BuildContext context) {
    //ATOMS Preview chip
    final previewChip = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          border: Border.all(color: colorPallete.outline, width: 2),
          borderRadius: BorderRadius.circular(360),
        ),
        child: Text("Preview").p(color: colorPallete.outline),
      ),
    );

    //ATOMS Appbar
    final AppBar appbar = AppBar(title: Text(appBarTitles[selectedIndex]), actions: [previewChip]);

    //ATOMS Nav Rail
    final Widget navRail =
        (!([ScreenSize.small, ScreenSize.regular].contains(WolkarUtils.instance.screenSize)))
        ? NavigationRail(
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            destinations: [
              NavigationRailDestination(icon: Icon(Icons.home), label: Text("Home")),
              NavigationRailDestination(
                icon: Icon(Icons.keyboard_double_arrow_up_rounded),
                label: Text("Ranked"),
              ),
              NavigationRailDestination(icon: Icon(Icons.settings), label: Text("Settings")),
            ],
            selectedIndex: selectedIndex,
          )
        : SizedBox();

    //ATOMS Nav bar
    final NavigationBar? navBar =
        ([ScreenSize.small, ScreenSize.regular].contains(WolkarUtils.instance.screenSize))
        ? NavigationBar(
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            destinations: [
              NavigationDestination(icon: Icon(Icons.home), label: "Home"),
              NavigationDestination(
                icon: Icon(Icons.keyboard_double_arrow_up_rounded),
                label: "Ranked",
              ),
              NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
            ],
            selectedIndex: selectedIndex,
          )
        : null;

    //ATOMS Seleced page
    final selectedPage = pages[selectedIndex];

    //LAYOUT Page
    final page = Row(
      children: [
        navRail,
        Expanded(child: selectedPage),
      ],
    );

    //WRAPPER Main Structure
    return Scaffold(appBar: appbar, bottomNavigationBar: navBar, body: page);
  }
}
