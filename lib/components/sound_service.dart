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
