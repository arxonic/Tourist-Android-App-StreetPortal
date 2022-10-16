import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:street_portal/pages/map_object_screen.dart';
import 'package:street_portal/utils/MapObject.dart';
import 'package:street_portal/utils/constants.dart';

class ExpertSystem extends StatelessWidget {
  const ExpertSystem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            Column(
              children: [
                _Logo(),
                SizedBox(height: 15),
                _RandomPlace(),
                SizedBox(height: 10),
                _ExpertSystemOne(),
                SizedBox(height: 10),
                //_ReverseWithdrawal()
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Не знаешь куда сходить сегодня вечером?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: largeTextSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 1.5,
            color: mainColor.withOpacity(0.2),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Можешь нажать на кнопку ниже и выбрать место случайно или '
                        'пройти небольшой тест, чтобы система подобрала место '
                        'или маршрут по твоему вкусу!',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: secondColor,
                      fontSize: bodyTextSize,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 1.5,
            color: mainColor.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}


class _RandomPlace extends StatefulWidget {
  const _RandomPlace({Key? key}) : super(key: key);

  @override
  _RandomPlaceState createState() => _RandomPlaceState();
}

class _RandomPlaceState extends State<_RandomPlace> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var rng = new Random();
        int r = rng.nextInt(MapObjects.mapObjectList.length);
        MapObject mapObject = MapObjects.mapObjectList.elementAt(r);
        LatLng? result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MapObjectScreen(),
            settings: RouteSettings(
              arguments: mapObject,
              name: "expert_system_call"
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: mainColor,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'Если хочешь отдасться судьбе, нажми на эту кнопку!',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: bodyTextSize,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: mainColor.withOpacity(0.2),
                      width: 1.5,
                    ),
                  )
              ),
              child: Icon(
                Icons.shuffle,
                size: 55,
                color: mainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _ExpertSystemOne extends StatefulWidget {
  const _ExpertSystemOne({Key? key}) : super(key: key);

  @override
  _ExpertSystemOneState createState() => _ExpertSystemOneState();
}

class _ExpertSystemOneState extends State<_ExpertSystemOne> {

  void _goToAnswers() {
    Navigator.pushNamed(context, '/expert_system/answers');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        _goToAnswers();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: mainColor,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'Пройди небольшой тест, чтобы определиться с местом!',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: bodyTextSize,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: mainColor.withOpacity(0.2),
                      width: 1.5,
                    ),
                  )
              ),
              child: Icon(
                Icons.local_florist,
                size: 55,
                color: mainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReverseWithdrawal extends StatefulWidget {
  const _ReverseWithdrawal({Key? key}) : super(key: key);

  @override
  _ReverseWithdrawalState createState() => _ReverseWithdrawalState();
}

class _ReverseWithdrawalState extends State<_ReverseWithdrawal> {

  void _goToAnswers() {
    Navigator.pushNamed(context, '/expert_system/answers_reverse');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        _goToAnswers();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: mainColor,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'Механизм обратного наивного вывода решения',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: bodyTextSize,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: mainColor.withOpacity(0.2),
                      width: 1.5,
                    ),
                  )
              ),
              child: Icon(
                Icons.repeat,
                size: 55,
                color: mainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


