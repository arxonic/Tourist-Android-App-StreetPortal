import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:street_portal/utils/MapObject.dart';
import 'package:street_portal/utils/constants.dart';

class MapObjectScreen extends StatelessWidget {
  const MapObjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapObject = ModalRoute.of(context)!.settings.arguments as MapObject;
    final String? str = ModalRoute.of(context)!.settings.name;
    return Scaffold(
      appBar: AppBar(
        shadowColor: null,
        foregroundColor: whiteColor,
        backgroundColor: mapObject.color,
        centerTitle: true,
        title: Text(mapObject.name,
          style: TextStyle(
            fontSize: mediumTextSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            _Image(mapObject),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Logo(mapObject),
                  SizedBox(height: 10),
                  _Body(mapObject),
                  SizedBox(height: 10),
                  _Location(mapObject),
                  SizedBox(height: 10),
                  _BuildDirection(mapObject, str),
                  SizedBox(height: 10),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image(this.mapObject, {Key? key}) : super(key: key);

  final MapObject mapObject;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: CachedNetworkImage(
          imageUrl: mapObject.imageURL,
          placeholder: (context, url) => CircularProgressIndicator(
            color: mainColor,
          ),
          errorWidget: (context, url, error) => Image.asset('assets/news_error_image.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo(this.mapObject, {Key? key}) : super(key: key);

  final MapObject mapObject;

  @override
  Widget build(BuildContext context) {
    return Text(
      mapObject.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.black87,
        fontSize: mediumTextSize,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.mapObject, {Key? key}) : super(key: key);

  final MapObject mapObject;

  @override
  Widget build(BuildContext context) {
    return Text(
      mapObject.body,
      textAlign: TextAlign.justify,
      style: TextStyle(
        color: Colors.black87,
        fontSize: bodyTextSize,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}

class _Location extends StatelessWidget {
  const _Location(this.mapObject, {Key? key}) : super(key: key);

  final MapObject mapObject;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 40,
          color: mapObject.color,
        ),
        SizedBox(width: 10),
        Flexible(
          child: Text(
            mapObject.location,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black87,
              fontSize: bodyTextSize,
              fontWeight: FontWeight.normal,
            ),
          ),
        )
      ],
    );
  }
}

class _BuildDirection extends StatelessWidget {
  const _BuildDirection(this.mapObject, this.name, {Key? key}) : super(key: key);

  final MapObject mapObject;
  final String? name;

  @override
  Widget build(BuildContext context) {
    if (name == null)
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: buttonTextSize),
                primary: mapObject.color,
              ),
              onPressed: () {
                Navigator.pop(context, mapObject.latLng);
              },
              child: Text("Построить маршрут"),
            ),
          ),
        ],
      );
    else return SizedBox();/*Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: buttonTextSize),
              primary: mapObject.color,
            ),
            onPressed: () {
              Navigator.pushNamed(
                  context,
                  '/map',
                  arguments: mapObject,
              );

            },
            child: Text("Построить маршрут"),
          ),
        ),
      ],
    );*/
  }
}

