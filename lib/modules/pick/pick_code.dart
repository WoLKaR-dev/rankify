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
