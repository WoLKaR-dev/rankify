import 'package:flutter/material.dart';
import 'package:rankify/core/theme.dart';
import 'package:wolkarutils/wolkarutils.dart';

class BigHomeCard extends StatelessWidget {
  const BigHomeCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 500,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: colorPallete.surfaceContainer,
        borderRadius: BorderRadius.circular(15),
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
                borderRadius: BorderRadiusGeometry.circular(10),
                child: Image.asset("assets/images/trophy.png", fit: BoxFit.cover),
              ),
            ),
          ),
          Text(("data")).h4(),
        ],
      ),
    );
  }
}

class SmallHomeCard extends StatelessWidget {
  const SmallHomeCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 500,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: colorPallete.surfaceContainer,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: colorPallete.outline),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(10),
            child: Image.asset("assets/images/settings.png"),
          ),
          Expanded(child: Text(("data")).p()),
        ],
      ),
    );
  }
}
