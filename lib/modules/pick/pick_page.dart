import 'package:flutter/material.dart';
import 'package:rankify/components/brawl_service.dart';
import 'package:rankify/core/theme.dart';
import 'package:rankify/modules/pick/pick_code.dart';
import 'package:rankify/modules/pick/pick_styles.dart';
import 'package:wolkarutils/wolkarutils.dart';

class PickPage extends StatefulWidget {
  const PickPage({super.key});
  @override
  State<PickPage> createState() => _PickPageState();
}

class _PickPageState extends State<PickPage> {
  //FORM Searching brawler
  /// Controller that contains the text to filter maps and brawler
  final TextEditingController filterController = TextEditingController();

  //STATE List of predicts
  /// List of predicts
  List<(String, String, String, double)> predicts = [];

  //STATE Pick phase
  /// Represents picking phases. `0` when selecting maps, `1` when picking brawlers.
  int phase = 0;

  //STATE Picked brawlers
  /// A list of picked brawlers, where the position `0` is ally1 and `5` is enemy3.
  List<(String, String, String)?> pickedBrawlers = List.generate(6, (index) => null);

  //STATE Picked map
  /// Picked map of phase 0.
  (String, String, String)? pickedMap;

  //STATE Selected slot
  /// Player selected slot. `0` = Ally1, ..., `5` = Enemy3
  int selectedSlot = 0;

  //LOGIC Advance from phase
  /// Advance the current phase ensuring that the required information was
  /// submitted.
  void advancePhase() async {
    if (phase == 0) {
      if (pickedMap != null) {
        setState(() {
          phase = 1;
          filterController.text = "";
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Enter your allies and enemies picks! ").h6()));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Select a map to advance to next phase").h6()));
      }
    } else if (phase == 1) {
      List<(String, String, String, double)> predictions = await predictGame(
        pickedMap!,
        pickedBrawlers,
      );
      setState(() {
        phase = 2;
        predicts = predictions;
        predicts.sort((brawler1, brawler2) => brawler2.$4.compareTo(brawler1.$4));
      });
    } else {
      setState(() {
        phase = 0;
        predicts = [];
        pickedMap = null;
        pickedBrawlers = List.generate(6, (index) => null);
        filterController.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //ATOMS FAb
    final fab = FloatingActionButton.extended(
      onPressed: advancePhase,
      label: Text(phase == 1 ? "My Turn!" : "Next phase").p(),
      icon: Icon(phase == 1 ? Icons.play_arrow_rounded : Icons.arrow_forward),
    );

    //ATOMS Filter options
    final filterOptions = [
      Row(
        children: [
          Input(
            controller: filterController,
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
        height: 600,
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
                        (b) => b.$3.toLowerCase().contains(filterController.text.toLowerCase()),
                      )
                      .length,
                  (index) {
                    (String, String, String) brawler = BrawlService.instance.brawlers
                        .where(
                          (b) => b.$3.toLowerCase().contains(filterController.text.toLowerCase()),
                        )
                        .toList()[index];
                    return PickableCard(
                      available: !pickedBrawlers.contains(brawler),
                      brawlerRecord: brawler,
                      onTap: () {
                        setState(() {
                          pickedBrawlers[selectedSlot] = brawler;
                        });
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

    //ATOMS Map Picker
    final mapPicker = [
      SizedBox(
        height: 700,
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
                        (m) => m.$3.toLowerCase().contains(filterController.text.toLowerCase()),
                      )
                      .toList()
                      .length,
                  (index) {
                    (String id, String image, String name) map = BrawlService.instance.maps
                        .where(
                          (m) => m.$3.toLowerCase().contains(filterController.text.toLowerCase()),
                        )
                        .toList()[index];
                    return MapPickableCard(
                      map: map,
                      selected: pickedMap == map,
                      onTap: () {
                        setState(() {
                          pickedMap = map;
                        });
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
        spacing: 5,
        children: [
          ...List.generate(pickedBrawlers.length, (index) {
            final brawler = pickedBrawlers[index];
            return GestureDetector(
              child: PickedBrawlerCard(
                onTap: () {
                  setState(() {
                    selectedSlot = index;
                  });
                },
                onLongTap: () {
                  setState(() {
                    pickedBrawlers[index] = null;
                  });
                },
                brawler: brawler,
                selected: selectedSlot == index,
                isAlly: index <= 2,
              ),
            );
          }),
        ],
      ),
    ];

    //ATOMS Predicted brawlers (best 5)
    final predictedBrawlerVisuals = [
      //SECTION Top 5
      Text("Top 5 picks").h3(),
      SizedBox(
        height: 200,
        child: Scroll(
          scrollDirection: Axis.horizontal,
          children: [
            GridView.count(
              crossAxisCount: 1,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                ...List.generate(predicts.isNotEmpty ? 5 : 0, (index) {
                  final brawler = predicts[index];
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.network(brawler.$2),
                  );
                }),
              ],
            ),
          ],
        ),
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
                ],
              );
            }),
          ],
        ),
      ),
    ];

    //LAYOUT Main page
    final brawlerPickerPage = Background(
      padding: EdgeInsets.all(15),
      child: Scroll(
        crossAxisAlignment: CrossAxisAlignment.start,
        scrollDirection: Axis.vertical,
        children: [...filterOptions, ...brawlerPicker, ...teamPicker],
      ),
    );

    //LAYOUT Map Picker page
    final mapPickerPage = Background(
      padding: EdgeInsets.all(15),
      child: Scroll(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [...filterOptions, ...mapPicker],
      ),
    );

    //LAYOUT Results page
    final predictsPage = Background(
      padding: EdgeInsets.all(15),
      child: Scroll(spacing: 15, children: [...predictedBrawlerVisuals]),
    );

    //LAYOUT Main page
    final page = switch (phase) {
      0 => mapPickerPage,
      1 => brawlerPickerPage,
      2 => predictsPage,
      _ => predictsPage,
    };

    //WRAPPER Brawler wrapper
    return Scaffold(body: page, floatingActionButton: fab);
  }
}
