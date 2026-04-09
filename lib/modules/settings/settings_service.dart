import 'package:rankify/components/notifier_service.dart';
import 'package:rankify/modules/settings/settings_enums.dart';

class SettingsService {
  //==============
  //============== Attributes
  //==============

  /// Instancia principal del singleton
  static final SettingsService _instance = SettingsService._internal();

  /// Active speech mode
  SpeechMode _mode = SpeechMode.pro;

  /// Class notifier
  final SettingsNotifier _notifier = SettingsNotifier();

  //==============
  //============== Constructors
  //==============

  /// Constructor privado interno
  SettingsService._internal();

  //==============
  //============== Methods
  //==============

  /// Updates settings instance.
  ///
  /// [newMode] as the new [SpeechMode]
  void update({SpeechMode? newMode}) {
    _mode = newMode ?? _mode;
    _notifier.notify(); 
  }

  //==============
  //============== Getters
  //==============

  /// Instancia del singleton
  static SettingsService get instance => _instance;

  /// Speech mode
  SpeechMode get mode => _mode;

  /// Notifier
  SettingsNotifier get notifier => _notifier;

  //==============
  //============== Getter Functions
  //==============
}
