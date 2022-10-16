import 'package:flutter/material.dart';
import 'package:street_portal/expert_sustem/widget_answer.dart';

import 'package:street_portal/utils/constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AnswersReverse extends StatelessWidget {
  const AnswersReverse({Key? key}) : super(key: key);


  Widget flowing(AsyncSnapshot<QuerySnapshot> snap){
    Cards cards = Cards();

    List<QueryDocumentSnapshot> snapDocs = snap.data!.docs;

    for(int i = 0; i < snapDocs.length; i++){
      int id = snapDocs[i].get("id");
      int qId = snapDocs[i].get("q_id");
      String q = snapDocs[i].get("q_u");
      var map = snapDocs[i].get("fact_solution");
      String type = snapDocs[i].get("type");

      cards.addCard(id, qId, q, map, type);
    }

    var first = <Card>[];
    for (Card card in cards.cardList){
      if (card.type.contains("solution")) {
        first.add(card);
      }
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: ListViewBuilderWidget(cards: cards, currentCards: first),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('facts_solutions').snapshots(),
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

                return flowing(snapshot);

              },
            ),
          ],
        ),
      ),
    );
  }
}

class ListViewBuilderWidget extends StatefulWidget {
  const ListViewBuilderWidget({Key? key, required this.cards, required this.currentCards}) : super(key: key);

  final Cards cards;
  final List currentCards;


  @override
  _ListViewBuilderWidgetState createState() => _ListViewBuilderWidgetState(cards, currentCards);
}

class _ListViewBuilderWidgetState extends State<ListViewBuilderWidget> {
  _ListViewBuilderWidgetState(this.cards, this.currentCards);

  Cards cards;
  List currentCards;

  void nextFact(id){
    int _index = id;

    List newCards = <Card>[];
    for (Card card in cards.cardList)
      for (var kv in card.factSolution.entries){
        if (int.parse(kv.key) == _index && card.type.contains("fact")){
          newCards.add(card);
        }
      }

    setState(() {
      currentCards = newCards;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Text(
          "Выберите",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black87,
            fontSize: mediumTextSize,
            fontWeight: FontWeight.w600,
          ),
        ),

        for (int i = 0; i < currentCards.length; i++)
          InkWell(
              onTap: () {
                nextFact(currentCards.elementAt(i).id);
              },
              borderRadius: BorderRadius.circular(20.0),
              child: AnswerWidget(title: currentCards.elementAt(i).qU)
          ),


      ],
    );
  }
}


class Cards {
  List<Card> cardList = [];

  addCard(int id, int qId, String qU, var factSolution, String type){
    cardList.add(Card(id, qId, qU, factSolution, type));
  }
}

class Card {
  int id;
  int qId;
  String qU;
  var factSolution;
  String type;

  Card(this.id, this.qId, this.qU, this.factSolution, this.type);

}