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
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_web/tflite_web.dart';

class AiService {
  //==============
  //============== Attributes
  //==============

  /// Instancia principal del singleton
  static final AiService _instance = AiService._internal();

  /// AI model
  late TFLiteModel _model;

  /// Cached maps mapping
  Map<String, dynamic>? _cachedMapsMapping;

  /// Cached brawlers mapping
  Map<String, dynamic>? _cachedBrawlersMapping;




  //==============
  //============== Constructors
  //==============

  /// Constructor privado interno
  AiService._internal();

  //==============
  //============== Methods
  //==============

  /// Caches mappings data
  Future<void> _loadMappings() async {
    _cachedMapsMapping = jsonDecode(await rootBundle.loadString("assets/data/map_mapping.json"));
    _cachedBrawlersMapping = jsonDecode(
      await rootBundle.loadString("assets/data/brawler_mapping.json"),
    );
  }

  /// Initializes AI.
  Future<void> initAi() async {
    try {
      await TFLiteWeb.initializeUsingCDN();
      await _loadMappings();
      final modelData = await rootBundle.load("assets/models/draft_model.tflite");
      _model = await TFLiteModel.fromMemory(modelData.buffer.asUint8List());
    } catch (e) {
      debugPrint('Error ocurred initializing ai: $e');
    }
  }

  /// Predicts a pick
  double predict(List<List<List<int>>> input) {
    try {
      final flat0 = input[1].expand((e) => e).toList();
      final flat1 = input[0].expand((e) => e).toList();
      final flat2 = input[2].expand((e) => e).toList();

      final t0 = Tensor(Int32List.fromList(flat0), shape: [1, 3], type: TFLiteDataType.int32);
      final t1 = Tensor(Int32List.fromList(flat1), shape: [1, 1], type: TFLiteDataType.int32);
      final t2 = Tensor(Int32List.fromList(flat2), shape: [1, 3], type: TFLiteDataType.int32);

      final jsInputs = JSObject();
      jsInputs.setProperty('serving_default_allies:0'.toJS, t0 as JSAny);
      jsInputs.setProperty('serving_default_enemies:0'.toJS, t2 as JSAny);
      jsInputs.setProperty('serving_default_map:0'.toJS, t1 as JSAny);

      final output = _model.predict(jsInputs) as Tensor;

      final prob = output.dataSync()[0];

      return prob;
    } catch (e) {
      return 0.0;
    }
  }



  //==============
  //============== Getters
  //==============

  /// Instancia del singleton
  static AiService get instance => _instance;

  Map<String, dynamic>? get cachedMapsMapping => _cachedMapsMapping;

  Map<String, dynamic>? get cachedBrawlersMapping => _cachedBrawlersMapping;

  //==============
  //============== Getter Functions
  //==============
}
