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
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rankify/components/data/data_service.dart';
import 'package:rankify/modules/settings/settings_service.dart';
import 'package:wolkarutils/wolkarutils.dart';

class AppDataService extends AppDataInterface {
  //==============
  //============== Attributes
  //==============

  /// Instancia principal del singleton
  static final AppDataService _instance = AppDataService._internal();

  //==============
  //============== Constructors
  //==============

  /// Constructor privado interno
  AppDataService._internal();

  /// Factory constructor
  factory AppDataService() => _instance;
  //==============
  //============== Methods
  //==============

  @override
  Future<bool> loadData() async {
    try {
      // gets the content
      final content = await DataService().readFile("data");

      // throws error if empty
      if (content.isEmpty) throw Exception("No data found");

      // parses the content
      var savedData = await jsonDecode(content);

      // loads data for each system
      SettingsService.instance.loadData(savedData);

      return true;
    } catch (e) {
      debugPrint('An error ocurred: $e');
      return false;
    }
  }

  @override
  Future<bool> saveData() async {
    try {
      // gets all systems data
      final content = {"settings": SettingsService.instance.json};

      // transforms the content to a string
      final dataToSave = jsonEncode(content);

      // saves data
      final result = await DataService().writeFile("data", dataToSave);

      // returns result
      return result;
    } catch (e) {
      debugPrint('An error ocurred: $e');
      return false;
    }
  }

  //==============
  //============== Getters
  //==============

  //==============
  //============== Getter Functions
  //==============
}
