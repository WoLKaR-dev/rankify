import 'package:flutter/material.dart';

/// Notify ingredient changes
class SettingsNotifier extends ChangeNotifier {
  /// Notifies
  void notify() {
    notifyListeners();
  }
}
