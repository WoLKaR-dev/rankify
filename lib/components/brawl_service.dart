import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      var response = await http.get(Uri.parse("https://api.brawlify.com/v1/brawlers"));

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
        debugPrint('🔨 Brawlers initialized');
      } else {
        throw Exception("Unexpected status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("An error ocurred getting brawlers: $e");
    }
  }

  /// Gets all maps from api, including image and name.
  ///
  /// Returns all maps available to pick.
  Future<void> initMaps() async {
    try {
      final List<(String, String, String)> brawlMaps = [];
      final response = await http.get(Uri.parse("https://api.brawlify.com/v1/maps"));

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
        debugPrint('🗺️  Maps initialized');
      } else {
        throw Exception("Unexpected status code. ${response.statusCode}");
      }
    } catch (e) {
      debugPrint('An error occurred loading maps: $e');
      _maps = [];
    }
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

  //==============
  //============== Getter Functions
  //==============
}
