import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  static const String id = "/test_page";

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Activity",style: TextStyle(color: Colors.black, fontSize: 25,fontWeight: FontWeight.bold),),
        elevation: 0,
      ),
      body: Center(
        child: CircularProgressIndicator(

        ),
      ),
    );
  }
}
