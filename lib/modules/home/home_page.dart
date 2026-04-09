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
      direction: Axis.horizontal,
      children: [
        BigHomeCard(),
        Column(children: [SmallHomeCard(), SmallHomeCard()]),
      ],
    );

    //LAYOUT Page
    final page = Background(child: Scroll(children: [mainCards]));

    return Scaffold(body: page);
  }
}
