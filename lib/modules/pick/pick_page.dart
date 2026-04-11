import 'package:flutter/material.dart';
import 'package:rankify/components/brawl_service.dart';
import 'package:rankify/core/theme.dart';
import 'package:rankify/modules/pick/pick_code.dart';
import 'package:rankify/modules/pick/pick_service.dart';
import 'package:rankify/modules/pick/pick_styles.dart';
import 'package:wolkarutils/wolkarutils.dart';

/// It's the screen where the user will be able to select the map and the brawlers.
class PickPage extends StatefulWidget {
  const PickPage({super.key});
  @override
  State<PickPage> createState() => _PickPageState();
}

class _PickPageState extends State<PickPage> {
  //STATE List of predicts
  /// List of predicts
  List<(String, String, String, double)> predicts = [];

  /// Updates state.
  void updateState() async {
    if (PickService.instance.phase == 1) {
      final predict = await predictGame();
      predicts = predict;
    }
    setState(() {});
  }

  //LOGIC Updates state on pick service call
  @override
  void initState() {
    PickService.instance.notifier.addListener(updateState);
    super.initState();
  }

  @override
  void dispose() {
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
      Row(
        children: [
          Input(
            controller: PickService.instance.controller,
            dialog: true,
            onChange: (_) {
              setState(() {});
            },
          ),
        ],
      ),
    ];

    //ATOMS Map Picker
    final mapPicker = [
      SizedBox(
        height: [ScreenSize.small, ScreenSize.regular].contains(WolkarUtils.instance.screenSize)
            ? 600
            : 700,
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

    //ATOMS Team picker
    final teamPicker = [
      Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 5,
        spacing: 5,
        children: [
          ...List.generate(PickService.instance.allies.length, (index) {
            final brawler = PickService.instance.allies[index];
            return GestureDetector(
              child: PickedBrawlerCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BrawlerSelectionPage(filterController: PickService.instance.controller),
                    ),
                  ).then((value) async {
                    PickService.instance.allies[index] = value;
                    predicts = await predictGame();
                    setState(() {});
                  });
                },
                onLongTap: () async {
                  PickService.instance.allies[index] = null;
                  predicts = await predictGame();
                  setState(() {});
                },
                brawler: brawler,
                isAlly: true,
              ),
            );
          }),
          ...List.generate(PickService.instance.enemies.length, (index) {
            final brawler = PickService.instance.enemies[index];
            return GestureDetector(
              child: PickedBrawlerCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BrawlerSelectionPage(filterController: PickService.instance.controller),
                    ),
                  ).then((value) async {
                    PickService.instance.enemies[index] = value;
                    predicts = await predictGame();
                    predicts.sort((a, b) => b.$4.compareTo(a.$4));
                    setState(() {});
                  });
                },
                onLongTap: () async {
                  PickService.instance.enemies[index] = null;
                  predicts = await predictGame();
                  predicts.sort((a, b) => b.$4.compareTo(a.$4));
                  setState(() {});
                },
                brawler: brawler,
                isAlly: false,
              ),
            );
          }),
        ],
      ),
    ];

    //ATOMS AI runtime predictions section
    final runtimePredictionsSection = [
      Text("Runtime Predictions").h3(),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 5,
        children: [
          Text("Best 5 brawlers").h4(),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPallete.primary,
              foregroundColor: colorPallete.onPrimary,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PredictionsPage()));
            },
            label: Text("See All"),
            icon: Icon(Icons.table_chart),
          ),
        ],
      ),
      Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 5,
        runSpacing: 5,
        children: [
          ...List.generate(predicts.isNotEmpty ? 5 : 0, (index) {
            final predict = predicts[index];
            return PredictedBrawlerCard(predict: predict);
          }),
        ],
      ),
    ];

    //LAYOUT Map Picker page
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
        children: [Text("Time to pick!").h3(), ...teamPicker, ...runtimePredictionsSection],
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

    //ATOMS Brawler picker
    final brawlerPicker = [
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
              children: [
                ...List.generate(
                  BrawlService.instance.brawlers
                      .where(
                        (b) =>
                            b.$3.toLowerCase().contains(widget.filterController.text.toLowerCase()),
                      )
                      .length,
                  (index) {
                    (String, String, String) brawler = BrawlService.instance.brawlers
                        .where(
                          (b) => b.$3.toLowerCase().contains(
                            widget.filterController.text.toLowerCase(),
                          ),
                        )
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
              ],
            ),
          ],
        ),
      ),
    ];

    //LAYOUT Brawler picker page
    final brawlerPickerPage = Scaffold(
      body: Background(
        padding: EdgeInsets.all(15),
        child: Scroll(
          crossAxisAlignment: CrossAxisAlignment.start,
          scrollDirection: Axis.vertical,
          children: [...filterOptions, ...brawlerPicker],
        ),
      ),
    );

    return Scaffold(appBar: appBar, body: brawlerPickerPage);
  }
}

/// It's the screen where the user will be able to see Ai predictions
///
/// [PickService.instance.selectedMap] The map selected by the user.
/// [PickService.instance.allies] The brawlers of the team.
/// [enemyBrawlers] The brawlers of the enemy team.
class PredictionsPage extends StatefulWidget {
  const PredictionsPage({super.key});
  @override
  State<PredictionsPage> createState() => _PredictionsPageState();
}

class _PredictionsPageState extends State<PredictionsPage> {
  //STATE List of predicts
  /// List of predicts
  List<(String, String, String, double)> predicts = [];

  @override
  void initState() {
    super.initState();
    makePrediction();
  }

  Future<void> makePrediction() async {
    predicts = await predictGame();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //ATOMS AppBar
    final AppBar appBar = AppBar(title: Text("See Predictions"));

    //ATOMS Predicted brawlers (best 5)
    final predictedBrawlerVisuals = [
      //SECTION Top 5
      Text("Top 5 picks").h3(),
      Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 5,
        spacing: 5,
        children: [
          ...List.generate(predicts.isNotEmpty ? 5 : 0, (index) {
            final brawler = predicts[index];
            return PredictedBrawlerCard(predict: brawler);
          }),
        ],
      ),

      //SECTION Total probability table
      Text("Table of Preferences (not winrate!)").h4(),
      SizedBox(
        width: switch (WolkarUtils.instance.screenSize) {
          ScreenSize.small || ScreenSize.regular => double.infinity,
          ScreenSize.large => MediaQuery.sizeOf(context).width * 0.7,
          ScreenSize.xlarge => MediaQuery.sizeOf(context).width * 0.4,
          ScreenSize.xxlarge => MediaQuery.sizeOf(context).width * 0.3,
        },
        child: Table(
          border: TableBorder.all(color: colorPallete.outline),
          children: [
            TableRow(
              decoration: BoxDecoration(color: colorPallete.secondaryFixed),
              children: [
                Center(child: Text("Name").h6()),
                Center(child: Text("Probability").h6()),
              ],
            ),
            ...List.generate(predicts.length, (index) {
              final brawler = predicts[index];
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
      ),
    ];

    //LAYOUT Loading page
    final loadingPage = Background(child: Center(child: CircularProgressIndicator()));

    //LAYOUT Results page
    final predictsPage = Background(
      padding: EdgeInsets.all(15),
      child: Scroll(spacing: 15, children: [...predictedBrawlerVisuals]),
    );

    //LAYOUT Main page
    final page = predicts.isEmpty ? loadingPage : predictsPage;

    //WRAPPER
    return Scaffold(body: page, appBar: appBar);
  }
}
