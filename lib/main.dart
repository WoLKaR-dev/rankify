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
import 'package:rankify/components/ai_service.dart';
import 'package:rankify/components/brawl_service.dart';
import 'package:rankify/core/navigation.dart';
import 'package:rankify/core/theme.dart';
import 'package:wolkarutils/wolkarutils.dart';

void main() {
  // runs main app
  runApp(MainApp());
}

/// Main app material
class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Rankify",
      theme: appTheme(),
      home: MainAppPage(),
    );
  }
}

/// Main app page
class MainAppPage extends StatelessWidget {
  const MainAppPage({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: () async {
        WolkarUtils.instance.initWolkarUtils(context);

        // Obtain brawlers
        await BrawlService.instance.initBrawlers();

        // Obtain maps
        await BrawlService.instance.initMaps();

        // Init AI
        await AiService.instance.initAi();
      }(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return NavigationPage();
        } else {
          return Scaffold(
            body: Background(child: Center(child: CircularProgressIndicator())),
          );
        }
      },
    );
  }
}
