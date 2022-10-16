import 'package:flutter/material.dart';

import 'package:street_portal/utils/constants.dart';

import 'package:street_portal/pages/news_feed.dart';
//import 'package:street_portal/pages/categories.dart';
import 'package:street_portal/pages/map.dart';
import 'package:street_portal/pages/expert_system.dart';
import 'package:street_portal/pages/account.dart';


class BottomNav extends StatefulWidget {
  const BottomNav({Key? key, required this.pageIndex}) : super(key: key);

  final int pageIndex;

  @override
  _BottomNavState createState() => _BottomNavState(pageIndex);
}

class _BottomNavState extends State<BottomNav> {
  _BottomNavState(this._pageIndex);

  int _pageIndex;

  static List<Widget> _pages = <Widget>[
    NewsFeed(),
    //Categories(),
    Map(),
    ExpertSystem(),
    Account(),
  ];

  void _onPage(int index){
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      var arg = ModalRoute
          .of(context)!
          .settings
          .arguments as int;
      _pageIndex = arg;
    }catch(e){
      print(e);
    }

    return Scaffold(

      body: IndexedStack(
        index: _pageIndex,
        children: _pages,
      ),
        /*body: Center(
          child: _pages.elementAt(_pageIndex),
        ),*/

        bottomNavigationBar: BottomNavigationBar(
          //showSelectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.wysiwyg),
              label: 'Новости',
            ),
            /*BottomNavigationBarItem(
              icon: Icon(Icons.widgets_outlined),
              label: 'Категории',
            ),*/
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              label: 'Карта',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.swap_calls),
              label: 'Найти',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box_outlined),
              label: 'Аккаунт',
            ),
          ],
          selectedItemColor: mainColor,
          unselectedItemColor: secondColor,
          currentIndex: _pageIndex,
          onTap: _onPage,
        ),
      );
  }

}
