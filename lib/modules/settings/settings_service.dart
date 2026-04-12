import 'package:rankify/core/notifiers.dart';
import 'package:rankify/modules/settings/settings_enums.dart';

class SettingsService {
  //==============
  //============== Attributes
  //==============

  /// Instancia principal del singleton
  static final SettingsService _instance = SettingsService._internal();

  /// Active speech mode
  SpeechMode _mode = SpeechMode.pro;

  /// Active model
  Model _model = Model.v2;

  /// Class notifier
  final SettingsNotifier _notifier = SettingsNotifier();

  //==============
  //============== Attributes / v3
  //==============

  /// V3 Optimization Setting
  Optimization _v3Optimization = Optimization.regular;

  /// V3 Personalized Brawlers
  int _v3PersonalizedBrawlers = 5; 

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
  void update({SpeechMode? newMode, Model? newModel, Optimization? newV3Optimization, int? newV3PersonalizedBrawlers}) {
    _mode = newMode ?? _mode;
    _model = newModel ?? _model;
    _v3Optimization = newV3Optimization ?? _v3Optimization;
    _v3PersonalizedBrawlers = newV3PersonalizedBrawlers ?? _v3PersonalizedBrawlers;
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

  /// Model
  Model get model => _model;

  /// V3 Optimization
  Optimization get v3Optimization => _v3Optimization;

  /// V3 Personalized Brawlers
  int get v3PersonalizedBrawlers => _v3PersonalizedBrawlers;

  //==============
  //============== Getter Functions
  //==============
}
