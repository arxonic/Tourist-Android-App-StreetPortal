import 'package:flutter/material.dart';

import 'package:street_portal/utils/constants.dart';
import 'package:street_portal/utils/sp_user.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController _headingController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();
  TextEditingController _imgURLController = TextEditingController();
  TextEditingController _placeController = TextEditingController();

  DateTime? eventDateTime;

  String? errorText;

  Future pickDateTime(BuildContext context) async{
    final date = await pickDate(context);
    if (date == null) return;
    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      eventDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String getDateTimeText(){
    if (eventDateTime == null)
      return 'Дата и время';
    else
      return '${eventDateTime?.day}/${eventDateTime?.month}/${eventDateTime?.year} ${eventDateTime?.hour}:${eventDateTime?.minute}';
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: eventDateTime ?? initialDate,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 2)
    );
    if (newDate == null)
      return null;

    return newDate;
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: DateTime.now().hour + 1, minute: 0);
    final newTime = await showTimePicker(
        context: context,
        initialTime: eventDateTime != null
        ? TimeOfDay(hour: eventDateTime!.hour, minute: eventDateTime!.minute)
        : initialTime,
    );
    if (newTime == null)
      return null;

    return newTime;
  }

  void _showToast() => Fluttertoast.showToast(
    msg: 'Новоость добавлена!',
    fontSize: buttonTextSize,
    backgroundColor: secondColor,
    textColor: whiteColor,
  );

  void addNews() {
    setState(() {
      String heading = _headingController.text;
      String body = _bodyController.text;
      String imgURL = _imgURLController.text;
      String place = _placeController.text;

      if (heading.isEmpty || body.isEmpty || imgURL.isEmpty || place.isEmpty || eventDateTime == null)
        errorText = "Все поля должны быть заполнены";
      else{
        DateTime publicationDate = DateTime.now();
        String name = SpUser.name;
        FirebaseFirestore.instance.collection('news').add({
          'heading': heading,
          'body': body,
          'event_date': eventDateTime,
          'event_place': place,
          'publication_date': publicationDate,
          'publisher_name': name,
          'tags': '18+;Новости',
          'image_url': imgURL,
        });
        _showToast();
        Navigator.pop(context);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          centerTitle: true,
          title: Text('Добавить новость',
            style: TextStyle(
              fontSize: mediumTextSize,
            ),
          ),
        ),
        body: ListView(
          children: [
            Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
                  child: TextField(
                    controller: _headingController,

                    inputFormatters: [
                      LengthLimitingTextInputFormatter(64)
                    ],

                    cursorColor: mainColor,
                    decoration: InputDecoration(
                      hintText: 'Заголовок',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: secondColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor, width: 2),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: TextField(
                    controller: _bodyController,
                    maxLines: 8,

                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2048)
                    ],

                    cursorColor: mainColor,
                    decoration: InputDecoration(
                      hintText: 'Текст',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: secondColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor, width: 2),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: TextField(
                    controller: _imgURLController,

                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1024)
                    ],

                    cursorColor: mainColor,
                    decoration: InputDecoration(
                      hintText: 'URL картинки (16 х 9)',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: secondColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor, width: 2),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: TextField(
                    controller: _placeController,

                    inputFormatters: [
                      LengthLimitingTextInputFormatter(512)
                    ],

                    cursorColor: mainColor,
                    decoration: InputDecoration(
                      hintText: 'Город, улица, дом, кв.',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: secondColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor, width: 2),
                      ),
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: buttonTextSize),
                              primary: secondColor,
                            ),
                            onPressed: () {
                              pickDateTime(context);
                            },
                            child: Text(getDateTimeText()),
                          ),
                        ),
                      ],
                    ),
                ),


                if(errorText != null) Container(
                  child: Text(errorText!,
                    style: TextStyle(
                      fontSize: errorTextSize,
                      color: errorColor,
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            child: const Text('Добавить'),
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: buttonTextSize),
                              primary: mainColor,
                            ),
                            onPressed: () {
                              addNews();
                            },
                          ),
                        ),
                      ],
                    )
                ),

              ],
            ),
          ],
        )


    );

  }
}
