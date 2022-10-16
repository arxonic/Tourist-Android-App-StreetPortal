import 'package:flutter/material.dart';
import 'package:street_portal/expert_sustem/widget_answer.dart';
import 'package:street_portal/pages/bottom_nav.dart';

import 'package:street_portal/utils/constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Answers extends StatelessWidget {
  const Answers({Key? key}) : super(key: key);


  Widget flowing(AsyncSnapshot<QuerySnapshot> snap){
    Cards cards = Cards();
    Card currentCard = Card(0, 0, "ERROR", "ERROR", "ERROR");

    List<QueryDocumentSnapshot> snapDocs = snap.data!.docs;

    for(int i = 0; i < snapDocs.length; i++){
      int id = snapDocs[i].get("id");
      int qId = snapDocs[i].get("q_id");
      String q = snapDocs[i].get("q_u");
      var map = snapDocs[i].get("fact_solution");
      String type = snapDocs[i].get("type");

      cards.addCard(id, qId, q, map, type);
    }

    int _index = 1;
    for (Card card in cards.cardList){
      if (card.id == _index) {
        currentCard = card;
      }
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: ListViewBuilderWidget(cards: cards, currentCard: currentCard),
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
  const ListViewBuilderWidget({Key? key, required this.cards, required this.currentCard}) : super(key: key);

  final Cards cards;
  final Card currentCard;


  @override
  _ListViewBuilderWidgetState createState() => _ListViewBuilderWidgetState(cards, currentCard);
}

class _ListViewBuilderWidgetState extends State<ListViewBuilderWidget> {
  _ListViewBuilderWidgetState(this.cards, this.currentCard);

  Cards cards;
  Card currentCard;

  void goTo(){
    int pageIndex = 2;
    Navigator.pushNamed(context, '/map');
  }

  void nextFact(k){
    int _index = int.parse(k);
    Card newCard = currentCard;
    for (Card card in cards.cardList) {
      if (card.id == _index) {
        if (card.type.contains("solution")) {
          goTo();
        }else if (card.type.contains("fact")){
          newCard = card;
        }
      }
    }

    setState(() {
      currentCard = newCard;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Text(
          currentCard.qU,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black87,
            fontSize: mediumTextSize,
            fontWeight: FontWeight.w600,
          ),
        ),

          for (var kv in currentCard.factSolution.entries)
          InkWell(
              onTap: () {
                nextFact(kv.key);
              },
              borderRadius: BorderRadius.circular(20.0),
              child: AnswerWidget(title: kv.value)
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