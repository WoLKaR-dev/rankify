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

import 'dart:js_interop';

@JS("initStorage")
external JSPromise<JSBoolean> _initWebDirectory();

@JS("writeFile")
external JSPromise<JSBoolean> _writeWebFile(String name, String content, String ext);

@JS("readFile")
external JSPromise<JSString> _readWebFile(String name, String ext);

/// Inits web Directory
Future<bool> initBridgeDirectory() async {
  final result = await _initWebDirectory().toDart;
  return result.toDart; 
}

/// Writes a web file.
/// [name] is the required name, and [content] is the string content to write
/// [ext] is an extension.
Future<bool> writeBridgeFile(String name, String content, String ext) async {
  final result = await _writeWebFile(name, content, ext).toDart;
  return result.toDart;
}

/// Reads a web entry
/// [name] is the name to read. [ext] is an extension.
Future<String> readBridgeFile(String name, String ext) async {
  final result = await _readWebFile(name, ext).toDart;
  return result.toDart;
}
