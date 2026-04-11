import 'package:flutter/material.dart';
import 'package:rankify/components/sound_service.dart';
import 'package:rankify/core/extension.dart';
import 'package:rankify/modules/assistant/assistant_code.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AssistantService {
  //==============
  //============== Attributes
  //==============

  /// Instancia principal del singleton
  static final AssistantService _instance = AssistantService._internal();

  /// Main detection instance
  final SpeechToText speech = SpeechToText();

  /// Flag to avoid double activation
  bool _isWakeWordDetected = false;

  //==============
  //============== Constructors
  //==============

  /// Constructor privado interno
  AssistantService._internal();

  //==============
  //============== Methods
  //==============

  /// Initializes active hearing
  void initHearing() async {
    try {
      final result = await speech.initialize();
      if (!result) throw Exception("Mic not available");
      speech.listen(
        listenOptions: SpeechListenOptions(partialResults: true),
        onResult: (result) {
          processText(result.recognizedWords);
          if (result.finalResult) {
            _isWakeWordDetected = false;
          }
        },
      );
    } catch (e) {
      debugPrint('An error occurred while initting: $e');
    }
  }

  /// Processes text to detect wake word (Simulation or Real)
  void processText(String text) async {
    final cleanText = text.toLowerCase();

    // Check for wake word
    if (cleanText.contains("rankify")) {
      if (!_isWakeWordDetected) {
        _isWakeWordDetected = true;
        SoundService.instance.playStatusSound(StatusSound.activation);

        await Future.delayed(Duration(seconds: 1));

        // processes maps
        if ([
          "map",
          "mapa",
        ].map((s) => s.isListSimilar(cleanText.split(" "))).toList().any((t) => t == true)) {
          _processMapCommand(cleanText);
          return;
        }

        // processes ally
        if (cleanText.containsAny(["amigo", "compañero", "azul", "aliado"])) {}

        // processes enemy
        if (cleanText.containsAny(["enemigo", "rival", "rojo"])) {
          SoundService.instance.playStatusSound(StatusSound.success);
        }

        // any other thing
        SoundService.instance.playStatusSound(StatusSound.error);

        _isWakeWordDetected = false;
      }
    }
  }

  /// Process map command
  ///
  /// [textToProcess] text to process
  void _processMapCommand(String textToProcess) {
    final splittedCommand = textToProcess.split(" ");
    int position = 0;
    for (int pointer = 0; pointer < splittedCommand.length; pointer++) {
      final word = splittedCommand[pointer];
      if (word.isListSimilar(["map", "mapa"])) {
        position = pointer;
      }
    }

    if (position + 1 >= splittedCommand.length) {
      SoundService.instance.playStatusSound(StatusSound.error);
      _isWakeWordDetected = false;
      return;
    } else {
      splittedCommand.removeAt(0);
      splittedCommand.removeAt(0);
      assistantPickMap(splittedCommand);
      _isWakeWordDetected = false;
    }
  }

  /// Processes ally or enemy pick
  ///
  /// [textToProcess] text to process
  // ignore: unused_element
  void _processPlayerCommand(String textToProcess) {}

  //==============
  //============== Getters
  //==============

  /// Instancia del singleton
  static AssistantService get instance => _instance;

  //==============
  //============== Getter Functions
  //==============
}
