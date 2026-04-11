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
