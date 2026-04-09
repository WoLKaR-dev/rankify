import 'package:rankify/modules/settings/settings_enums.dart';

const Map<SpeechMode, String> speechModesDescription = {
  SpeechMode.pro:
      "Rankify will behave:\n- Short responses\n- No jokes\n- No personality\n\nExample: \nQ: Rankify, pick Rosa\nA: (Picked sound).",
  SpeechMode.aggro:
      "Rankify will behave:\n- Aggressive responses\n- Sarcastic\n- Jokes\n- Personality\n\nExample: \nQ: Rankify, pick Rosa\nA: (Picked sound). Rosa in this map? I didn't know we were trying to lose.",
  SpeechMode.savage:
      "Rankify will behave:\n- Savage responses\n- Much more sarcastic\n- More and much aggresive jokes\n- More personality\n\nExample: \nQ: Rankify, pick Rosa\nA: (Picked sound). Fuck my circuits! What the hell was that pick?",
};
