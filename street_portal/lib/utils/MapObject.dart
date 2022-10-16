import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapObjects {
  static List<MapObject> mapObjectList = [];

  MapObject addObject(String id, String name, String body, int idCategories, String location,
      String imageURL, LatLng latLng, Color color){
    MapObject mapObject = MapObject(id, name, body, idCategories, location, imageURL, latLng, color);
    mapObjectList.add(mapObject);
    return mapObject;
  }
}

class MapObject {
  late String id;
  late int idCategories;
  late String name, body, location, imageURL;
  late LatLng latLng;
  late Color color;

  MapObject(this.id, this.name, this.body, this.idCategories, this.location,
      this.imageURL, this.latLng, this.color);

}
