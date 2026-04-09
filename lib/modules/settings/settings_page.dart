import 'package:flutter/material.dart';
import 'package:rankify/modules/settings/settings_data.dart';
import 'package:rankify/modules/settings/settings_enums.dart';
import 'package:rankify/modules/settings/settings_service.dart';
import 'package:wolkarutils/wolkarutils.dart';

/// Is the page where the user can change settings.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //FORM Main slider value
  late double sliderValue;

  @override
  void initState() {
    super.initState();
    sliderValue = switch (SettingsService.instance.mode) {
      SpeechMode.pro => 0,
      SpeechMode.aggro => 0.5,
      SpeechMode.savage => 1,
    };
  }

  @override
  Widget build(BuildContext context) {
    //ATOMS Speech section
    final speechSection = [
      Text("Speech Mode").h4(),
      ListenableBuilder(
        listenable: SettingsService.instance.notifier,
        builder: (context, child) {
          return SizedBox(
            width: switch (WolkarUtils.instance.screenSize) {
              ScreenSize.small || ScreenSize.regular => double.infinity,
              ScreenSize.large => MediaQuery.sizeOf(context).width * 0.7,
              ScreenSize.xlarge => MediaQuery.sizeOf(context).width * 0.4,
              ScreenSize.xxlarge => MediaQuery.sizeOf(context).width * 0.3,
            },
            child: Column(
              spacing: 5,
              children: [
                Text("Current mode: ${SettingsService.instance.mode.value}").h6(),
                Slider(
                  // ignore: deprecated_member_use
                  year2023: false,
                  divisions: 2,
                  value: sliderValue,
                  onChanged: (value) {
                    SpeechMode newMode = switch (double.parse(value.toStringAsFixed(1))) {
                      0 => SpeechMode.pro,
                      0.5 => SpeechMode.aggro,
                      1 => SpeechMode.savage,
                      _ => SpeechMode.pro,
                    };
                    SettingsService.instance.update(newMode: newMode);

                    setState(() {
                      sliderValue = value;
                    });
                  },
                ),
                Align(
                  alignment: AlignmentGeometry.topLeft,
                  child: Text(speechModesDescription[SettingsService.instance.mode]!).p(),
                ),
              ],
            ),
          );
        },
      ),
    ];

    //LAYOUT Main page
    final page = Background(
      padding: EdgeInsets.all(15),
      child: Scroll(spacing: 15, children: [...speechSection]),
    );

    //WRAPPER Main structure
    return Scaffold(body: page);
  }
}
