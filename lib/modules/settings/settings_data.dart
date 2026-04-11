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
