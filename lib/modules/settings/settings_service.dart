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
import 'package:rankify/components/brawl_service.dart';
import 'package:rankify/components/data/appdata_service.dart';
import 'package:rankify/core/notifiers.dart';
import 'package:rankify/modules/settings/settings_data.dart';
import 'package:rankify/modules/settings/settings_enums.dart';
import 'package:wolkarutils/wolkarutils.dart';

class SettingsService {
  //==============
  //============== Attributes
  //==============

  //SECTION Singleton related

  /// Instancia principal del singleton
  static final SettingsService _instance = SettingsService._internal();

  /// Class notifier
  final SettingsNotifier _notifier = SettingsNotifier();

  /// Last patch readed
  String _lastPatch = "";

  //SECTION Model related

  /// Active speech mode
  SpeechMode _mode = SpeechMode.pro;

  /// Active model
  Model _model = Model.v3;

  //SECTION Pick related

  /// Whether bans are active by default or not
  bool _bansExpanded = false;

  /// Whether all data section is expanded by default
  bool _allDataExpanded = false;

  //SECTION User related

  /// Is the brawl stars user id
  String _userId = "";

  /// If the player wants to suggest only lvl11 brawlers
  bool _onlyMaxLevel = false;

  /// If the app only uses unlocked brawlers
  bool _onlyUnlocked = false;

  //==============
  //============== Attributes / v3
  //==============

  /// V3 Optimization Setting
  Optimization _optimization = Optimization.personalized;

  /// V3 Personalized Brawlers
  int _personalizedBrawlers = BrawlService.instance.brawlers.length;

  //==============
  //============== Constructors
  //==============

  /// Constructor privado interno
  SettingsService._internal();

  //==============
  //============== Methods
  //==============

  /// Updates settings instance.
  ///
  /// [newMode] as the new [SpeechMode]
  void update({
    SpeechMode? newMode,
    Model? newModel,
    Optimization? newV3Optimization,
    int? newV3PersonalizedBrawlers,
    bool? newBansExpanded,
    bool? newAllDataExpanded,
    bool? newOnlyMaxLevel,
    String? newUserId,
    bool? newOnlyUnlocked,
    String? newLastPatch,
    bool? saveData = true,
  }) {
    _mode = newMode ?? _mode;
    _model = newModel ?? _model;
    _optimization = newV3Optimization ?? _optimization;
    _personalizedBrawlers = newV3PersonalizedBrawlers ?? _personalizedBrawlers;
    _bansExpanded = newBansExpanded ?? _bansExpanded;
    _allDataExpanded = newAllDataExpanded ?? _allDataExpanded;
    _userId = newUserId ?? _userId;
    _onlyMaxLevel = newOnlyMaxLevel ?? _onlyMaxLevel;
    _onlyUnlocked = newOnlyUnlocked ?? _onlyUnlocked;
    _lastPatch = newLastPatch ?? _lastPatch; 
    _notifier.notify();
    if (saveData == false) return;
    AppDataService().saveData();
  }

  /// Loads settings data
  ///
  /// [data] as the data to load
  bool loadData(JSON data) {
    try {
      // load system settings
      final systemData = data["settings"];

      // checks that exists.
      if (systemData == null) throw Exception("No settings data found");

      // loads data
      update(
        newModel: Model.values.firstWhere(
          (e) => e.value == systemData["model"],
          orElse: () => Model.v3,
        ),
        newV3Optimization: Optimization.values.firstWhere(
          (e) => e.value == systemData["optimization"],
          orElse: () => Optimization.personalized,
        ),
        newV3PersonalizedBrawlers:
            systemData["personalizedBrawlers"] ?? BrawlService.instance.brawlers.length,
        newBansExpanded: systemData["bansExpanded"] ?? false,
        newAllDataExpanded: systemData["allDataExpanded"] ?? false,
        newUserId: systemData["userId"] ?? "",
        newOnlyMaxLevel: systemData["onlyMaxLevel"] ?? false,
        newOnlyUnlocked: systemData["onlyUnlocked"] ?? false,
        newLastPatch: systemData["lastPatch"] ?? "",
        saveData: false,
      );

      return true;
    } catch (e) {
      debugPrint('An error ocurred: $e');
      return false;
    }
  }

  //==============
  //============== Getters
  //==============

  /// Instancia del singleton
  static SettingsService get instance => _instance;

  /// Speech mode
  SpeechMode get mode => _mode;

  /// Notifier
  SettingsNotifier get notifier => _notifier;

  /// Model
  Model get model => _model;

  /// Optimization
  Optimization get optimization => _optimization;

  /// V3 Personalized Brawlers
  int get v3PersonalizedBrawlers => _personalizedBrawlers;

  /// If bans are expanded
  bool get bansExpanded => _bansExpanded;

  /// All data expanded by default
  bool get allDataExpanded => _allDataExpanded;

  /// If the players wants only max level suggestions
  bool get onlyMaxLevel => _onlyMaxLevel;

  /// The player's user ID
  String get userId => _userId;

  /// If the app only uses unlocked brawlers
  bool get onlyUnlocked => _onlyUnlocked;
  
  /// Last patch readed
  bool get patchReaded => _lastPatch == patchId;

  /// Data to save
  JSON get json => {
    "model": _model.value, // model used
    "optimization": _optimization.value, // type of optimization
    "personalizedBrawlers": _personalizedBrawlers, // number of brawlers to calculate
    "bansExpanded": _bansExpanded, // if bans are expanded by default
    "allDataExpanded": _allDataExpanded, // if all data is expanded by default
    "userId": _userId, // user id
    "onlyMaxLevel": _onlyMaxLevel, // if the player wants to suggest only lvl11 brawlers
    "onlyUnlocked": _onlyUnlocked, // if the app only uses unlocked brawlers
    "lastPatch": _lastPatch, // last patch readed
  };

  //==============
  //============== Getter Functions
  //==============
}
