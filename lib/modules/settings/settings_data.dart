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

import 'package:rankify/modules/settings/settings_enums.dart';

const Map<SpeechMode, String> speechModesDescription = {
  SpeechMode.pro:
      "Rankify will behave:\n- Short responses\n- No jokes\n- No personality\n\nExample: \nQ: Rankify, pick Rosa\nA: (Picked sound).",
  SpeechMode.aggro:
      "Rankify will behave:\n- Aggressive responses\n- Sarcastic\n- Jokes\n- Personality\n\nExample: \nQ: Rankify, pick Rosa\nA: (Picked sound). Rosa in this map? I didn't know we were trying to lose.",
};

const Map<Model, String> modelDescription = {
  Model.v1:
      "Classic: \n- Chooses based on map, allies and enemies. \n- Identifies strong meta picks consistently. \n- Stable recommendations. \n- Focused on overall composition strength. ",
  Model.v2:
      "Delta: \n- Calculates real impact of each brawler on your current team. \n- Measures improvement over current draft state. \n- Detects synergies and contextual counters.\n- Reduces dependency over global meta. \n- Varied recommendations. ",
  Model.v3:
      "Strategy: \n- Optimizes both your advantage and enemy denial. \n- Evaluates impact for your team and potential enemy gain. \n- Identifies high-value counters and critical deny picks. \n- Delivers strategic, draft-aware decision making. ",
};

const Map<Optimization, String> optimizationDescription = {
  Optimization.few: "Fast: \n- Calculates first 10 brawlers. \n- Optimal for quick choices.",
  Optimization.regular:
      "Regular: \n- Calculates first 25 brawlers. \n- Good balance between predict amount and speed.",
  Optimization.personalized:
      "Personalized: \n- Calculate all brawlers you want. \n- May slow down some devices.",
};
