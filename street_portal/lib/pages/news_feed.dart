import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:street_portal/utils/constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class NewsFeed extends StatelessWidget {
  const NewsFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('Новости',
          style: TextStyle(
            fontSize: mediumTextSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          //SelectCity()
          TextButton(
            style: TextButton.styleFrom(
              primary: whiteColor,
              padding: EdgeInsets.symmetric(horizontal: 20),
              textStyle: TextStyle(fontSize: buttonTextSize),
            ),
            onPressed: () {},
            child: Text('Владимир'),
          ),
        ],
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('news').orderBy("event_date", descending: true).snapshots(),
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

          return Center(
            child: ListViewBuilderWidget(cont: context, snap: snapshot),
          );

        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/newsfeed/add_news');
        },

        child: const Icon(Icons.add),
        backgroundColor: mainColor,
      ),

    );
  }

}

class ListViewBuilderWidget extends StatelessWidget {
  const ListViewBuilderWidget({Key? key, required this.cont, required this.snap}) : super(key: key);

  final BuildContext cont;
  final AsyncSnapshot<QuerySnapshot> snap;

  @override
  Widget build(BuildContext context) {

    Cards cards = Cards();

    for(int i = 0; i < snap.data!.docs.length; i++){
      String heading = snap.data!.docs[i].get("heading");
      String body = snap.data!.docs[i].get("body");

      print(snap.data!.docs[i].get("event_date").seconds);
      DateTime eventDate = DateTime.fromMillisecondsSinceEpoch(snap.data!.docs[i].get("event_date").seconds * 1000);
      String eventPlace = snap.data!.docs[i].get("event_place");

      DateTime publicationDate = DateTime.fromMillisecondsSinceEpoch(snap.data!.docs[i].get("publication_date").seconds * 1000);
      String publisherName = snap.data!.docs[i].get("publisher_name");

      List<String> tags = snap.data!.docs[i].get("tags").toString().split(",");

      String imageURL = snap.data!.docs[i].get("image_url");

      cards.addCard(heading, body, eventDate, eventPlace, publicationDate, publisherName, tags, imageURL);
    }

    return ListView.builder(
      itemCount: cards.CardList.length,
      itemBuilder: (context, index) {
        print(cards.CardList.length);
        return CardWidget(cardID: index, cards: cards);
      }
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({Key? key, required this.cardID, required this.cards}) : super(key: key);

  final int cardID;
  final Cards cards;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),

      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: mainColor.withOpacity(0.2),
                width: 1.5,
              ),
            )
        ),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      cards.CardList[cardID].heading,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: headingTextSize, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            /*Row(
              children: [
                ListViewBuilderTags(
                  cardID: cardID,
                )
              ],
            ),*/
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      cards.CardList[cardID].body,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: bodyTextSize, color: secondColor),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Когда: ',
                    maxLines: 1,
                    style: TextStyle(fontSize: bodyTextSize, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      Cards.beautifulEventDate(cardID, cards),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: bodyTextSize, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Text(
                    'Где: ',
                    maxLines: 1,
                    style: TextStyle(fontSize: bodyTextSize, fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Text(
                      cards.CardList[cardID].eventPlace,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: bodyTextSize, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ],
            ),
            newsImage(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      cards.CardList[cardID].publisherName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: minTextSize, color: secondColor),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      Cards.beautifulDate(cardID, cards),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: minTextSize, color: secondColor),
                    ),
                  ),
                ),
              ],
            )

          ],
        ),
      )
    );
  }

  newsImage() {
    Widget widget = Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: cards.CardList[cardID].imageURL,
              placeholder: (context, url) => CircularProgressIndicator(
                color: mainColor,
              ),
              errorWidget: (context, url, error) => Image.asset('assets/news_error_image.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

    return widget;
  }
}

/*class ListViewBuilderTags extends StatelessWidget {
  const ListViewBuilderTags({Key? key, required this.cardID}) : super(key: key);

  final int cardID;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 5),
      itemCount: Cards.CardList[cardID].tags.length,
      itemBuilder: (context, index) {
        return Container(
          child: Center(child: Text(Cards.CardList[cardID].tags[index])),
        );


        // return TagWidget(cardID: cardID, tagID: index);
      }
    );
  }
}

class TagWidget extends StatelessWidget {
  const TagWidget({Key? key, required this.cardID, required this.tagID}) : super(key: key);

  final int cardID;
  final int tagID;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12, width: 1)
      ),

      child: Text(
        Cards.CardList[cardID].tags[tagID],
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}*/




class Cards {
  List<Card> CardList = [];

  addCard(String heading, String body, DateTime eventDate, String eventPlace,
      DateTime publicationDate, String publisherName, List<String> tags, String imageURL){
    CardList.add(Card(heading, body, eventDate, eventPlace, publicationDate, publisherName, tags, imageURL));
  }

  static beautifulDate(cardID, Cards cards){
    String fS = cards.CardList[cardID].publicationDate.day.toString()
    + "-" + cards.CardList[cardID].publicationDate.month.toString()
    + "-" + cards.CardList[cardID].publicationDate.year.toString();
    return fS;
  }

  static beautifulEventDate(cardID, Cards cards){
    String month = _takeMonthAbbr(cards.CardList[cardID].eventDate.month);
    String fS = cards.CardList[cardID].eventDate.day.toString()
        + " " + month
        + " " + cards.CardList[cardID].eventDate.year.toString()
        + " в " + cards.CardList[cardID].eventDate.hour.toString()
        + ":" + cards.CardList[cardID].eventDate.minute.toString();
    return fS;
  }

  static String _takeMonthAbbr(int month) {
    List <String> months = ['января', 'февраля', 'марта', 'апреля', 'мая',
      'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
    return months[month-1];
  }


}

class Card {
  late String heading, body, eventPlace, publisherName, imageURL;
  late DateTime eventDate, publicationDate;
  List<String> tags = [];

  Card(this.heading, this.body, this.eventDate, this.eventPlace,
      this.publicationDate, this.publisherName, this.tags, this.imageURL);

}
