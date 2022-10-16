import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:street_portal/maps/.env.dart';
import 'package:street_portal/maps/directions_model.dart';


class DirectionsRepository{
  static const String _baseURL = 'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    @required LatLng? origin,
    @required LatLng? destination,
  }) async {
    final response = await _dio.get(
      _baseURL,
      queryParameters: {
        'origin': '${origin!.latitude},${origin.longitude}',
        'destination': '${destination!.latitude},${destination.longitude}',
        'key': googleAPIKey,
      }
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> map = response.data;
      if ((map['routes'] as List).isEmpty) return null;
      return Directions.fromMap(response.data);
    }

    return null;
  }

}