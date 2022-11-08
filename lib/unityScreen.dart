import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unity_flutter_AR/screens/home_page.dart';

class SimpleScreen extends StatefulWidget {
  SimpleScreen({Key key}) : super(key: key);
  var fgfg;

  @override
  _SimpleScreenState createState() => _SimpleScreenState();
}

class _SimpleScreenState extends State<SimpleScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  UnityWidgetController _unityWidgetController;

  //for firebase
  User user;
  final _auth = FirebaseAuth.instance;
  User signedInUser;
  var id;

//for firebase
  onRefresh(userCare) {
    setState(() {
      user = userCare;
    });
  }
  //for firebase

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        //  email = signedInUser.email;
        id = signedInUser.uid;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    //for firebase
    onRefresh(FirebaseAuth.instance.currentUser);
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          // leading: IconButton(
          //   icon: Icon(
          //     Icons.home_rounded,
          //     color: Colors.brown.shade600,
          //     size: 60.0,
          //   ),
          //   onPressed: () => Navigator.of(context).pop(),
          // ),
          // title: fgfg,
        ),
        body: Column(
          children: [
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.all(23.0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => home_page()),
                    );
                  },
                  //icon: Icon(Icons.arrow_back_ios),
                  icon: Icon(Icons.home_rounded),
                  color: Colors.brown.shade600,
                  //color: Colors.blue,
                  iconSize: 80.0,
                ),
              ],
            ),
            Card(
                clipBehavior: Clip.antiAlias,
                child: Container(

                  child: UnityWidget(
                    onUnityCreated: _onUnityCreated,
                    onUnityMessage: onUnityMessage,
                    onUnitySceneLoaded: onUnitySceneLoaded,
                  ),
                  
                )),
          ],
        ),
      ),
    );
  }

  void onUnityMessage(message) {
    print('Scoooor is: ${message.toString()}');
    var scoor = message.toString();
    var operator = scoor.substring(0, 1);
    if (operator == "A") {
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'gameAdd': int.parse(scoor.substring(1)),
      });
    } else if (operator == "S") {
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'gameSub': int.parse(scoor.substring(1)),
      });
    } else if (operator == "M") {
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'gameMul': int.parse(scoor.substring(1)),
      });
    } else if (operator == "D") {
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'gameDiv': int.parse(scoor.substring(1)),
      });
    }
  }

  void onUnitySceneLoaded(SceneLoaded scene) {
    print('Received scene loaded from unity: ${scene.name}');
    print('Received scene loaded from unity buildIndex: ${scene.buildIndex}');
  }

  // Callback that connects the created controller to the unity controller
  void _onUnityCreated(controller) {
    this._unityWidgetController = controller;
  }
}
