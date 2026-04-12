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

import 'package:audioplayers/audioplayers.dart';

enum StatusSound { activation, error, success }

class SoundService {
  //==============
  //============== Attributes
  //==============

  /// Player instance
  final AudioPlayer _player = AudioPlayer();

  /// Instancia principal del singleton
  static final SoundService _instance = SoundService._internal();

  //==============
  //============== Constructors
  //==============

  /// Constructor privado interno
  SoundService._internal();

  //==============
  //============== Methods
  //==============

  //==============
  //============== Sounds
  //==============

  /// Plays an status sound 
  /// 
  /// [statusSound] as the sound to play from [StatusSound]
  void playStatusSound(StatusSound statusSound) async {
    await _player.setSource(
      AssetSource(switch (statusSound) {
        StatusSound.activation => "sounds/activation.mp3",
        StatusSound.error => "sounds/error.mp3",
        StatusSound.success => "sounds/accepted.mp3",
      }),
    );
    _player.resume();
  }

  //==============
  //============== Getters
  //==============

  /// Instancia del singleton
  static SoundService get instance => _instance;

  //==============
  //============== Getter Functions
  //==============
}
