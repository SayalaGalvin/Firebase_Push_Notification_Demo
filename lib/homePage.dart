
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomeState();
}

class _HomeState extends State<HomePage> {
  final formKey = new GlobalKey<FormState>();
  @override
  void _initState() {
    super.initState();
  }

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  String _token;
  String _userDev = "G6CU00MasFZDr8VvvuwmiGXrd7p2";
  String _user = "Ezu17pb6lLWKXse6Frm2YgXxsFf2";
  String _title;
  String _msg;

  void setToken() {
    firebaseMessaging.getToken().then((token) {
      _token = token;
      print("Token " + token);
    });
    Firestore.instance.collection('Token').document(_userDev).setData({
      'Token': _token,
    }).then((onValue) {
      print("Successfully Added");
    });
  }

  Future<void> insertItem() async {
    final form = formKey.currentState;
    form.save();

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(Firestore.instance.collection("Notification").document(), {
        'User': _user,
        'Title': _title,
        'Body': _msg,
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: new Form(
                key: formKey,
                child: Column(
                  children: <Widget>[

                    new TextFormField(
                      decoration: new InputDecoration(
                          labelText: "Title",
                          contentPadding: const EdgeInsets.all(20.0),
                          labelStyle: TextStyle(color: Colors.blue)),
                      onSaved: (value) => _title = value,
                    ),
                    new TextFormField(
                      decoration: new InputDecoration(
                          labelText: "Message",
                          contentPadding: const EdgeInsets.all(20.0),
                          labelStyle: TextStyle(color: Colors.blue)),
                      onSaved: (value) => _msg = value,
                    ),
                    new SizedBox(
                      height: 20,
                    ),
                    new OutlineButton(
                      padding: EdgeInsets.all(10.0),
                      child: new Text(
                        "Add",
                        style:
                        new TextStyle(fontSize: 20.0, color: Colors.blue),
                      ),
                      onPressed: insertItem,
                    ),
                    new SizedBox(
                      height: 20,
                    ),
                    new OutlineButton(
                      padding: EdgeInsets.all(10.0),
                      child: new Text(
                        "Insert Token",
                        style:
                        new TextStyle(fontSize: 20.0, color: Colors.blue),
                      ),
                      onPressed: setToken,
                    )
                  ],
                ))));
  }
}
