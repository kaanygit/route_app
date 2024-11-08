import 'dart:math';

Map<int, Map<String, double>> placeCoordinates = {
  1: {'lat': 37.8703256, 'lng': 32.4834427},
  2: {'lat': 37.8713441, 'lng': 32.4835781},
  3: {'lat': 37.8702072, 'lng': 32.4852269},
  4: {'lat': 37.8728716, 'lng': 32.4899749},
  5: {'lat': 37.8733208, 'lng': 32.4865003},
  6: {'lat': 37.8733455, 'lng': 32.4903165},
  7: {'lat': 37.8748698, 'lng': 32.4903845},
  8: {'lat': 37.8736757, 'lng': 32.4929848},
  9: {'lat': 37.8727992, 'lng': 32.496168},
  10: {'lat': 37.8718669, 'lng': 32.4941504},
  11: {'lat': 37.8716169, 'lng': 32.4958189},
  12: {'lat': 37.871199, 'lng': 32.4968397},
  13: {'lat': 37.8699614, 'lng': 32.4950449},
  14: {'lat': 37.8705172, 'lng': 32.4859661},
  15: {'lat': 37.8709511, 'lng': 32.5035289},
  16: {'lat': 37.872438, 'lng': 32.494374},
  17: {'lat': 37.870768, 'lng': 32.492141},
  18: {'lat': 37.870913, 'lng': 32.490837},
  19: {'lat': 37.870913, 'lng': 32.490837},
  20: {'lat': 37.872403, 'lng': 32.494151},
  21: {'lat': 37.870925, 'lng': 32.492724},
  22: {'lat': 37.870937, 'lng': 32.490715},
  23: {'lat': 37.870937, 'lng': 32.490715},
  24: {'lat': 37.870937, 'lng': 32.490715},
  25: {'lat': 37.870937, 'lng': 32.490715},
  26: {'lat': 37.872476, 'lng': 32.494136},
  27: {'lat': 37.872476, 'lng': 32.494136},
  28: {'lat': 37.872708, 'lng': 32.494243},
};

Map<int, List<int>> placesGraph = {
  1: [10, 3, 5, 4, 2],
  2: [1, 5, 4, 3],
  3: [1, 10, 5, 4],
  4: [1, 3],
  5: [1, 2, 3],
  10: [1, 3]
};

Map<int, List<List<int>>> possibleRoutes = {
  1: [
    [10, 16, 17, 3, 1],
    [5, 4, 18, 3, 1],
    [2, 1]
  ],
  2: [
    [1, 2],
    [5, 4, 19, 3, 2]
  ],
  3: [
    [1, 3],
    [10, 20, 21, 22, 3], //7
    [5, 4, 23, 3] //8
  ],
  4: [
    [1, 3, 24, 4], //9
  ],
  5: [
    [1, 3, 25, 4, 5] //10
  ],
  6: [
    [10, 26, 6], //11
    [5, 4, 6] //12
  ],
  7: [
    [10, 27, 7], //13
  ],
  8: [
    [11, 9, 8], //14
    [10, 9, 8] //15
  ],
  9: [
    [11, 9], //16
    [10, 9], //17
    [8, 9], //18boş
  ],
  10: [
    [15, 14, 13, 12, 11, 10], //19
    [7, 28, 10], //20
    [5, 4, 6, 10], //21
    [8, 9, 10], //22
  ],
  11: [
    [13, 12, 11], //23
    [10, 11], //24
    [8, 9, 11]
  ],
  12: [
    [15, 14, 13, 12], //26
    [10, 11, 12], //27
  ],
  13: [
    [10, 11, 12, 13], //28
    [15, 14, 13], //29
  ],
  14: [
    [15, 14], //30
    [13, 14] //31
  ],
  15: [
    [14, 15], //32
    [13, 14, 15] //33
  ]
};

double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
  const R = 6371;
  double dLat = (lat2 - lat1) * pi / 180.0;
  double dLng = (lng2 - lng1) * pi / 180.0;

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1 * pi / 180) *
          cos(lat2 * pi / 180) *
          sin(dLng / 2) *
          sin(dLng / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = R * c;
  return distance;
}

List<int> findShortestRoute(int target) {
  List<List<int>> routes = possibleRoutes[target] ?? [];
  double minDistance = double.infinity;
  List<int> shortestRoute = [];

  for (var route in routes) {
    double totalDistance = 0.0;

    for (int i = 0; i < route.length - 1; i++) {
      int start = route[i];
      int end = route[i + 1];

      totalDistance += calculateDistance(
        placeCoordinates[start]!['lat']!,
        placeCoordinates[start]!['lng']!,
        placeCoordinates[end]!['lat']!,
        placeCoordinates[end]!['lng']!,
      );
    }

    if (totalDistance < minDistance) {
      minDistance = totalDistance;
      shortestRoute = route;
    }
  }
  print("EN KISA YOL $shortestRoute");
  return shortestRoute;
}
