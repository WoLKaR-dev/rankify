import 'package:flutter/material.dart';
import 'package:rankify/modules/home/home_style.dart';
import 'package:wolkarutils/wolkarutils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //ATOMS Home card
    final mainCards = Wrap(
      spacing: 10,
      direction: Axis.horizontal,
      children: [
        BigHomeCard(text: "It's high time you stopped losing.",),
        Column(
          spacing: 10,
          children: [
            SmallHomeCard(image: "assets/images/settings.png", text: "Personalize Rankify whatever you like.", scale: 2),
            SmallHomeCard(image: "assets/images/logo.png", text: "Help mantaining Rankify an open source app.",),
          ],
        ),
      ],
    );

    //LAYOUT Page
    final page = Background(
      padding: EdgeInsets.all(15),
      child: Scroll(children: [mainCards]),
    );

    return Scaffold(body: page);
  }
}
