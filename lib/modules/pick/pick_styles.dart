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
              Text(brawlerRecord.$3).h5(),
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
          child: Scroll(
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(10),
                child: Image.network(map.$2),
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
  final bool selected;
  final (String, String, String)? brawler;
  const PickedBrawlerCard({
    super.key,
    required this.brawler,
    required this.selected,
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
                width: selected ? 6 : 2,
              ),
            ),
            padding: EdgeInsets.all(5),
            child: SizedBox.square(
              dimension: 150,
              child: brawler != null
                  ? ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(10),
                      child: Image.network(brawler!.$2),
                    )
                  : Icon(Icons.add),
            ),
          ),
        ),
        if (brawler != null) Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton( onPressed: onLongTap, icon: Icon(Icons.delete), style: IconButton.styleFrom(backgroundColor: colorPallete.error, foregroundColor: colorPallete.onError),),
        ),
      ],
    );
  }
}
