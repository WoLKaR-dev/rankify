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

import 'package:rankify/components/brawl_service.dart';
import 'package:rankify/core/notifiers.dart';
import 'package:rankify/modules/settings/settings_enums.dart';

class SettingsService {
  //==============
  //============== Attributes
  //==============

  /// Instancia principal del singleton
  static final SettingsService _instance = SettingsService._internal();

  /// Active speech mode
  SpeechMode _mode = SpeechMode.pro;

  /// Active model
  Model _model = Model.v2;

  /// Class notifier
  final SettingsNotifier _notifier = SettingsNotifier();

  //==============
  //============== Attributes / v3
  //==============

  /// V3 Optimization Setting
  Optimization _v3Optimization = Optimization.personalized;

  /// V3 Personalized Brawlers
  int _v3PersonalizedBrawlers = BrawlService.instance.brawlers.length;

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
  void update({SpeechMode? newMode, Model? newModel, Optimization? newV3Optimization, int? newV3PersonalizedBrawlers}) {
    _mode = newMode ?? _mode;
    _model = newModel ?? _model;
    _v3Optimization = newV3Optimization ?? _v3Optimization;
    _v3PersonalizedBrawlers = newV3PersonalizedBrawlers ?? _v3PersonalizedBrawlers;
    _notifier.notify();
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

  /// V3 Optimization
  Optimization get v3Optimization => _v3Optimization;

  /// V3 Personalized Brawlers
  int get v3PersonalizedBrawlers => _v3PersonalizedBrawlers;

  //==============
  //============== Getter Functions
  //==============
}
