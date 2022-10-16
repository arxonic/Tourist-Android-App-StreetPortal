import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const Color mainColor = Color(0xff346635);
const Color secondColor = Color(0xff5F6368);
const Color whiteColor = Colors.white;
const Color errorColor = Colors.red;

const headingTextSize = 20.0;
const bodyTextSize = 16.0;

const buttonTextSize = 18.0;
const errorTextSize = 14.0;

const largeTextSize = 26.0;
const mediumTextSize = 22.0;
const minTextSize = 14.0;

const Map<int, double> markerColorForId = {
  0 : BitmapDescriptor.hueBlue,
  1 : BitmapDescriptor.hueOrange,
  2 : BitmapDescriptor.hueGreen,
};
const Map<int, Color> colorOfCategoriesId = {
  0 : Colors.indigo,
  1 : Colors.orange,
  2 : mainColor,
};