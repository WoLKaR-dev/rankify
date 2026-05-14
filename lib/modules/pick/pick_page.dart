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
import 'package:rankify/components/prediction_service.dart';
import 'package:rankify/core/theme.dart';
import 'package:rankify/modules/pick/pick_code.dart';
import 'package:rankify/modules/pick/pick_service.dart';
import 'package:rankify/modules/pick/pick_styles.dart';
import 'package:rankify/modules/settings/settings_enums.dart';
import 'package:rankify/modules/settings/settings_service.dart';
import 'package:wolkarutils/wolkarutils.dart';

/// It's the screen where the user will be able to select the map and the brawlers.
class PickPage extends StatefulWidget {
  const PickPage({super.key});
  @override
  State<PickPage> createState() => _PickPageState();
}

class _PickPageState extends State<PickPage> {
  /// Updates state.
  void updateState() async {
    setState(() {});
  }

  //LOGIC Updates state on pick service call
  @override
  void initState() {
    PredictionService.instance.notifier.addListener(updateState);
    PickService.instance.notifier.addListener(updateState);
    super.initState();
  }

  @override
  void dispose() {
    PredictionService.instance.notifier.removeListener(updateState);
    PickService.instance.notifier.removeListener(updateState);
    super.dispose();
  }

  //LOGIC Advance from phase
  /// Advance the current phase ensuring that the required information was
  /// submitted.
  void advancePhase() async {
    if (PickService.instance.phase == 1) {
      PickService.instance.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    //ATOMS FAB
    final fab = PickService.instance.phase == 1
        ? FloatingActionButton.extended(
            onPressed: advancePhase,
            label: Text("Next Match!").p(),
            icon: Icon(Icons.arrow_forward_rounded),
          )
        : null;

    //ATOMS Filter options
    final filterOptions = [
      Input(
        initiallySelected: true,
        controller: PickService.instance.controller,
        dialog: true,
        onChange: (_) {
          setState(() {});
        },
      ),
    ];

    //ATOMS Map Picker
    final mapPicker = [
      SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.70,
        child: Scroll(
          scrollDirection: Axis.horizontal,
          children: [
            GridView.count(
              childAspectRatio: 1.6,
              shrinkWrap: true,
              crossAxisCount: 2,
              scrollDirection: Axis.horizontal,
              children: [
                ...List.generate(
                  BrawlService.instance.maps
                      .where(
                        (m) => m.$3.toLowerCase().contains(
                          PickService.instance.controller.text.toLowerCase(),
                        ),
                      )
                      .toList()
                      .length,
                  (index) {
                    (String id, String image, String name) map = BrawlService.instance.maps
                        .where(
                          (m) => m.$3.toLowerCase().contains(
                            PickService.instance.controller.text.toLowerCase(),
                          ),
                        )
                        .toList()[index];
                    return MapPickableCard(
                      map: map,
                      selected: PickService.instance.selectedMap == map,
                      onTap: () {
                        PickService.instance.update(newSelectedMap: map);
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ];

    //ATOMS Ban Picker
    final banPicker = [
      Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: switch (WolkarUtils.instance.screenSize) {
            ScreenSize.small || ScreenSize.regular => double.infinity,
            _ => MediaQuery.sizeOf(context).width * 0.5,
          },
          child: Material(
            child: ExpansionTile(
              shape: Border.all(color: Colors.transparent),
              title: Text("Bans").h6(),
              initiallyExpanded: SettingsService.instance.bansExpanded,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 5,
                  spacing: 5,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5,
                      children: List.generate(3, (index) {
                        final ban = PickService.instance.bans[index];
                        return GestureDetector(
                          child: PickedBrawlerCard(
                            onLongTap: () {
                              List<(String, String, String)?> newBans = PickService.instance.bans;
                              newBans[index] = null;
                              PickService.instance.update(newBans: newBans);
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BrawlerSelectionPage(
                                    filterController: PickService.instance.controller,
                                  ),
                                ),
                              ).then((value) async {
                                List<(String, String, String)?> newBans = PickService.instance.bans;
                                newBans[index] = value;
                                PickService.instance.update(newBans: newBans);
                              });
                            },
                            brawler: ban,
                            isAlly: false,
                          ),
                        );
                      }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5,
                      children: List.generate(3, (index) {
                        final ban = PickService.instance.bans[index + 3];
                        return GestureDetector(
                          child: PickedBrawlerCard(
                            onLongTap: () {
                              List<(String, String, String)?> newBans = PickService.instance.bans;
                              newBans[index + 3] = null;
                              PickService.instance.update(newBans: newBans);
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BrawlerSelectionPage(
                                    filterController: PickService.instance.controller,
                                  ),
                                ),
                              ).then((value) async {
                                List<(String, String, String)?> newBans = PickService.instance.bans;
                                newBans[index + 3] = value;
                                PickService.instance.update(newBans: newBans);
                              });
                            },
                            brawler: ban,
                            isAlly: false,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ];

    //ATOMS Team picker
    final teamPicker = [
      Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 5,
        spacing: 5,
        children: [
          //SECTION Allies Picker
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [
              ...List.generate(PickService.instance.allies.length, (index) {
                final brawler = PickService.instance.allies[index];
                return GestureDetector(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("Ally ${(index + -3).abs()}").h6(color: Colors.blueAccent),
                          (index - 3).abs() == 1
                              ? Icon(Icons.military_tech, color: Colors.blueAccent)
                              : SizedBox(),
                        ],
                      ),
                      PickedBrawlerCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BrawlerSelectionPage(
                                filterController: PickService.instance.controller,
                              ),
                            ),
                          ).then((value) async {
                            List<(String, String, String)?> newAllies = PickService.instance.allies;
                            newAllies[index] = value;
                            PickService.instance.update(newAllies: newAllies);
                          });
                        },
                        onLongTap: () async {
                          List<(String, String, String)?> newAllies = PickService.instance.allies;
                          newAllies[index] = null;
                          PickService.instance.update(newAllies: newAllies);
                        },
                        brawler: brawler,
                        isAlly: true,
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),

          //SECTION Enemy picker
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [
              ...List.generate(PickService.instance.enemies.length, (index) {
                final brawler = PickService.instance.enemies[index];
                return GestureDetector(
                  child: Column(
                    children: [
                      PickedBrawlerCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BrawlerSelectionPage(
                                filterController: PickService.instance.controller,
                              ),
                            ),
                          ).then((value) async {
                            List<(String, String, String)?> newEnemies =
                                PickService.instance.enemies;
                            newEnemies[index] = value;
                            PickService.instance.update(newEnemies: newEnemies);
                          });
                        },
                        onLongTap: () async {
                          List<(String, String, String)?> newEnemies = PickService.instance.enemies;
                          newEnemies[index] = null;
                          PickService.instance.update(newEnemies: newEnemies);
                        },
                        brawler: brawler,
                        isAlly: false,
                      ),
                      Row(
                        children: [
                          Text("Red ${(index + 1).abs()}").h6(color: Colors.redAccent),
                          (index + 1) == 1
                              ? Icon(Icons.military_tech, color: Colors.redAccent)
                              : SizedBox(),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    ];

    //ATOMS AI runtime predictions section
    final runtimePredictionsSection = [
      //SECTION Title
      Wrap(
        runSpacing: 10,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        children: [
          Text("AI Runtime Predictions").h4(),
          if (PredictionService.instance.isPredicting) CircularProgressIndicator(),
        ],
      ),
      Text("Best 5 brawlers").h4(),

      //SECTION Content
      SizedBox(
        child: Stack(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 5,
              runSpacing: 5,
              children: [
                ...List.generate(PredictionService.instance.latestPredictions.isNotEmpty ? 5 : 0, (
                  index,
                ) {
                  final predict = PredictionService.instance.latestPredictions[index];
                  return PredictedBrawlerCard(predict: predict);
                }),
              ],
            ),
            if (PredictionService.instance.isPredicting)
              Positioned.fill(
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(241, 0, 0, 0),
                  ),
                  child: Scroll(
                    spacing: 10,
                    children: [
                      Text(("Predicting")).h5(color: colorPallete.secondaryContainer),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),

      //SECTION More data
      SizedBox(
        width: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small || ScreenSize.regular => double.infinity,
          ScreenSize.large => MediaQuery.sizeOf(context).width * 0.7,
          ScreenSize.xlarge => MediaQuery.sizeOf(context).width * 0.4,
          ScreenSize.xxlarge => MediaQuery.sizeOf(context).width * 0.3,
        },
        child: Material(
          color: colorPallete.surface,
          child: ExpansionTile(
            shape: BoxBorder.all(color: Colors.transparent),
            title: Text("See all data").h5(),
            initiallyExpanded: SettingsService.instance.allDataExpanded,
            children: [
              Table(
                border: TableBorder.all(color: colorPallete.outline),
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: colorPallete.secondaryFixed),
                    children: [
                      Center(child: Text("Name").h6()),
                      Center(
                        child: Text(
                          SettingsService.instance.model == Model.v1 ? "Value" : "Delta",
                        ).h6(),
                      ),
                    ],
                  ),
                  ...List.generate(PredictionService.instance.latestPredictions.length, (index) {
                    final brawler = PredictionService.instance.latestPredictions[index];
                    return TableRow(
                      decoration: BoxDecoration(
                        color: index.isEven
                            ? colorPallete.surfaceContainer
                            : colorPallete.surfaceContainerHighest,
                      ),
                      children: [
                        Center(child: Text(brawler.$3).p()),
                        Center(child: Text((brawler.$4 * 100).toStringAsFixed(2)).p()),
                      ],
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    ];

    //LAYOUT Map Picker page
    /// The screen where the user selects the map of the match.
    final mapPickerPage = Background(
      padding: EdgeInsets.all(15),
      child: Scroll(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [...filterOptions, ...mapPicker],
      ),
    );

    //LAYOUT Teammates picker
    /// It's the screen where the user selects the brawlers of the team.
    final teammatesPickerPage = Background(
      padding: EdgeInsets.all(15),
      child: Scroll(
        spacing: 15,
        children: [
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Time to pick!").h3(),
              IconButton(
                onPressed: () {
                  showPickedMap(context);
                },
                icon: Icon(Icons.map_rounded),
              ),
            ],
          ),
          ...banPicker,
          ...teamPicker,
          ...runtimePredictionsSection,
          SizedBox(height: 75),
        ],
      ),
    );

    //LAYOUT Main page
    final page = switch (PickService.instance.phase) {
      0 => mapPickerPage,
      1 => teammatesPickerPage,
      _ => mapPickerPage,
    };

    //WRAPPER Brawler wrapper
    return Scaffold(body: page, floatingActionButton: fab);
  }
}

/// It's the screen where the user selects the brawlers of the team.
///
/// [PickService.instance.allies] The brawlers of the team.
/// [enemyBrawlers] The brawlers of the enemy team.
/// [filterController] The controller of the filter.
///
/// Returns the picked brawler when the user taps on a brawler.
class BrawlerSelectionPage extends StatefulWidget {
  const BrawlerSelectionPage({super.key, required this.filterController});
  final TextEditingController filterController;
  @override
  State<BrawlerSelectionPage> createState() => _BrawlerSelectionPageState();
}

class _BrawlerSelectionPageState extends State<BrawlerSelectionPage> {
  @override
  Widget build(BuildContext context) {
    //ATOMS Appbar
    final AppBar appBar = AppBar(title: Text("Select Brawlers"));

    //ATOMS Filter options
    final filterOptions = [
      Row(
        children: [
          Input(
            controller: widget.filterController,
            dialog: true,
            onChange: (_) {
              setState(() {});
            },
          ),
        ],
      ),
    ];

    //ATOMS Brawler cards
    final brawlerCards = [
      ...List.generate(
        BrawlService.instance.brawlers
            .where((b) => b.$3.toLowerCase().contains(widget.filterController.text.toLowerCase()))
            .length,
        (index) {
          (String, String, String) brawler = BrawlService.instance.brawlers
              .where((b) => b.$3.toLowerCase().contains(widget.filterController.text.toLowerCase()))
              .toList()[index];
          return PickableCard(
            available: ![
              ...PickService.instance.allies,
              ...PickService.instance.enemies,
            ].contains(brawler),
            brawlerRecord: brawler,
            onTap: () {
              Navigator.pop(context, brawler);
            },
          );
        },
      ),
    ];

    //ATOMS Brawler for big screens
    final bigScreenBrawlerPicker = Scroll(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        ...filterOptions,
        SizedBox(
          height: switch (WolkarUtils.instance.screenSize) {
            ScreenSize.small => 500,
            ScreenSize.regular => 500,
            ScreenSize.large => 500,
            ScreenSize.xlarge => 600,
            ScreenSize.xxlarge => 600,
          },
          child: Scroll(
            scrollDirection: Axis.horizontal,
            children: [
              GridView.count(
                childAspectRatio: 0.5,
                shrinkWrap: true,
                crossAxisCount: 3,
                scrollDirection: Axis.horizontal,
                children: brawlerCards,
              ),
            ],
          ),
        ),
      ],
    );

    //ATOMS Brawler picker for small screens
    final smallScreensBrawlerPicker = Scroll(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [...filterOptions, ...brawlerCards],
    );

    //LAYOUT Main page
    final page = Background(
      padding: EdgeInsets.all(15),
      child: [ScreenSize.small, ScreenSize.regular].contains(WolkarUtils.instance.screenSize)
          ? smallScreensBrawlerPicker
          : bigScreenBrawlerPicker,
    ).aligned();

    //LAYOUT Brawler picker page
    final brawlerPickerPage = Scaffold(body: page);

    return Scaffold(appBar: appBar, body: brawlerPickerPage);
  }
}
