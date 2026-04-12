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

class PickableCard extends StatelessWidget {
  final bool available;
  final VoidCallback onTap;
  final (String, String, String) brawlerRecord;
  const PickableCard({
    super.key,
    required this.brawlerRecord,
    required this.onTap,
    required this.available,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          height: 120,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: available ? colorPallete.surfaceContainer : colorPallete.secondaryContainer,
            border: Border.all(color: colorPallete.outline),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            spacing: 10,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(10),
                child: Image.network(brawlerRecord.$2),
              ),
              Expanded(child: Text(brawlerRecord.$3).h5()),
            ],
          ),
        ),
      ),
    );
  }
}

class MapPickableCard extends StatelessWidget {
  final (String id, String image, String name) map;
  final VoidCallback onTap;
  final bool selected;
  const MapPickableCard({
    super.key,
    required this.map,
    required this.onTap,
    required this.selected,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? colorPallete.tertiaryContainer : colorPallete.surfaceContainer,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: colorPallete.outline),
          ),
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  child: Image.network(map.$2),
                ),
              ),
              Text(map.$3).p(),
            ],
          ),
        ),
      ),
    );
  }
}

class PickedBrawlerCard extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onLongTap;
  final bool isAlly;
  final (String, String, String)? brawler;
  const PickedBrawlerCard({
    super.key,
    required this.brawler,
    required this.isAlly,
    required this.onTap,
    required this.onLongTap,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: colorPallete.surfaceContainer,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                strokeAlign: BorderSide.strokeAlignInside,
                color: isAlly ? Colors.blue : Colors.red,
                width: 2,
              ),
            ),
            padding: EdgeInsets.all(5),
            child: SizedBox.square(
              dimension: switch (WolkarUtils.instance.screenSize) {
                ScreenSize.small => 70,
                ScreenSize.regular => 90,
                ScreenSize.large => 90,
                ScreenSize.xlarge => 120,
                ScreenSize.xxlarge => 130,
              },
              child: brawler != null
                  ? ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(10),
                      child: Image.network(brawler!.$2),
                    )
                  : Icon(Icons.add),
            ),
          ),
        ),
        if (brawler != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: onLongTap,
              icon: Icon(Icons.delete),
              style: IconButton.styleFrom(
                backgroundColor: colorPallete.error,
                foregroundColor: colorPallete.onError,
              ),
            ),
          ),
      ],
    );
  }
}

class PredictedBrawlerCard extends StatelessWidget {
  final (String, String, String, double) predict;
  const PredictedBrawlerCard({super.key, required this.predict});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: colorPallete.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox.square(
          dimension: switch (WolkarUtils.instance.screenSize) {
            ScreenSize.small => 70,
            ScreenSize.regular => 90,
            ScreenSize.large => 110,
            ScreenSize.xlarge => 140,
            ScreenSize.xxlarge => 160,
          },
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(10),
            child: Image.network(fit: BoxFit.fill, predict.$2),
          ),
        ),
      ),
    );
  }
}
