import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:street_portal/services/auth.dart';
import 'package:street_portal/utils/constants.dart';
import 'package:street_portal/utils/sp_user.dart';


class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String? errorText;

  void checkLogPass() async{
    String login = _loginController.text.trim().toLowerCase();
    String password = _passwordController.text;
    String? err;

    if (login.isNotEmpty && password.isNotEmpty) {
      context.read<AuthService>().signWithEmailPassword(login, password);
    }else{
      err = "Поля не должны быть пустыми";
    }

    setState(() {
      errorText = err;
    });
  }

  void registration() async {
    String login = _loginController.text.trim().toLowerCase();
    String password = _passwordController.text.trim();
    String? err;


    if (login.isNotEmpty && password.isNotEmpty) {
      context.read<AuthService>().registrationWithEmailPassword(login, password);
    }else{
      err = "Поля не должны быть пустыми";
    }

    setState(() {
      errorText = err;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 50),
            children: [
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Street Portal',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: largeTextSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                controller: _loginController,

                inputFormatters: [
                  LengthLimitingTextInputFormatter(32)
                ],

                cursorColor: mainColor,
                decoration: InputDecoration(
                  hintText: 'Логин',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: mainColor, width: 2),
                  ),
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,

                inputFormatters: [
                  LengthLimitingTextInputFormatter(32)
                ],

                cursorColor: mainColor,
                decoration: InputDecoration(
                  hintText: 'Пароль',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: mainColor, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 10),
              if(errorText != null) Text(errorText!,
                style: TextStyle(
                  fontSize: errorTextSize,
                  color: errorColor,
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: buttonTextSize),
                      primary: secondColor,
                    ),
                    onPressed: () {
                      registration();
                    },
                    child: const Text('Регистрация'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: buttonTextSize),
                      primary: mainColor,
                    ),
                    onPressed: () {
                      checkLogPass();
                    },
                    child: const Text('ОК'),
                  ),
                ],
              ),
            ],
          ),
        )
    );

  }
}
