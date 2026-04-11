import 'package:flutter/material.dart';
import 'package:rankify/components/notifier_service.dart';

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
  }) {
    _selectedMap = newSelectedMap ?? _selectedMap;
    _allies = newAllies ?? _allies;
    _enemies = newEnemies ?? _enemies;
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
