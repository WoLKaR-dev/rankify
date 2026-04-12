import 'package:flutter/material.dart';
import 'package:rankify/components/brawl_service.dart';
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

  //FORM Testing controller
  final TextEditingController testingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    sliderValue = switch (SettingsService.instance.mode) {
      SpeechMode.pro => 0,
      SpeechMode.aggro => 1,
    };
  }

  @override
  Widget build(BuildContext context) {
    //ATOMS Model section
    final modelSection = [
      Text("Model").h3(),
      SegmentedButton(
        segments: [
          ButtonSegment(
            value: Model.v3,
            icon: Icon(Icons.new_releases_rounded),
            label: Text(Model.v3.value),
          ),
          ButtonSegment(
            value: Model.v2,
            icon: Icon(Icons.open_in_new_rounded),
            label: Text(Model.v2.value),
          ),
          ButtonSegment(
            value: Model.v1,
            icon: Icon(Icons.open_in_new_rounded),
            label: Text(Model.v1.value),
          ),
        ],
        selected: {SettingsService.instance.model},
        onSelectionChanged: (valueSet) {
          SettingsService.instance.update(newModel: valueSet.first);
          setState(() {});
        },
      ),
      SizedBox(
        width: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small || ScreenSize.regular => double.infinity,
          ScreenSize.large => MediaQuery.sizeOf(context).width * 0.7,
          ScreenSize.xlarge => MediaQuery.sizeOf(context).width * 0.4,
          ScreenSize.xxlarge => MediaQuery.sizeOf(context).width * 0.3,
        },
        child: Align(
          alignment: AlignmentGeometry.topLeft,
          child: Text(modelDescription[SettingsService.instance.model]!).p(),
        ),
      ),
    ];

    //ATOMS V3Model settings
    final v3SettingsSection = [
      Divider().percentage(30),
      Text("V3 Optimization Settings").h4(),
      Text("Current setting: ${SettingsService.instance.v3Optimization.value}").h6(),
      SizedBox(
        width: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small || ScreenSize.regular => double.infinity,
          ScreenSize.large => MediaQuery.sizeOf(context).width * 0.7,
          ScreenSize.xlarge => MediaQuery.sizeOf(context).width * 0.4,
          ScreenSize.xxlarge => MediaQuery.sizeOf(context).width * 0.3,
        },
        child: Column(
          spacing: 10,
          children: [
            Slider(
              // ignore: deprecated_member_use
              year2023: false,
              divisions: 2,
              value: switch (SettingsService.instance.v3Optimization) {
                Optimization.few => 0,
                Optimization.regular => 0.5,
                Optimization.personalized => 1,
              },
              onChanged: (value) {
                Optimization newOptimization = switch (double.parse(value.toStringAsFixed(1))) {
                  0 => Optimization.few,
                  0.5 => Optimization.regular,
                  1 => Optimization.personalized,
                  _ => Optimization.few,
                };
                SettingsService.instance.update(newV3Optimization: newOptimization);
                setState(() {});
              },
            ),
            Align(
              alignment: AlignmentGeometry.topLeft,
              child: Text(optimizationDescription[SettingsService.instance.v3Optimization]!).p(),
            ),
          ],
        ),
      ),
      if (SettingsService.instance.v3Optimization == Optimization.personalized) ...[
        Divider().percentage(10),
        Text("Personalization Settings").h5(),
        Text("Current calculated brawlers: ${SettingsService.instance.v3PersonalizedBrawlers}").p(),
        SizedBox(
          width: switch (WolkarUtils.instance.screenSize) {
            ScreenSize.small || ScreenSize.regular => double.infinity,
            ScreenSize.large => MediaQuery.sizeOf(context).width * 0.7,
            ScreenSize.xlarge => MediaQuery.sizeOf(context).width * 0.4,
            ScreenSize.xxlarge => MediaQuery.sizeOf(context).width * 0.3,
          },

          child: Column(
            children: [
              Slider(
                // ignore: deprecated_member_use
                year2023: false,
                divisions: BrawlService.instance.brawlers.length - 2,
                max: BrawlService.instance.brawlers.length.toDouble(),
                min: 5,
                value: SettingsService.instance.v3PersonalizedBrawlers.toDouble(),
                onChanged: (value) {
                  SettingsService.instance.update(
                    newV3PersonalizedBrawlers: int.parse(value.toStringAsFixed(0)),
                  );
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ],
    ];

    //LAYOUT Main page
    final page = Background(
      padding: EdgeInsets.all(15),
      child: Scroll(
        spacing: 15,
        children: [
          ...modelSection,
          if (SettingsService.instance.model == Model.v3) ...v3SettingsSection,
        ],
      ),
    );

    //WRAPPER Main structure
    return Scaffold(body: page);
  }
}
