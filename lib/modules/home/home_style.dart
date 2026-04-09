import 'package:flutter/material.dart';
import 'package:rankify/core/theme.dart';
import 'package:wolkarutils/wolkarutils.dart';

class BigHomeCard extends StatelessWidget {
  const BigHomeCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text((text)).h3(),
        ],
      ),
    );
  }
}

class SmallHomeCard extends StatelessWidget {
  const SmallHomeCard({super.key, required this.text, required this.image, this.scale = 1});

  final String text; 
  final double scale;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 500,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorPallete.surfaceContainer,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: colorPallete.outline),
      ),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            flex: 2,
            child: IntrinsicHeight(
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: Image.asset(image, scale: scale),
              ),
            ),
          ),
          Flexible(flex: 3, child: Text((text)).h5()),
        ],
      ),
    );
  }
}
