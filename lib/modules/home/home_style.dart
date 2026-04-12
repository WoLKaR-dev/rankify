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
import 'package:wolkarutils/wolkarutils.dart';

class BigHomeCard extends StatelessWidget {
  const BigHomeCard({super.key, required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 510,
        width: 510,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colorPallete.surfaceContainer,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: colorPallete.outline),
        ),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 2,
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: Image.asset("assets/images/trophy.png", fit: BoxFit.cover),
                ),
              ),
            ),
            Text((text)).h4(),
          ],
        ),
      ),
    );
  }
}

class SmallHomeCard extends StatelessWidget {
  const SmallHomeCard({super.key, required this.text, required this.image,required this.onTap,  this.scale = 1});

  final VoidCallback onTap;
  final String text;
  final double scale;
  final String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 250,
        width: 500,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colorPallete.surfaceContainer,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: colorPallete.outline),
        ),
        child: IntrinsicHeight(
          child: Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                flex: 4,
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: Image.asset(image, scale: scale, fit: BoxFit.cover),
                ),
              ),
              Flexible(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text((text)).h6()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
