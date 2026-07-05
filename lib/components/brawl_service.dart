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
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rankify/modules/settings/settings_service.dart';

/// Singleton designed to keep track of all available brawlers and maps, including
/// methods to transform data into a format that I can understand.
class BrawlService {
  //==============
  //============== Attributes
  //==============

  /// Database brawlers
  late List<(String id, String image, String name)> _brawlers;

  /// Database maps
  late List<(String id, String image, String name)> _maps;

  /// User data
  Map<String, dynamic> _userData = {};

  /// Singleton isntance
  static final BrawlService _instance = BrawlService._internal();

  //==============
  //============== Constructors
  //==============

  /// Constructor privado interno
  BrawlService._internal();

  //==============
  //============== Methods
  //==============

  /// Gets brawler data from api, including name and image
  ///
  /// Returns a list of all brawlers data.
  Future<void> initBrawlers() async {
    try {
      final List<(String, String, String)> appBrawlersData = [];
      var response = await http.get(Uri.parse("https://api.brawlapi.com/v1/brawlers"));

      // handle when call was successful
      if (response.statusCode == 200) {
        // decoding data
        var decodedData = await jsonDecode(response.body);
        var brawlersData = decodedData["list"]; // list of all brawlers (online)

        for (final brawler in brawlersData) {
          // create record
          (String id, String image, String name) brawlerRecord = (
            brawler["id"].toString(),
            brawler["imageUrl"] as String,
            brawler["name"] as String,
          );

          // offline brawlers
          String offlineBContent = await rootBundle.loadString('assets/data/brawler_mapping.json');
          final offlineBrawlers = jsonDecode(offlineBContent);

          //check if brawler exists offline
          if (offlineBrawlers[brawlerRecord.$1] != null) {
            // adds if it exists
            appBrawlersData.add(brawlerRecord);
          }
        }

        _brawlers = appBrawlersData;
        debugPrint('🔨[Brawl Service] Brawlers initialized');
      } else {
        throw Exception("Unexpected status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌[Brawl Service] An error ocurred getting brawlers: $e");
    }
  }

  /// Gets all maps from api, including image and name.
  ///
  /// Returns all maps available to pick.
  Future<void> initMaps() async {
    try {
      final List<(String, String, String)> brawlMaps = [];
      final response = await http.get(Uri.parse("https://api.brawlapi.com/v1/maps"));

      //if the call was successful
      if (response.statusCode == 200) {
        // process data
        final stringLocalMaps = await rootBundle.loadString('assets/data/map_mapping.json');
        final localMaps = await jsonDecode(stringLocalMaps);
        final decodedOnlineMaps = await jsonDecode(response.body);
        final onlineMaps = decodedOnlineMaps["list"];

        for (final map in onlineMaps) {
          String mapId = map["id"].toString();

          // check availability
          if (localMaps[mapId] != null) {
            // Create map data
            String mapName = map["name"].toString();
            String mapImage = map["imageUrl"].toString();

            // build register
            final (String, String, String) brawlMap = (mapId, mapImage, mapName);

            // add register
            brawlMaps.add(brawlMap);
          }
        }

        _maps = brawlMaps;
        debugPrint('🗺️  [Brawl Service] Maps initialized');
      } else {
        throw Exception("Unexpected status code. ${response.statusCode}");
      }
    } catch (e) {
      debugPrint('❌[Brawl Service] An error occurred loading maps: $e');
      _maps = [];
    }
  }

  /// Initializes player data
  ///
  /// Returns if the initialization was successful.
  Future<bool> initPlayerData() async {
    try {
      // get id
      String id = SettingsService.instance.userId;

      // check id
      if (id.isEmpty || !id.startsWith("#")) throw Exception("❌ User id is not valid");

      // handle result
      final result = await http.get(
        Uri.parse("https://rankify.wolkar-rblx.workers.dev"),
        headers: {"tag": id.toUpperCase()},
      );

      if (result.statusCode == 200) {
        final content = result.body;
        _userData = jsonDecode(content);
        debugPrint('✅ [Brawl Service] Brawlers loaded successfully');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('⭕ [Brawl Service] An error ocurred initting player data: $e');
      return false;
    }
  }

  //==============
  //============== Methods / Utilities
  //==============

  /// Get brawler power level
  ///
  /// [id] the brawler id to search
  ///
  /// Returns the power level, or null if not available
  int? getBrawlerPowerLevel(String id) {
    //check if data is empty
    if (_userData.isEmpty) return null;

    // check if brawlers exist
    if (!_userData.containsKey("brawlers")) return null;

    // iterate through all brawlers
    for (final brawler in _userData["brawlers"]) {
      if (brawler["id"]?.toString() == id) {
        return brawler["power"];
      }
    }

    return null;
  }

  /// Checks if a brawler is unlocked
  ///
  /// [id] is the id of the brawler to check
  ///
  /// Returns true if unlocked, or false if not or error
  bool isBrawlerUnlocked(String id) {
    // check if data is empty
    if (_userData.isEmpty) return false;

    // check if brawler key exist
    if (!_userData.containsKey("brawlers")) return false;

    // iterate through all brawlers
    for (final brawler in _userData["brawlers"]) {
      if (brawler["id"]?.toString() == id) {
        return true;
      }
    }

    return false;
  }

  //==============
  //============== Getters
  //==============

  /// Instancia del singleton
  static BrawlService get instance => _instance;

  /// Game brawlers
  List<(String, String, String)> get brawlers => _brawlers;

  /// Game maps
  List<(String, String, String)> get maps => _maps;

  /// Returns the user data
  Map<String, dynamic> get userData => _userData;

  //==============
  //============== Getter Functions
  //==============

  /// Returns if id is valid
  bool get validId {
    String id = SettingsService.instance.userId;
    return id.isNotEmpty && id.startsWith("#");
  }

  /// Returns player rankName
  RankName get rankName {
    // Handle errors
    if (!_userData.containsKey("rankedRankName")) return RankName.bronze;

    // get rank name
    String rankName = _userData["rankedRankName"];

    return switch (rankName.toLowerCase()) {
      String s when s.contains("bronze") => RankName.bronze,
      String s when s.contains("silver") => RankName.silver,
      String s when s.contains("gold") => RankName.gold,
      String s when s.contains("diamond") => RankName.diamond,
      String s when s.contains("mythic") => RankName.mythic,
      String s when s.contains("legendary") => RankName.legendary,
      String s when s.contains("masters") => RankName.masters,
      String s when s.contains("pro") => RankName.pro,
      _ => RankName.bronze, // El default
    };
  }
}

enum RankName { bronze, silver, gold, diamond, mythic, legendary, masters, pro }
