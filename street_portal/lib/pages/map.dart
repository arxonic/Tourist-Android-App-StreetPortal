import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:street_portal/maps/directions_model.dart';
import 'package:street_portal/maps/directions_repository.dart';
import 'package:street_portal/utils/MapObject.dart';
import 'package:street_portal/utils/MapRoute.dart';
import 'package:street_portal/utils/constants.dart';
import 'package:geolocator/geolocator.dart';

import 'map_object_screen.dart';

class Map extends StatelessWidget {
  const Map({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MapObject? _mapObjectFromMapObjectScreen = ModalRoute.of(context)!.settings.arguments as MapObject?;
    if (_mapObjectFromMapObjectScreen != null) print(_mapObjectFromMapObjectScreen.body);
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('map_markers').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: const Icon(
                Icons.error_outline,
                color: errorColor,
                size: 60,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: mainColor,
              ),
            );
          }

          return Stack(
            children: [
              _Map(snapshot: snapshot, mapObjectFromMapObjectScreen: _mapObjectFromMapObjectScreen),
              _Widgets(),
              // _DaggableScrollableSheet(),
            ],
          );

        }
      ),
    );
  }
}


class _Map extends StatefulWidget {
  const _Map({Key? key, required this.snapshot, this.mapObjectFromMapObjectScreen}) : super(key: key);

  final AsyncSnapshot<QuerySnapshot> snapshot;
  final MapObject? mapObjectFromMapObjectScreen;

  @override
  _MapState createState() => _MapState(snapshot, mapObjectFromMapObjectScreen);
}

class _MapState extends State<_Map> {
  _MapState(this.snapshot, this.mapObjectFromMapObjectScreen);

  AsyncSnapshot<QuerySnapshot> snapshot;
  MapObject? mapObjectFromMapObjectScreen;

  bool initMarkersFlag = true;
  bool showRout = false;

  //GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey: );

  late Position currentPosition;

  late GoogleMapController _googleMapController;
  Directions? _toTargetDirection;
  Directions? _customRoutDirection;
  List<Directions> directionsList = [];

  Set<Marker> _markers = Set<Marker>();

  Marker? _target;

  MapObjects mapObjects = MapObjects();
  MapRouts mapRouts = MapRouts();


  static const _initialCameraPosition = CameraPosition(
    target: LatLng(56.151445541473464, 40.38983203506022),
    zoom: 11,
  );

  void locatePosition(bool flag) async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    if (flag){
      LatLng latLatUserPosition = LatLng(position.latitude, position.longitude);

      CameraPosition cameraPosition = CameraPosition(
        target: latLatUserPosition,
        zoom: 15,
      );
      _googleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
  }

  void initMarkers() {
    if (!initMarkersFlag)
      return;
    List<QueryDocumentSnapshot> snapDocs = snapshot.data!.docs;
    for(int i = 0; i < snapDocs.length; i++){
      String type = snapDocs[i].get("type");
      if (type.contains("marker")){
        String id = snapDocs[i].id;
        int idCategories = snapDocs[i].get("id_cat");
        String name = snapDocs[i].get("name");
        String body = snapDocs[i].get("body");
        String location = snapDocs[i].get("location");
        String imageURL = snapDocs[i].get("img_url");
        LatLng latLng = LatLng(snapDocs[i].get("latlng")["latitude"], snapDocs[i].get("latlng")["longitude"]);
        Color color;
        if (colorOfCategoriesId[idCategories] == null)
          color = mainColor;
        else
          color = colorOfCategoriesId[idCategories] as Color;

        MapObject mapObject = mapObjects.addObject(id, name, body, idCategories,
            location, imageURL, latLng, color);

        Marker marker;
        double? mc = markerColorForId[idCategories];
        if (mc != null){
          marker = Marker(
              markerId: MarkerId(id),
              icon: BitmapDescriptor.defaultMarkerWithHue(mc),
              position: latLng,
              onTap: () async {
                LatLng? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MapObjectScreen(),
                    settings: RouteSettings(
                      arguments: mapObject,
                    ),
                  ),
                );
                if (result != null) addMarker(result);
              }
          );
          _markers.add(marker);
        }
      }else if (type.contains("route")){
        String id = snapDocs[i].id;
        int idCategories = snapDocs[i].get("id_cat");
        String name = snapDocs[i].get("name");
        String body = snapDocs[i].get("body");
        var pointsArray = snapDocs[i].get("points");

        List<LatLng> latLngArray = [];
        for(var point in pointsArray){
          LatLng latLng = LatLng(point["latitude"], point["longitude"]);
          latLngArray.add(latLng);
        }

        Color color;
        if (colorOfCategoriesId[idCategories] == null)
          color = mainColor;
        else
          color = colorOfCategoriesId[idCategories] as Color;

        MapRout mapRout = mapRouts.addRouts(id, name, body, idCategories, latLngArray, color);
      }
    }
  }

  getOnlyOneCatMarkers(int catId){
    setState(() {
      _markers.clear();
      initMarkersFlag = false;
      for(MapObject mo in MapObjects.mapObjectList){
        if (mo.idCategories != catId)
          continue;
        Marker marker;
        double? mc = markerColorForId[mo.idCategories];
        if (mc != null){
          marker = Marker(
              markerId: MarkerId(mo.id),
              icon: BitmapDescriptor.defaultMarkerWithHue(mc),
              position: mo.latLng,
              onTap: () async {
                // Navigator.pushNamed(context, '/map/map_object', arguments: mapObject);
                // LatLng? result = await Navigator.pushNamed(context, '/map/map_object', arguments: mapObject);
                LatLng? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MapObjectScreen(),
                    settings: RouteSettings(
                      arguments: mo,
                    ),
                  ),
                );
                if (result != null) addMarker(result);
              }
          );
          _markers.add(marker);
        }
      }
    });
  }

  getOnlyOneRout(String idRoute) async {
    LatLng latLatUserPosition = LatLng(currentPosition.latitude, currentPosition.longitude);
    for (MapRout mp in mapRouts.mapRoutsList){
      if (mp.id.contains(idRoute)){
        LatLng previos = latLatUserPosition;

        for (LatLng latLng in mp.latLngArray){
          final directions = await DirectionsRepository().getDirections(
              origin: previos,
              destination: latLng
          );
          if (directions != null)
            directionsList.add(directions);
          previos = latLng;
        }
        break;
      }
    }
    setState(() {
      showRout = true;
    });
  }

  @override
  void dispose(){
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();

    locatePosition(false);

    if (mapObjectFromMapObjectScreen != null)
      addMarker(mapObjectFromMapObjectScreen!.latLng);
  }

  @override
  Widget build(BuildContext context) {
    if (initMarkersFlag)
      initMarkers();
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            mapToolbarEnabled: false,
            compassEnabled: false,
            myLocationButtonEnabled: false,

            myLocationEnabled: true,
            mapType: MapType.normal,

            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,

            markers: _markers,
            onLongPress: addMarker,

            onMapCreated: (controller) {
              _googleMapController = controller;
              initState();
            },

            polylines: {
              if (_toTargetDirection != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: errorColor,
                  width: 5,
                  points: _toTargetDirection!.polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList(),
                ),
              if(showRout)
                for (Directions direct in directionsList)
                  Polyline(
                    polylineId: PolylineId(direct.hashCode.toString()),
                    color: mainColor,
                    width: 5,
                    points: direct.polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList(),
                  )
            },
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.05,
            minChildSize: 0.05,
            maxChildSize: 0.5,
            builder: (context, scrollController){
              return ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  color: whiteColor,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    controller: scrollController,
                    children: [
                      Center(
                        child: Container(
                          height: 1.5,
                          width: 50,
                          margin: EdgeInsets.symmetric(vertical: 16),
                          color: mainColor,
                        ),
                      ),
                      Text(
                        "Места:",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: headingTextSize,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: (){
                          setState(() {
                            initMarkersFlag = true;
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: mainColor,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            "Все места города",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: bodyTextSize,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: (){
                          getOnlyOneCatMarkers(1);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: secondColor.withOpacity(0.9),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            "Кафе и рестораны",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: secondColor,
                              fontSize: bodyTextSize,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: (){
                          getOnlyOneCatMarkers(2);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: secondColor.withOpacity(0.9),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            "Парки и скверы",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: secondColor,
                              fontSize: bodyTextSize,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: (){
                          getOnlyOneCatMarkers(0);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: secondColor.withOpacity(0.9),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            "Храмы и музеи",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: secondColor,
                              fontSize: bodyTextSize,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Маршруты:",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: headingTextSize,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: (){
                          if (!showRout)
                            getOnlyOneRout("UvzGX57kps2IrGMgocIY");
                          else
                            setState(() {
                              directionsList.clear();
                              showRout = false;
                            });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: secondColor.withOpacity(0.9),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            "Бестселлер",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: secondColor,
                              fontSize: bodyTextSize,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),



                    ],
                  ),
                ),
              );
            },
          )
          //_DaggableScrollableSheet(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 13),
        height: 50.0,
        width: 50.0,
        child: FloatingActionButton(
          backgroundColor: whiteColor,
          foregroundColor: secondColor,
          child: const Icon(Icons.center_focus_strong),
          onPressed: () {
            if (_toTargetDirection == null){
              locatePosition(true);
            }else{
              _googleMapController.animateCamera(CameraUpdate.newLatLngBounds(_toTargetDirection!.bounds, 100));
            }
          }
        ),
      ),
    );
  }

  void addMarker(LatLng pos) async {
    print("AAAAAAAAA");
    print(pos);
    if (_target == null) {
      locatePosition(false);
      LatLng latLatUserPosition = LatLng(currentPosition.latitude, currentPosition.longitude);
      setState(() {
        _target = Marker(
          markerId: const MarkerId("toTargetDirection"),
          infoWindow: const InfoWindow(title: "Цель"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: pos,
        );
      });
      _markers.add(_target!);
      // Get directions
      final directions = await DirectionsRepository().getDirections(
          origin: latLatUserPosition,
          destination: pos
      );
      print("AAAAAAAAAB");
      print(latLatUserPosition);
      setState(() => _toTargetDirection = directions);
    }else{
      print("ABCD");
      setState(() {
        _markers.remove(_target);
        _target = null;
        _toTargetDirection = null;
      });
    }
    /*if (_origin == null || (_origin != null && _destination != null)){
      setState(() {
        _origin = Marker(
          markerId: const MarkerId("origin"),
          infoWindow: const InfoWindow(title: "Origin"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );

        _destination = null;

        _info = null;
      });
    }else{
      setState(() {
        _destination = Marker(
          markerId: const MarkerId("destination"),
          infoWindow: const InfoWindow(title: "Destination"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: pos,
        );
      });

      // Get directions
      final directions = await DirectionsRepository().getDirections(
        origin: _origin!.position,
        destination: pos
      );
      setState(() => _info = directions);
    }*/
  }
}


class _Widgets extends StatefulWidget {
  const _Widgets({Key? key}) : super(key: key);

  @override
  _WidgetsState createState() => _WidgetsState();
}

class _WidgetsState extends State<_Widgets> {
  TextEditingController _findController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 77, 0),
              child: TextField(
                style: TextStyle(fontSize: bodyTextSize, color: secondColor),
                controller: _findController,

                inputFormatters: [
                  LengthLimitingTextInputFormatter(1024)
                ],
                cursorColor: mainColor,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: 'Поиск',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: secondColor, width: 1),
                    borderRadius: BorderRadius.circular(40)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: mainColor, width: 2),
                      borderRadius: BorderRadius.circular(40)
                  ),
                ),
              ),
            ),
          ),
          /*Container(
            padding: EdgeInsets.fromLTRB(8, 16, 16, 0),
            child: ElevatedButton(
              child: const Icon(Icons.filter_alt_outlined),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12)),
                backgroundColor: MaterialStateProperty.all(mainColor),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: BorderSide(color: mainColor)
                  )
                )
              ),
              onPressed: () {

              },
            ),
          ),*/
        ],
      ),
    );
  }
}

class _DaggableScrollableSheet extends StatefulWidget {
  const _DaggableScrollableSheet({Key? key}) : super(key: key);

  @override
  _DaggableScrollableSheetState createState() => _DaggableScrollableSheetState();
}

class _DaggableScrollableSheetState extends State<_DaggableScrollableSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.1,
        maxChildSize: 0.8,
        builder: (context, scrollController){
          return ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              color: whiteColor,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      height: 1.5,
                      width: 30,
                      margin: EdgeInsets.only(bottom: 10),
                      color: mainColor.withOpacity(0.2),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      print("A");
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: secondColor,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        "Все места города",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: bodyTextSize,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
    );
  }
}
