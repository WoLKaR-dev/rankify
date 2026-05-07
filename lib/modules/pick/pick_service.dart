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
import 'package:rankify/components/prediction_service.dart';
import 'package:rankify/core/notifiers.dart';

class PickService {
  //==============
  //============== Attributes
  //==============

  /// Pick service notifier
  final PickNotifier _notifier = PickNotifier();

  /// Selected map
  (String, String, String)? _selectedMap;

  /// Allies
  List<(String, String, String)?> _allies = List.generate(3, (index) => null);

  /// Enemies
  List<(String, String, String)?> _enemies = List.generate(3, (index) => null);

  /// Instancia principal del singleton
  static final PickService _instance = PickService._internal();

  /// Filter controller
  final TextEditingController _controller = TextEditingController();

  //==============
  //============== Constructors
  //==============

  /// Constructor privado interno
  PickService._internal();

  //==============
  //============== Methods
  //==============

  /// Updates pick service data
  void update({
    (String, String, String)? newSelectedMap,
    List<(String, String, String)?>? newAllies,
    List<(String, String, String)?>? newEnemies,
  }) async {
    _selectedMap = newSelectedMap ?? _selectedMap;
    _allies = newAllies ?? _allies;
    _enemies = newEnemies ?? _enemies;
    _controller.text = "";
    PredictionService.instance.predictGame();
    _notifier.notify();
  }

  /// Resets all data
  void reset() {
    _selectedMap = null;
    _allies = List.generate(3, (index) => null);
    _enemies = List.generate(3, (index) => null);
    _controller.text = "";
    _notifier.notify();
  }

  //==============
  //============== Getters
  //==============

  /// Instancia del singleton
  static PickService get instance => _instance;

  /// Notifier
  PickNotifier get notifier => _notifier;

  /// Current map
  (String, String, String)? get selectedMap => _selectedMap;

  /// Current allies
  List<(String, String, String)?> get allies => _allies;

  /// Current enemies
  List<(String, String, String)?> get enemies => _enemies;

  /// Controller
  TextEditingController get controller => _controller;

  //==============
  //============== Getter Functions
  //==============
  /// Current pick phase
  int get phase {
    if (_selectedMap != null) {
      return 1;
    }
    return 0;
  }

  /// Ally pick position
  int? get pickPosition {
    int? position;
    for (int currentPosition = 0; currentPosition <= 2; currentPosition++) {
      final brawler = _allies[currentPosition];
      if (brawler == null) {
        position = currentPosition;
        break;
      }
    }
    return position;
  }

  /// Enemy pick position
  int? get enemyPickPosition {
    int? position;
    for (int currentPosition = 0; currentPosition <= 2; currentPosition++) {
      final brawler = _enemies[currentPosition];
      if (brawler == null) {
        position = currentPosition;
        break;
      }
    }
    return position;
  }
}
