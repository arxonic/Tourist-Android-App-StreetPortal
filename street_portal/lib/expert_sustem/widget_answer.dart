import 'package:flutter/material.dart';
import 'package:street_portal/utils/constants.dart';

class AnswerWidget extends StatelessWidget {
  const AnswerWidget({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: mainColor,
          width: 1,
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black87,
          fontSize: bodyTextSize,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
