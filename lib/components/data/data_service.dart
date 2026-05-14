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
import 'package:wolkarutils/wolkarutils.dart';
import 'package:rankify/components/web/web_utils.dart';

class DataService extends DataServiceInterface {
  //==============
  //============== Attributes
  //==============

  /// Instancia principal del singleton
  static final DataService _instance = DataService._internal();

  //==============
  //============== Constructors
  //==============

  /// Constructor privado interno
  DataService._internal();

  /// Factory constructor
  factory DataService() => _instance;

  //==============
  //============== Methods
  //==============

  /// Initializes a web directory
  @override
  Future<bool> initWebDirectory() async {
    return await initBridgeDirectory();
  }

  /// Writes a new web file
  @override
  Future<bool> writeWebFile(String name, String content, String ext) async {
    final result = await writeBridgeFile(name, content, ext); 
    return result;
  }

  /// Reads a new web file 
  @override
  Future<String> readWebFile(String name, String ext) async {
    final result = await readBridgeFile(name, ext);
    return result;
  }

  //==============
  //============== Getters
  //==============

  //==============
  //============== Getter Functions
  //==============
}
