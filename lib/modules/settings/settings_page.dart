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

  //FORM Brawl stars id controller
  final TextEditingController _idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _idController.text = SettingsService.instance.userId;
    sliderValue = switch (SettingsService.instance.mode) {
      SpeechMode.pro => 0,
      SpeechMode.aggro => 1,
    };
  }

  @override
  Widget build(BuildContext context) {
    //ATOMS Model section
    final modelSection = [
      Divider().percentage(50),
      Text("Model").h3(),
      SegmentedButton(
        segments: [
          /*
          ButtonSegment(
            value: Model.v4,
            label: Text(Model.v4.value),
            icon: Icon(Icons.new_releases_rounded),
          ),*/
          ButtonSegment(
            value: Model.v3,
            icon: Icon(Icons.open_in_new_rounded),
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

    //ATOMS Model settings
    final modelSettingsSection = [
      Divider().percentage(30),
      Text("Optimization Settings").h4(),
      Text("Current setting: ${SettingsService.instance.optimization.value}").h6(),
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
              value: switch (SettingsService.instance.optimization) {
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
              child: Text(optimizationDescription[SettingsService.instance.optimization]!).p(),
            ),
          ],
        ),
      ),
      if (SettingsService.instance.optimization == Optimization.personalized) ...[
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
                onChangeEnd: (value) {
                  SettingsService.instance.update(
                    newV3PersonalizedBrawlers: int.parse(value.toStringAsFixed(0)),
                  );
                  setState(() {});
                },
                onChanged: (value) {
                  SettingsService.instance.update(
                    saveData: false,
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

    //ATOMS Pick Page Related
    final pickPageRelated = [
      Divider().percentage(50),
      Text("Pick Related").h3(),
      Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: [
          Text("Initially expand bans section: ").p(),
          ListenableBuilder(
            listenable: SettingsService.instance.notifier,
            builder: (context, child) {
              return Switch(
                value: SettingsService.instance.bansExpanded,
                onChanged: (newValue) {
                  SettingsService.instance.update(newBansExpanded: newValue);
                },
              );
            },
          ),
        ],
      ),
      Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: [
          Text("Initially expand All Data section: ").p(),
          ListenableBuilder(
            listenable: SettingsService.instance.notifier,
            builder: (context, child) {
              return Switch(
                value: SettingsService.instance.allDataExpanded,
                onChanged: (newValue) {
                  SettingsService.instance.update(newAllDataExpanded: newValue);
                },
              );
            },
          ),
        ],
      ),
    ];

    //ATOMS user related
    final userRelated = [
      Text("User Related").h3(),
      Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        spacing: 5,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text("Brawl Stars ID: ").p(),
          Input(
            controller: _idController,
            dialog: true,
            onSubmitted: (value) async {
              SettingsService.instance.update(newUserId: value);
              await BrawlService.instance.initPlayerData();
            },
          ),
          IconButton(
            onPressed: () {
              SettingsService.instance.update(newUserId: "");
              setState(() {});
              _idController.text = "";
            },
            icon: Icon(Icons.restore),
          ),
        ],
      ),
      Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        spacing: 5,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text("Suggest only max level brawlers: ").p(),
          ListenableBuilder(
            listenable: SettingsService.instance.notifier,
            builder: (context, child) {
              return Switch(
                value: SettingsService.instance.onlyMaxLevel,
                onChanged: (newValue) {
                  SettingsService.instance.update(newOnlyMaxLevel: newValue);
                },
              );
            },
          ),
        ],
      ),
      Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        spacing: 5,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text("Suggest only unlocked brawlers: ").p(),
          ListenableBuilder(
            listenable: SettingsService.instance.notifier,
            builder: (context, child) {
              return Switch(
                value: SettingsService.instance.onlyUnlocked,
                onChanged: (newValue) {
                  SettingsService.instance.update(newOnlyUnlocked: newValue);
                },
              );
            },
          ),
        ],
      ),
    ];

    //LAYOUT Main page
    final page = Background(
      padding: EdgeInsets.all(15),
      child: Scroll(
        spacing: 15,
        children: [
          ...userRelated,
          ...pickPageRelated,
          ...modelSection,
          if ([Model.v3, Model.v4].contains(SettingsService.instance.model))
            ...modelSettingsSection,
        ],
      ),
    );

    //WRAPPER Main structure
    return Scaffold(body: page);
  }
}
