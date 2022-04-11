import 'package:flutter/material.dart';

class LikesPage extends StatefulWidget {
  static const String id = "/likes_page";

  @override
  _LikesPageState createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Activity",style: TextStyle(color: Colors.black, fontSize: 25,fontWeight: FontWeight.bold),),
        elevation: 0,

      ),
      body: Center(
        child: Text("likes_page"),
      ),
    );
  }
}
