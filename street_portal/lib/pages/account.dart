import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:street_portal/services/auth.dart';
import 'package:street_portal/utils/constants.dart';
import 'package:street_portal/utils/sp_user.dart';

class Account extends StatelessWidget {
  const Account({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              //_Logo(),
              const SizedBox(height: 16),
              _AccountDetail(),
              const SizedBox(height: 16),
              _LeaveApp(),
            ],
          ),
        )
      );
  }
}

class _AccountDetail extends StatefulWidget {
  const _AccountDetail({Key? key}) : super(key: key);

  @override
  _AccountDetailState createState() => _AccountDetailState();
}

class _AccountDetailState extends State<_AccountDetail> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        print("A");
      },
      borderRadius: BorderRadius.circular(36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: Image.asset(
              'assets/news_error_image.png',
              fit: BoxFit.cover,
              height: 65.0,
              width: 65.0,
            ),
          ),
          SizedBox(width: 16),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  SpUser.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: largeTextSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  SpUser.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: headingTextSize,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 6),
        ],
      ),
    );
  }
}

class _LeaveApp extends StatelessWidget {
  const _LeaveApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: buttonTextSize),
              primary: errorColor,
            ),
            onPressed: () {
              context.read<AuthService>().logout();
            },
            child: Text("Выйти из аккаунта"),
          ),
        ),
      ],
    );
  }
}

