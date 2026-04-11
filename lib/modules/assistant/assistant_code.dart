import 'package:flutter/material.dart';
import 'package:rankify/components/brawl_service.dart';
import 'package:rankify/components/sound_service.dart';
import 'package:rankify/core/extension.dart';

/// Tryes to pick a map from a list of words
///
/// [wordList] list of words that may be the name of the map
void assistantPickMap(List<String> wordList) {
  List<Map<String, dynamic>> records = [];
  for (final map in BrawlService.instance.maps) {
    List<bool> coincidenceResults = [];
    for (final mapWord in map.$3.toLowerCase().split(" ")) {
      bool result = mapWord.isListSimilar(wordList);
      coincidenceResults.add(result);
    }
    records.add({"map": map, "coincidences": coincidenceResults});
  }
  records.sort(
    (m1, m2) => (m1["coincidences"] as List<bool>).getFullfillment().compareTo(
      (m2["coincidences"] as List<bool>).getFullfillment(),
    ),
  );
  records = records.reversed.toList();
  (records.first["coincidences"] as List<bool>).getFullfillment() > 0.45
      ? SoundService.instance.playStatusSound(StatusSound.success)
      : SoundService.instance.playStatusSound(StatusSound.error);

      debugPrint('${records.first["map"].$3}');
}
