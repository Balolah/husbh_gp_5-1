// ignore_for_file: prefer_const_constructors
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:async';
//import whats needed for the database (FireBase)
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unity_flutter_AR/screens/profile.dart';
import 'package:unity_flutter_AR/widgets/my_button.dart';
import 'package:just_audio/just_audio.dart';
//import whats needed for styling & properties
import 'package:nice_buttons/nice_buttons.dart';
//import project's files
import 'WaitingScreen.dart';
import 'learn_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:unity_flutter_AR/unityScreen.dart';

class home_page extends StatefulWidget {
  @override
  State<home_page> createState() => _homepageState();
}

@override
class _homepageState extends State<home_page> {
  //user's info
  User user;
  final _auth = FirebaseAuth.instance;
  User signedInUser;
  var sex;
  var age;
  var name;

  //play audio
  AudioPlayer player;

  @override
  void initState() {
    super.initState();
    onRefresh(FirebaseAuth.instance.currentUser);
    getCurrentUser();
    super.initState();
    player = AudioPlayer();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  onRefresh(userCare) {
    setState(() {
      user = userCare;
    });
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getData() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('users').get(); //no null
    querySnapshot.docs.forEach((doc) {
      if (doc["email"] == signedInUser.email) {
        name = doc['name'];
        age = doc['age'];
        sex = doc['sex'];
        print(doc['name']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: _getData(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Scaffold(
                body: Stack(
                  children: [
                    Container(
                      width: MediaQuery.maybeOf(context)?.size.width,
                      decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30))),
                      // child: Text("plase wait")
                    ),
                    WaitingScreen(),
                  ],
                ),
              )
            : Stack(//Stack for all components

                children: [
                //background
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/home_background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

//profile image
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, right: 20.0),
                  child: Row(textDirection: TextDirection.rtl, children: [
                    GestureDetector(
                      //navigate to profile page
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => ProfilePage()),
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()),
                        ).then((value) => setState(() {}));
                      },

                      child: Container(
                        width: width * 0.08,
                        height: height * 0.12,
                        decoration: BoxDecoration(
                            //color: Colors.amber,
                            image: DecorationImage(
                              image: sex ==
                                      "boy" //if the user (child) is boy, show husbh boy, otherwise husbh girl
                                  ? AssetImage('images/husbh_boy.png')
                                  : AssetImage('images/husbh_girl.png'),
                              scale: 0.02,
                            ),
                            //style
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              //color: Color(0xFF3489e9),
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                // color: Colors
                                //     .yellow
                                //     .shade100,
                                color: Colors.grey.shade300,
                              )
                            ]),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),

                    //fetch user name & text as button to navigate to profile page
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()),
                          ).then((value) => setState(() {}));
                        },
                        child: Text(
                          '$name'.toString(), //in arabic
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontFamily: 'ReadexPro',
                            fontWeight: FontWeight.w700,
                            fontSize: 35.0,
                            color: Colors.brown,
                            //color: Color.fromARGB(255, 255, 191, 0),
                          ),
                        ))
                  ]),
                ),

                //about us
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 20.0),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      NiceButtons(
                          stretch: false,
                          startColor: Color.fromARGB(255, 255, 109, 0),
                          //FF6D00
                          endColor: Color.fromARGB(255, 255, 109, 0),
                          borderColor: Color.fromARGB(255, 204, 867, 0),
                          width: width * 0.043,
                          height: height * 0.07,
                          borderRadius: 40.0,
                          gradientOrientation: GradientOrientation.Horizontal,
                          onTap: (finish) {
                            AwesomeDialog(
                              context: context,
                              //change the dialog type here ex: INFO
                              dialogType: DialogType.question,
                              body: const Center(
                                  child: Text(
                                      'حٌسبة \nهو تطبيق لتعليم الاطفال العمليات الحسابية وجعل عملية التعلُّم ممتعة باستخدام الواقع المعزز في مجال الألعاب. قم باختيار إحدى العمليات الحسابية ولنبدأ التعلم واللعب معاً' +
                                          "\n",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontFamily: 'ReadexPro',
                                      ))),
                              borderSide:
                                  BorderSide(color: Colors.green, width: 1),
                              width: width * 0.245,

                              animType: AnimType.LEFTSLIDE,
                              showCloseIcon: true,
                              btnOkIcon: Icons.check_circle,
                              /*IF THE CHILD (TEXT) IS USED, title & desc WILL BE IGNORED
                              IF YOU WANT TO USE title and desc, YOU MUST DELETE THE CHILD (TEXT)*/

                              // title: 'عن التطبيق',
                              // desc: 'كلام عننا',
                            ).show();
                          },
                          child: Text('?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 33.0,
                                  color: Colors.white,
                                  fontFamily: 'ReadexPro',
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),

                //logo
                Column(
                    //center logo
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //logo
                      Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: Image.asset(
                          'images/husbhlogo_homepage.png',
                          //image size
                          width: width * 0.6,
                          height: height * 0.4,
                        ),
                      ),

                      //Row that has 2 main button: learn & game
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          textDirection: TextDirection.rtl,
                          children: [
                            //Learn button
                            NiceButtons(
                                stretch: false,
                                startColor: Colors.lightBlueAccent,
                                endColor: Colors.lightBlueAccent,
                                borderColor: Color(0xFF3489e9),
                                width: width * 0.16,
                                height: height * 0.16,
                                borderRadius: 60.0,
                                gradientOrientation:
                                    GradientOrientation.Horizontal,
                                //Navigate to learn page
                                onTap: (finish) async {
                                  await player.setAsset('assets/learn.mp3');
                                  player.play();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => learn_page()),
                                  );
                                  // await Future.delayed(
                                  //     const Duration(seconds: 1));
                                },
                                child: Text('تَعلّم',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontSize: 35.0,
                                        color: Colors.white,
                                        fontFamily: 'ReadexPro',
                                        fontWeight: FontWeight.bold))),

                            SizedBox(
                              width: width * 0.02,
                            ), //Space between buttons

                            //Game button
                            NiceButtons(
                                stretch: false,
                                startColor: Colors.lightBlueAccent,
                                endColor: Colors.lightBlueAccent,
                                borderColor: Color(0xFF3489e9),
                                width: width * 0.16,
                                height: height * 0.16,
                                borderRadius: 60.0,
                                gradientOrientation:
                                    GradientOrientation.Horizontal,
                                //Navigate to game page
                                onTap: (finish) async {
                                  await player.setAsset('assets/game.mp3');
                                  player.play();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SimpleScreen()),
                                  );
                                },
                                child: Text('العب',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontSize: 35.0,
                                        color: Colors.white,
                                        fontFamily: 'ReadexPro',
                                        fontWeight: FontWeight.bold))),
                          ]),
                    ])
              ]));
  }

  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}
