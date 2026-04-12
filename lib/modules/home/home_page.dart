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
import 'package:rankify/modules/home/home_code.dart';
import 'package:rankify/modules/home/home_style.dart';
import 'package:wolkarutils/wolkarutils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.changeIndex});
  final Function(int) changeIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //ATOMS Home title
    final title = Text("Home").h1();

    //ATOMS Home card
    final mainCards = Wrap(
      spacing: 10,
      runSpacing: 10,
      direction: Axis.horizontal,
      children: [
        BigHomeCard(
          text: "It's high time you stopped losing.",
          onTap: () {
            widget.changeIndex(1);
          },
        ),
        Column(
          spacing: 10,
          children: [
            SmallHomeCard(
              image: "assets/images/settings.png",
              text: "Personalize Rankify whatever you like.",
              scale: 2,
              onTap: () {
                widget.changeIndex(2);
              },
            ),
            SmallHomeCard(
              image: "assets/images/logo.png",
              text: "Help mantaining Rankify an open source app.",
              onTap: () {
                openGithub();
              },
            ),
          ],
        ),
      ],
    );

    //LAYOUT Page
    final page = Background(
      padding: EdgeInsets.all(15),
      child: Scroll(spacing: 15, children: [title, mainCards]),
    );

    return Scaffold(body: page);
  }
}
