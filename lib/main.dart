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
import 'package:rankify/components/data/appdata_service.dart';
import 'package:rankify/components/data/data_service.dart';
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
class MainAppPage extends StatefulWidget {
  const MainAppPage({super.key});

  @override
  State<MainAppPage> createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeFeatures();
  }

  Future<void> _initializeFeatures() async {
    try {
      // await a little bit
      await Future.delayed(Duration.zero);

      // init utils
      if (mounted) {
        WolkarUtils.instance.initWolkarUtils(context);
      }

      // Obtain brawlers
      await BrawlService.instance.initBrawlers();

      // Obtain maps
      await BrawlService.instance.initMaps();

      // Init AI
      await AiService.instance.initAi();

      // Init data storage
      await DataService().initDirectories("Rankify");

      // Load data
      await AppDataService().loadData();

      // And load user
      await BrawlService.instance.initPlayerData(); 
    } catch (e) {
      debugPrint('An error ocurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return NavigationPage();
        } else {
          return Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(color: colorPallete.surfaceContainer),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
      },
    );
  }
}
