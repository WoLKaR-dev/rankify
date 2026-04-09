import 'package:flutter/material.dart';
import 'package:rankify/components/sound_service.dart';
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
        
        
        _isWakeWordDetected = false;
      }
    }
  }

  //==============
  //============== Getters
  //==============

  /// Instancia del singleton
  static AssistantService get instance => _instance;

  //==============
  //============== Getter Functions
  //==============
}
