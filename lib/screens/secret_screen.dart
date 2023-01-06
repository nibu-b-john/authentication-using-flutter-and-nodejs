import 'dart:developer';
import 'package:authentication/shared_preferences/shared_preference.dart';
import 'package:flutter/material.dart';

class Secrets extends StatelessWidget {
  const Secrets({Key? key}) : super(key: key);
  static const routeName = '/homePage';
  @override
  Widget build(BuildContext context) {
    log('in secret screen');
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await Preferences.remove();
                // Navigator.popUntil(
                //     context, ModalRoute.withName(Secrets.routeName));
                Navigator.pushNamedAndRemoveUntil(
                    context, Secrets.routeName, (route) => false);
              },
              icon: const Icon(Icons.send_sharp))
        ],
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 50),
          child: Text('Secrets Screen'),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
          child: Text(
        'Successfully Logged In!!',
        style: TextStyle(fontSize: 30),
      )),
    );
  }
}
