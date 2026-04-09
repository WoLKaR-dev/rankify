import 'package:rankify/components/ai_service.dart';
import 'package:rankify/components/brawl_service.dart';

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

/// Predice el mejor brawler para la posición de aliado que falta.
///
/// [selectedMap] mapa elegido.
/// [pickedBrawlers] lista de 6 slots (0-2 aliados, 3-5 enemigos).
/// El slot que quieras completar debe estar en null dentro de 0-2.
Future<List<(String, String, String, double)>> predictGame(
  (String, String, String) selectedMap,
  List<(String, String, String)?> pickedBrawlers,
) async {
  // extract enemies
  List<(String, String, String)?> enemies = [];
  for (int position = 3; position <= 5; position++) {
    enemies.add(pickedBrawlers[position]);
  }

  // extract pick position && extract allies picks
  int? pickPosition;
  for (int position = 0; position <= 2; position++) {
    if (pickedBrawlers[position] == null) {
      pickPosition = position;
      break;
    }
  }
  if (pickPosition == null) return [];
  List<(String, String, String)?> allies = [];
  for (int position = 0; position <= 2; position++) {
    allies.add(pickedBrawlers[position]);
  }

  // defining prediction list
  final List<(String, String, String, double)> predictions = [];

  for (final brawler in BrawlService.instance.brawlers) {
    if (pickedBrawlers.contains(brawler)) continue; 

    // adds candidate brawler in position
    allies[pickPosition] = brawler;

    // construir vector con el candidato incluido
    final vector = buildVector(selectedMap, allies, enemies);

    // predecir
    final probability = AiService.instance.predict(vector);

    // adding result
    predictions.add((brawler.$1, brawler.$2, brawler.$3, probability));
  }

  // ordenar de mayor a menor probabilidad
  predictions.sort((a, b) => b.$4.compareTo(a.$4));

  return predictions;
}
