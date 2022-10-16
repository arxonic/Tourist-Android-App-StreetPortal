import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapRouts {
  List<MapRout> mapRoutsList = [];

  MapRout addRouts(String id, String name, String body, int idCategories, List<LatLng> latLngArray, Color color){
    MapRout mapRout = MapRout(id, name, body, idCategories, latLngArray, color);
    mapRoutsList.add(mapRout);
    return mapRout;
  }
}

class MapRout {
  late String id;
  late int idCategories;
  late String name, body;
  late Color color;
  late List<LatLng> latLngArray;

  MapRout(this.id, this.name, this.body, this.idCategories, this.latLngArray, this.color);
}
