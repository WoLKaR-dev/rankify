import 'package:flutter/material.dart';

class SettingsNotifier extends ChangeNotifier {
  /// Notifies
  void notify() {
    notifyListeners();
  }
}

/// Notify any change during pick phase
class PickNotifier extends ChangeNotifier {
  /// Notifies
  void notify() {
    notifyListeners();
  }
}

/// Notify changes in predictions
class PredictionServiceNotifier extends ChangeNotifier {
  /// Notifies
  void notify() {
    notifyListeners();
  }
}
