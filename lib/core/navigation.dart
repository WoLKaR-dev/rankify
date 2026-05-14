//    Rankify is an Open Source AI app made to help brawl stars players reach higher ranks.
//    Copyright (C) 2026 WoLKaR-dev
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU Affero General Public License as
//    published by the Free Software Foundation, either version 3 of the
//    License, or (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU Affero General Public License for more details.
//
//    You should have received a copy of the GNU Affero General Public License
//    along with this program.  If not, see https://www.gnu.org/licenses/

import 'package:flutter/material.dart';
import 'package:rankify/core/theme.dart';
import 'package:rankify/modules/home/home_page.dart';
import 'package:rankify/modules/pick/pick_page.dart';
import 'package:rankify/modules/settings/settings_data.dart';
import 'package:rankify/modules/settings/settings_page.dart';
import 'package:rankify/modules/settings/settings_service.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showPatch();
    });
  }

  void showPatch() {
    if (SettingsService.instance.patchReaded) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(patchTitle),
        content: Text(patchContent).p(),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              SettingsService.instance.update(newLastPatch: patchId);
            },
            label: Text("Accept"),
            icon: Icon(Icons.check),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPallete.secondary,
              foregroundColor: colorPallete.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // pages
    List<Widget> pages = [
      HomePage(
        changeIndex: (newIndex) {
          setState(() {
            selectedIndex = newIndex;
          });
        },
      ),
      PickPage(),
      SettingsPage(),
    ];

    //ATOMS Appbar
    final AppBar appbar = AppBar(title: Text(appBarTitles[selectedIndex]));

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
