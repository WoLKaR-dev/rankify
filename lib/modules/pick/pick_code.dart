import 'package:flutter/material.dart';
import 'package:rankify/modules/pick/pick_service.dart';
import 'package:wolkarutils/wolkarutils.dart';

void showPickedMap(BuildContext context) {
  if (PickService.instance.selectedMap == null) return;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Selected Map: ${PickService.instance.selectedMap!.$3}"),
      content: Scroll(children: [Image.network(PickService.instance.selectedMap!.$2)]),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          label: Text("Accept"),
          icon: Icon(Icons.check),
        ),
      ],
    ).constrained(context),
  );
}
