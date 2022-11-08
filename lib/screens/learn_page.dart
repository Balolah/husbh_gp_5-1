import 'package:flutter/material.dart';
import 'dart:async';

//import whats needed for the database (FireBase)
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unity_flutter_AR/screens/home_page.dart';
import 'package:unity_flutter_AR/screens/multiplication/multiplication_video.dart';
import 'package:unity_flutter_AR/screens/profile.dart';

//import whats needed for styling & properties
import 'package:nice_buttons/nice_buttons.dart';

//import project's files
import 'WaitingScreen.dart';
import 'addition/addition_video.dart';
import 'division/division_video.dart';
import 'subtraction/subtraction_video.dart';
import 'multiplication/multiplication_video.dart';

void main() async {
  //calling to use firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class learn_page extends StatefulWidget {
  @override
  State<learn_page> createState() => _learnpageState();
}

@override
class _learnpageState extends State<learn_page> {
  User user;
  final _auth = FirebaseAuth.instance;
  User signedInUser;
  var sex;
  var age;
  var name;

  @override
  void initState() {
    super.initState();
    onRefresh(FirebaseAuth.instance.currentUser);
    getCurrentUser();
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
        print(signedInUser.email); // here I read the email of the current user
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
                    width: MediaQuery.of(context).size.width,
                  ),

                  //Waiting screen
                  WaitingScreen()
                ],
              ))
            : Scaffold(
                body: Stack(children: [
                Container(
                  //Background image
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/home_background.png'),
                      fit: BoxFit.cover, //fit the image to screen
                    ),
                  ),
                ),

                //Row to have the home button
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

                //profile image
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, right: 20.0),
                  child: Row(textDirection: TextDirection.rtl, children: [
                    GestureDetector(
                      //navigate to profile page
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()),
                        );
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
                              // color: Colors.amber,
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
                                  builder: (context) => ProfilePage()));
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

                //Center the button in the rows (child)
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textDirection: TextDirection.rtl,
                    children: [
                      //Addition operation button
                      NiceButtons(
                          stretch: false,
                          startColor: Colors.amber,
                          endColor: Colors.amber,
                          borderColor: Color.fromARGB(255, 205, 144, 0),
                          width: width * 0.15,
                          height: width * 0.15,
                          borderRadius: 100.0,
                          borderThickness: 10,
                          gradientOrientation: GradientOrientation.Horizontal,
                          onTap: (finish) {
                            //Navigate to addition video
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => additionVideo()),
                            );
                          },
                          child: Text('+',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 100.0,
                                  color: Colors.white,
                                  fontFamily: 'ReadexPro',
                                  fontWeight: FontWeight.bold))),
                      //End addition operation button

                      SizedBox(width: 40), //Space between buttons

                      //Subtraction operation button
                      NiceButtons(
                          stretch: false,
                          startColor: Colors.lightBlueAccent,
                          endColor: Colors.lightBlueAccent,
                          borderColor: Color(0xFF3489e9),
                          width: width * 0.15,
                          height: width * 0.15,
                          borderRadius: 100.0,
                          borderThickness: 10,
                          gradientOrientation: GradientOrientation.Horizontal,
                          onTap: (finish) {
                            Navigator.push(
                              //Navigate to subtraction video
                              context,
                              MaterialPageRoute(
                                  builder: (context) => subtractionVideo()),
                            );
                          },
                          child: Text('-',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 100.0,
                                  color: Colors.white,
                                  fontFamily: 'ReadexPro',
                                  fontWeight: FontWeight.bold))),
                      //End subtraction operation button

                      SizedBox(width: 40), //Space between buttons

                      //Multiplication operation button
                      NiceButtons(
                          stretch: false,
                          startColor: Colors.lightGreen,
                          endColor: Colors.lightGreen,
                          borderColor: Color.fromARGB(255, 50, 132, 9),
                          width: width * 0.15,
                          height: width * 0.15,
                          borderRadius: 100.0,
                          borderThickness: 10,
                          gradientOrientation: GradientOrientation.Horizontal,
                          onTap: (finish) {
                            Navigator.push(
                              //Navigate to multiplication video
                              context,
                              MaterialPageRoute(
                                  builder: (context) => multiplicationVideo()),
                            );
                          },
                          child: Text('×',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 100.0,
                                  color: Colors.white,
                                  fontFamily: 'ReadexPro',
                                  fontWeight: FontWeight.bold))),
                      //End multiplication operation button

                      SizedBox(width: 40), //Space between buttons

                      //Division operation button
                      NiceButtons(
                          stretch: false,
                          startColor: Colors.redAccent.shade400,
                          endColor: Colors.redAccent.shade400,
                          borderColor: Color.fromARGB(255, 169, 14, 14),
                          width: width * 0.15,
                          height: width * 0.15,
                          borderRadius: 100.0,
                          borderThickness: 10,
                          gradientOrientation: GradientOrientation.Horizontal,
                          onTap: (finish) {
                            Navigator.push(
                              //Navigate to division video
                              context,
                              MaterialPageRoute(
                                  builder: (context) => divisionVideo()),
                            );
                          },
                          child: Text('\u00F7',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 100.0,
                                  color: Colors.white,
                                  fontFamily: 'ReadexPro',
                                  fontWeight: FontWeight.bold))),
                      //End division operation button
                    ],
                  ),
                )
              ])));
  }
}

@override
State<StatefulWidget> createState() {
  // TODO: implement createState
  throw UnimplementedError();
}
