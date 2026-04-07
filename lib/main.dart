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
