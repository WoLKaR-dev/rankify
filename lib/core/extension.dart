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

extension CheckList on String {
  /// Checks if the phrase contains any of the words in list
  ///
  /// [wordList] as the list of words to check
  ///
  /// Returns if any of the words in the list contains main word
  bool containsAny(List<String> wordList) => wordList.any((w) => contains(w));

  /// Check if the word has any similarity
  ///
  /// [wordList] as the full list to check
  /// [treshold] the minimum percentaje to consider as similar
  ///
  /// Returns wether it found a similarity or not
  bool isListSimilar(List<String> wordList, {double treshold = 0.65}) =>
      wordList.any((w) => isSimilar(w) >= treshold);

  /// Detects similarities between two words
  ///
  /// [word] word to compare similarity
  ///
  /// Returns a number between `1` and `0` when `1` is 100% sure
  double isSimilar(String word) {
    final maxLength = word.length > length ? word.length : length;
    int coincidences = 0;
    for (int char = 0; char < maxLength; char++) {
      bool areSame = false;
      try {
        final localChar = toLowerCase()[char];
        final compareChar = word.toLowerCase()[char];
        areSame = localChar == compareChar;
      } catch (e) {
        areSame = false;
      }
      coincidences = areSame ? coincidences += 1 : coincidences;
    }
    return coincidences / maxLength;
  }
}

extension Fullfill on List<bool> {
  double getFullfillment() {
    final total = length;
    int correct = 0;
    for (final bool boolean in this) {
      if (boolean) correct++;
    }

    return correct / total; 
  }
}
