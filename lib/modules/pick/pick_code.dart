import 'package:rankify/components/ai_service.dart';
import 'package:rankify/components/brawl_service.dart';
import 'package:rankify/modules/pick/pick_service.dart';
import 'package:rankify/modules/settings/settings_enums.dart';
import 'package:rankify/modules/settings/settings_service.dart';

/// Builds input vector for ai model.
///
/// [map] as the selected map
/// [allies] as all the allies
/// [enemies] as the selected enemies
List<List<List<int>>> buildVector(
  (String, String, String) map,
  List<(String, String, String)?> allies,
  List<(String, String, String)?> enemies,
) {
  // get mappings
  final mapsMapping = AiService.instance.cachedMapsMapping!;
  final brawlersMapping = AiService.instance.cachedBrawlersMapping!;

  // getting ids
  final mapId = int.parse(mapsMapping[map.$1].toString());

  final alliesIds = allies.map((a) {
    final id = int.tryParse(brawlersMapping[a?.$1].toString());
    if (id == null || id == 0) return 0;
    return id;
  }).toList();

  final enemiesIds = enemies.map((e) {
    final id = int.tryParse(brawlersMapping[e?.$1].toString());
    if (id == null || id == 0) return 0;
    return id;
  }).toList();

  // returning tensor
  return [
    [
      [mapId],
    ],
    [alliesIds],
    [enemiesIds],
  ];
}

/// Predicts game depending on selected model
///
/// Returns the result
Future<List<(String, String, String, double)>> predictGame() async {
  switch (SettingsService.instance.model) {
    case Model.v1:
      return await predictV1Game();
    case Model.v2:
      return await predictV2Game();
    case Model.v3:
      return (await predictV3Game()).map((e) => (e.$1, e.$2, e.$3, e.$6)).toList();
  }
}

/// Predicts best brawler on overall
///
/// Returns preferenced brawlers sorted for local team
Future<List<(String, String, String, double)>> predictV1Game() async {
  // extract pick position && extract allies picks
  final List<(String, String, String)?> allies = List.from(PickService.instance.allies);

  // list of results
  final List<(String, String, String, double)> results = [];

  for (final brawler in BrawlService.instance.brawlers) {
    // skip if brawler is already picked
    if (PickService.instance.selectedMap == null ||
        allies.contains(brawler) ||
        PickService.instance.pickPosition == null) {
      continue;
    }

    // adds candidate brawler in position
    allies[PickService.instance.pickPosition!] = brawler;

    // construir vector con el candidato incluido
    final vector = buildVector(
      PickService.instance.selectedMap!,
      allies,
      PickService.instance.enemies,
    );

    // predecir
    final probability = AiService.instance.predict(vector);

    // adding result
    results.add((brawler.$1, brawler.$2, brawler.$3, probability));
  }

  // ordenar de mayor a menor probabilidad
  results.sort((a, b) => b.$4.compareTo(a.$4));

  return results;
}

/// Predicts best brawler depending on v2 calculations
///
/// Returns the list of brawlers with their delta values. Sorted for local team.
Future<List<(String, String, String, double)>> predictV2Game() async {
  // previous checks
  if (PickService.instance.selectedMap == null) return [];

  // list of results
  final List<(String, String, String, double)> results = [];

  // base AI vector to calculate base prob
  final baseVector = buildVector(
    PickService.instance.selectedMap!,
    PickService.instance.allies,
    PickService.instance.enemies.reversed.toList(),
  );

  // base prob
  double baseProb = AiService.instance.predict(baseVector);

  // now, check each brawlers delta
  if (PickService.instance.pickPosition == null) return [];

  for (final brawler in BrawlService.instance.brawlers) {
    // get a copy of values
    final allies = List.of(PickService.instance.allies);

    // skips if player is picked
    if (allies.contains(brawler)) continue;

    allies[PickService.instance.pickPosition!] = brawler;

    final vector = buildVector(
      PickService.instance.selectedMap!,
      allies,
      PickService.instance.enemies.reversed.toList(),
    );

    final prob = AiService.instance.predict(vector);

    // How prob increases / decreases for each brawler
    final delta = prob - baseProb;

    // adding result
    results.add((brawler.$1, brawler.$2, brawler.$3, delta));
  }

  // sorts from higher to lower values
  results.sort((a, b) => b.$4.compareTo(a.$4));

  return results;
}

/// Predicts best brawler depending on v3 calcs
///
/// Returns the list of brawlers with delta values. Sorted for local team
Future<List<(String, String, String, double, double, double)>> predictV3Game() async {
  // results
  List<(String, String, String, double, double, double)> results = [];

  // make previous checks
  if (PickService.instance.selectedMap == null || PickService.instance.pickPosition == null) {
    return [];
  }

  // Gets all brawlers
  List<(String, String, String)> brawlers = switch (SettingsService.instance.v3Optimization) {
    Optimization.few => (await predictV2Game()).take(10).map((e) => (e.$1, e.$2, e.$3)).toList(),
    Optimization.regular =>
      (await predictV2Game()).take(25).map((e) => (e.$1, e.$2, e.$3)).toList(),
    Optimization.personalized =>
      (await predictV2Game())
          .take(SettingsService.instance.v3PersonalizedBrawlers)
          .map((e) => (e.$1, e.$2, e.$3))
          .toList(),
  };

  if (PickService.instance.enemyPickPosition == null) {
    return (await predictV2Game()).map((e) => (e.$1, e.$2, e.$3, 0.0, 0.0, e.$4)).toList();
  }

  // base local
  final baseLocalChance = AiService.instance.predict(
    buildVector(
      PickService.instance.selectedMap!,
      PickService.instance.allies,
      PickService.instance.enemies,
    ),
  );

  // base enemy
  final baseEnemyChance = AiService.instance.predict(
    buildVector(
      PickService.instance.selectedMap!,
      PickService.instance.enemies,
      PickService.instance.allies.reversed.toList(),
    ),
  );

  // check all enemy brawlers
  for (final brawler in brawlers) {
    // Skip if brawler is already picked
    if (PickService.instance.allies.contains(brawler) ||
        PickService.instance.enemies.contains(brawler)) {
      continue;
    }

    // gets allies
    List<(String, String, String)?> allies = List.from(PickService.instance.allies);
    allies[PickService.instance.pickPosition!] = brawler;

    // calculate delta
    var localTeamDelta =
        AiService.instance.predict(
          buildVector(
            PickService.instance.selectedMap!,
            allies,
            PickService.instance.enemies.reversed.toList(),
          ),
        ) -
        baseLocalChance;

    // Define worst chance
    double bestEnemyChance = 0;

    for (final enemyBrawler in BrawlService.instance.brawlers) {
      // Skip if brawler is already picked
      if (allies.contains(enemyBrawler) || PickService.instance.enemies.contains(enemyBrawler)) {
        continue;
      }

      // get all enemies
      List<(String, String, String)?> enemies = List.from(PickService.instance.enemies);
      enemies[PickService.instance.enemyPickPosition!] = enemyBrawler;

      // get chance from enemies pov
      double chance = AiService.instance.predict(
        buildVector(PickService.instance.selectedMap!, enemies, allies.reversed.toList()),
      );

      // define worst chance
      if (chance > bestEnemyChance) {
        bestEnemyChance = chance;
      }
    }

    // Enemy delta
    var enemyTeamDelta = bestEnemyChance - baseEnemyChance;

    // Get score
    var score = localTeamDelta - enemyTeamDelta;

    // add results
    results.add((brawler.$1, brawler.$2, brawler.$3, localTeamDelta, enemyTeamDelta, score));
  }

  // sort results
  results.sort((a, b) => b.$6.compareTo(a.$6));

  // get results
  return results;
}
