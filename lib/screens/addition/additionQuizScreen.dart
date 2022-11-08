// import 'dart:html';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:nice_buttons/nice_buttons.dart';
import '../../widgets/next_button.dart';
import '../../widgets/option_card.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import '../home_page.dart';
import 'additionResultScreen.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart';

//for firebase

class additionQuizScreen extends StatefulWidget {
  const additionQuizScreen({Key key}) : super(key: key);

  @override
  _additionQuizScreenState createState() => _additionQuizScreenState();

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    TextDirection.rtl;
    return Container();
  }
}

class _additionQuizScreenState extends State<additionQuizScreen> {
  // late AudioCache _audioCache;
  get width => MediaQuery.of(context).size.width;
  get height => MediaQuery.of(context).size.height;

  //play audio
  AudioPlayer player;

  //to convert numbers to arabic
  ArabicNumbers arabicNumber = ArabicNumbers();

  //for firebase
  User user;
  final _auth = FirebaseAuth.instance;
  User signedInUser;
  var id;
  var rightAnswer = true;
  int cntRightAhad = 0;
  int cntRightAshrat = 0;
  int cntRightMeat = 0;

  List qustions = []; //question list
  List answers = []; //answer list
  bool isMarked = false;
  List<List<dynamic>> mcq = []; //multiple choice answers
  List userAnswer = [];
  var ansData;
  List<dynamic> ans = []; //the random options
  var j = 0;
  final int numOfSingleQuestions = 4; //الآحاد
  final int numOfTensQuestions = 4; //العشرات
  final int numOfHundredQuestions = 4; //المئات
  List<dynamic> Xx = []; //value for the image objects
  List<dynamic> Yy = []; //value for the image objects

  //skills score
  var addSinglescore = 0;
  var addTensscore = 0;
  var addHundredscore = 0;
  bool isPressedFirst = false;
  bool isPressedSecond = false;

  bool isPressedThird = false;

  bool isPressedForth = false;

  String arabicX = "";
  String arabicY = "";

  var x = Random().nextInt(9) + 1;
  var y = Random().nextInt(9) + 1;

  bool getIsPressedFirst() {
    return isPressedFirst;
  }

  bool getIsPressedSecond() {
    return isPressedSecond;
  }

  bool getIsPressedThird() {
    return isPressedThird;
  }

  bool getIsPressedForth() {
    return isPressedForth;
  }

  get startColor => null;

  get endColor => null;

  get borderColor => null;

  get color => null;

  get onPressed => null;

  get states => null;

  void initState() {
    //for firebase
    onRefresh(FirebaseAuth.instance.currentUser);
    getCurrentUser();
    player = AudioPlayer();
    TextDirection.rtl;
    super.initState();

    //الاحاد
    //the loop will be used for the first 4 question which is the 1st level "add singles" dealing with objects
    for (var i = 1; i < numOfSingleQuestions + 1; i++) {
      ans = [];
      x = Random().nextInt(9) + 1;
      y = Random().nextInt(9) + 1;
      //for objects
      Xx.add(x);
      Yy.add(y);

      TextDirection.rtl;
      qustions.add(convertToArabic());
      //question
      answers.add(x + y);
      //the option in mcq
      ansData = [
        convertOptionsToArabic(x + y), //option 1 right answer
        convertOptionsToArabic(x + y + 1), //option 2
        convertOptionsToArabic(x + y + 7), //option 3
        convertOptionsToArabic(x + y + 3), //oprion 4
      ];

      for (var j = 0; j < 4; j++) {
        var rNum = Random().nextInt(ansData.length).round();
        ans.add(ansData[rNum]);
        ansData.removeAt(rNum);
      }
      mcq.add(ans);
    }

    //العشرات
    //the loop will be used for the first 4 question which is the 2nd level "add tens"
    for (var i = 1; i < numOfTensQuestions + 1; i++) {
      ans = [];
      //choose random number for x & y with range for them adding them do not exceed 100
      x = Random().nextInt(99) + 1;
      y = Random().nextInt(99) + 1;
      while (x < 10 || y < 10 || x + y > 100) {
        x = Random().nextInt(99) + 1;
        y = Random().nextInt(99) + 1;
      }

      textDirection:
      TextDirection.rtl;
      qustions.add(convertToArabic());
      answers.add(x + y);
      //the option in mcq
      ansData = [
        convertOptionsToArabic(x + y), //option 1 right answer,
        convertOptionsToArabic(x + y + 2), //option 2
        convertOptionsToArabic(x + y + 9), //option 3
        convertOptionsToArabic(x + y + 5), //option 4
      ];

      for (var j = 0; j < 4; j++) {
        var rNum = Random().nextInt(ansData.length).round();
        ans.add(ansData[rNum]);
        ansData.removeAt(rNum);
      }
      //add the options to the mcq list
      mcq.add(ans);
    }

    //المئات
    for (var i = 1; i < numOfHundredQuestions + 1; i++) {
      ans = [];
      x = Random().nextInt(999);
      y = Random().nextInt(999);
      while (x < 100 || y < 100 || x + y > 500) {
        x = Random().nextInt(999);
        y = Random().nextInt(999);
      }

      textDirection:
      TextDirection.rtl;
      qustions.add(convertToArabic());
      answers.add(x + y);
      ansData = [
        convertOptionsToArabic(x + y),
        convertOptionsToArabic(x + y + 1),
        convertOptionsToArabic(x + y + 3),
        convertOptionsToArabic(x + y + 6),
      ];

      for (var j = 0; j < 4; j++) {
        var rNum = Random().nextInt(ansData.length).round();
        ans.add(ansData[rNum]);
        ansData.removeAt(rNum);
      }
      mcq.add(ans);
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  //for firebase
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
        //  email = signedInUser.email;
        id = signedInUser.uid;
      }
    } catch (e) {
      print(e);
    }
  }

  //convert the numbers to arabic using package:arabic_numbers

  String convertToArabic() {
    arabicX = arabicNumber.convert(x);
    arabicY = arabicNumber.convert(y);
    return "$arabicX " + "+" + " $arabicY";
  }

  String convertOptionsToArabic(int num) {
    arabicX = arabicNumber.convert(num);
    return "$arabicX";
  }

//change the question method
  _changeQuestion(ans) async {
    userAnswer.add(ans);

    if (j + 1 >= 12) {
      //if the user answers right, add score
      for (var i = 0; i < 4; i++) {
        if (userAnswer[i].toString() ==
            convertOptionsToArabic(answers[i]).toString()) {
          addSinglescore++;
        }
      }

      //if the user answers right, add score
      for (var i = 4; i < 8; i++) {
        if (userAnswer[i].toString() ==
            convertOptionsToArabic(answers[i]).toString()) {
          addTensscore++;
        }
      }

      //if the user answers right, add score
      for (var i = 8; i < 12; i++) {
        if (userAnswer[i].toString() ==
            convertOptionsToArabic(answers[i]).toString()) {
          addHundredscore++;
        }
      }
      Map<String, dynamic> level1 = {
        'score': cntRightAhad,
        'year': year(),
        'time': time(),
      };
      Map<String, dynamic> level2 = {
        'score': cntRightAshrat,
        'year': year(),
        'time': time(),
      };
      Map<String, dynamic> level3 = {
        'score': cntRightMeat,
        'year': year(),
        'time': time(),
      };
      //for firebase
      FirebaseFirestore.instance
          .collection('Learn')
          .doc(user.uid)
          .collection('Report')
          .doc('Add')
          .update({
        'addLevel1': FieldValue.arrayUnion([level1]),
        'addLevel2': FieldValue.arrayUnion([level2]),
        'addLevel3': FieldValue.arrayUnion([level3]),
      });
      //when finish navigate to the result page with the scores
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => additionResultScreen(
              maxSingleScore: numOfSingleQuestions,
              maxTensScore: numOfTensQuestions,
              maxHundredScore: numOfHundredQuestions,
              addsinglescore: cntRightAhad,
              addtensscore: cntRightAshrat,
              addhundredscore: cntRightMeat,
              answers: answers,
              qustions: qustions,
              userAnswer: userAnswer),
        ),
      );
      player.setAsset('assets/your_score.mp3');
      player.play();
    } else {
      setState(() {
        ++j;
        isMarked = false;
        isPressedFirst = false;
        isPressedSecond = false;
        isPressedThird = false;
        isPressedForth = false;

        // _audioCache = AudioCache(
        //     prefix: "assets/",
        //     fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
      });
    }
  }

  //objects for questions
  List<String> objects = [
    'images/GreennApple.png',
    'images/ReddApple.png',
    'images/Xgreenn.png',
    'images/Xredd.png',
  ];
//returns images for value x
  Widget _printImageX(xValue) {
    //if value = 0 show its image
    if (xValue == 0) {
      return Center(
        child: Wrap(
          direction: Axis.horizontal,
          children: <Widget>[
            Image.asset(
              //xgreen
              objects[2],
              width: width * 0.13,
              height: height * 0.12,
            )
          ],
        ),
      );
    }
    //else show the apples
    return Center(
      child: Wrap(
        direction: Axis.horizontal,
        children: <Widget>[
          for (var i = 0; i < xValue; i++)
            Image.asset(
              objects[0],
              width: width * 0.13,
              height: height * 0.12,
            )
        ],
      ),
    );
  }

//returns images for value y
  Widget _printImageY(yValue) {
    if (yValue == 0) {
      return Center(
        child: Wrap(
          direction: Axis.horizontal,
          children: <Widget>[
            Image.asset(
              objects[3],
              width: width * 0.13,
              height: height * 0.12,
            )
          ],
        ),
      );
    }
    return Center(
      child: Wrap(
        direction: Axis.horizontal,
        children: <Widget>[
          for (var i = 0; i < yValue; i++)
            Image.asset(
              objects[1],
              width: width * 0.13,
              height: height * 0.12,
            )
        ],
      ),
    );
  }

  void nextQuestion() {
    _changeQuestion('-١');
  }

  void changeColorFirstButton() {
    setState(() {
      isPressedFirst = true;
    });
  }

  void changeColorSecondButton() {
    setState(() {
      isPressedSecond = true;
    });
  }

  void changeColorThirdButton() {
    setState(() {
      isPressedThird = true;
    });
  }

  void changeColorForthButton() {
    setState(() {
      isPressedForth = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    textDirection:
    TextDirection.rtl;
    return Scaffold(
      body: Stack(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/farm.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),

                    Container(
                      child: Text("= " + qustions[j],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.lightBlue,
                              fontFamily: "ReadexPro-Regular",
                              fontSize: MediaQuery.of(context).size.width > 500
                                  ? 45
                                  : 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    // SizedBox(
                    //   width: width * 0.2,
                    // ),
                    Expanded(
                      child: Container(
                        child: GifHint(j),
                      ),
                    ),
                  ],
                ),
                ImagesUnderQuestion(j),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
                  SizedBox(
                    height: height * 0.155,
                    width: width * 0.13,
                    child: OptionCard(
                        option: mcq[j][0].toString(),
                        color: isPressedFirst
                            ? (mcq[j][0].toString() ==
                                    convertOptionsToArabic(answers[j])
                                        .toString())
                                ? const Color.fromARGB(
                                    255, 50, 132, 9) //correct
                                : const Color.fromRGBO(
                                    218, 39, 39, 1) //incorrect
                            : const Color(0xFF3489e9),
                        onTap: () async {
                          changeColorFirstButton();
                          if (mcq[j][0].toString() ==
                              convertOptionsToArabic(answers[j]).toString()) {
                            if (rightAnswer) {
                              if (j == 0 || j == 1 || j == 2 || j == 3) {
                                cntRightAhad++;
                              } else if (j == 4 || j == 5 || j == 6 || j == 7) {
                                cntRightAshrat++;
                              } else if (j == 8 ||
                                  j == 9 ||
                                  j == 10 ||
                                  j == 11) {
                                cntRightMeat++;
                              }
                            }
                            await player.setAsset('assets/good_job.mp3');
                            player.play();
                            rightAnswer = true;

                            await Future.delayed(const Duration(seconds: 1),
                                () {
                              _changeQuestion(mcq[j][0].toString());
                            });
                          } else {
                            rightAnswer = false;
                            await player.setAsset('assets/wrong_answer.mp3');
                            player.play();
                          }
                        }),
                  ),
                  SizedBox(height: height * 0.20, width: width * 0.03),
                  SizedBox(
                    height: height * 0.155,
                    width: width * 0.13,
                    child: OptionCard(
                        option: mcq[j][1].toString(),
                        color: isPressedSecond
                            ? (mcq[j][1].toString() ==
                                    convertOptionsToArabic(answers[j])
                                        .toString())
                                ? const Color.fromARGB(
                                    255, 50, 132, 9) //correct
                                : const Color.fromRGBO(
                                    218, 39, 39, 1) //incorrect
                            : const Color(0xFF3489e9),
                        onTap: () async {
                          changeColorSecondButton();
                          if (mcq[j][1].toString() ==
                              convertOptionsToArabic(answers[j]).toString()) {
                            if (rightAnswer) {
                              if (j == 0 || j == 1 || j == 2 || j == 3) {
                                cntRightAhad++;
                              } else if (j == 4 || j == 5 || j == 6 || j == 7) {
                                cntRightAshrat++;
                              } else if (j == 8 ||
                                  j == 9 ||
                                  j == 10 ||
                                  j == 11) {
                                cntRightMeat++;
                              }
                            }
                            await player.setAsset('assets/good_job.mp3');
                            player.play();
                            rightAnswer = true;

                            await Future.delayed(const Duration(seconds: 1),
                                () {
                              _changeQuestion(mcq[j][1].toString());
                            });
                          } else {
                            rightAnswer = false;
                            await player.setAsset('assets/wrong_answer.mp3');
                            player.play();
                          }
                        }),
                  ),
                  SizedBox(height: height * 0.20, width: width * 0.03),
                  SizedBox(
                    height: height * 0.155,
                    width: width * 0.13,
                    child: OptionCard(
                        option: mcq[j][2].toString(),
                        color: isPressedThird
                            ? (mcq[j][2].toString() ==
                                    convertOptionsToArabic(answers[j])
                                        .toString())
                                ? const Color.fromARGB(
                                    255, 50, 132, 9) //correct
                                : const Color.fromRGBO(218, 39, 39, 1)
                            //incorrect
                            : const Color(0xFF3489e9),
                        onTap: () async {
                          changeColorThirdButton();
                          if (mcq[j][2].toString() ==
                              convertOptionsToArabic(answers[j]).toString()) {
                            if (rightAnswer) {
                              if (j == 0 || j == 1 || j == 2 || j == 3) {
                                cntRightAhad++;
                              } else if (j == 4 || j == 5 || j == 6 || j == 7) {
                                cntRightAshrat++;
                              } else if (j == 8 ||
                                  j == 9 ||
                                  j == 10 ||
                                  j == 11) {
                                cntRightMeat++;
                              }
                            }
                            await player.setAsset('assets/good_job.mp3');
                            player.play();
                            rightAnswer = true;
                            await Future.delayed(const Duration(seconds: 1),
                                () {
                              _changeQuestion(mcq[j][2].toString());
                            });
                          } else {
                            rightAnswer = false;
                            await player.setAsset('assets/wrong_answer.mp3');
                            player.play();
                          }
                        }),
                  ),
                  SizedBox(height: height * 0.20, width: width * 0.03),
                  SizedBox(
                    height: height * 0.155,
                    width: width * 0.13,
                    child: OptionCard(
                        option: mcq[j][3].toString(),
                        color: isPressedForth
                            ? (mcq[j][3].toString() ==
                                    convertOptionsToArabic(answers[j])
                                        .toString())
                                ? const Color.fromARGB(
                                    255, 50, 132, 9) //correct
                                : const Color.fromRGBO(
                                    218, 39, 39, 1) //incorrect
                            : const Color(0xFF3489e9),
                        onTap: () async {
                          changeColorForthButton();
                          if (mcq[j][3].toString() ==
                              convertOptionsToArabic(answers[j]).toString()) {
                            if (rightAnswer) {
                              if (j == 0 || j == 1 || j == 2 || j == 3) {
                                cntRightAhad++;
                              } else if (j == 4 || j == 5 || j == 6 || j == 7) {
                                cntRightAshrat++;
                              } else if (j == 8 ||
                                  j == 9 ||
                                  j == 10 ||
                                  j == 11) {
                                cntRightMeat++;
                              }
                            }
                            await player.setAsset('assets/good_job.mp3');
                            player.play();
                            rightAnswer = true;

                            await Future.delayed(const Duration(seconds: 1),
                                () {
                              _changeQuestion(mcq[j][3].toString());
                            });
                          } else {
                            rightAnswer = false;
                            await player.setAsset('assets/wrong_answer.mp3');
                            player.play();
                          }
                        }),
                  ),
                  SizedBox(height: height * 0.20, width: width * 0.03),
                ]),
              ])
        ],
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30, top: 30, right: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(
            children: [
              Container(
                height: 60,
                width: 60,
                child: FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    //icon: Icon(Icons.arrow_back_ios),
                    Icons.home_rounded,
                    color: Colors.brown.shade600,
                    //color: Colors.blue,
                    size: 60.0,
                  ),
                  heroTag: null,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => home_page()),
                    );
                  },
                ),
              ),
            ],
          ),
          Expanded(child: Container()),
          Container(
            height: 70.0,
            width: 100.0,
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              child: Column(
                  children: <Widget>[NextButton(nextQuestion: nextQuestion)]),
              onPressed: () {},
              heroTag: null,
            ),
          ),
        ]),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  ImagesUnderQuestion(int j) {
    if (j == 4 || j == 5 || j == 6 || j == 7) {
      return SizedBox(
        height: height * 0.55,
        child: Column(
          children: [
            Center(
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'images/dogFrame.png',
                      height: height * 0.49,
                      width: width * 0.30,
                      // fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SizedBox(
                            // width: 20,
                            child: Text(
                              "  ",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          SizedBox(
                            height: height *
                                0.2, // اللي يرتب مكان السؤال جوا الصورة

                            // width: 30,
                            // height: 50,
                            child: Text(
                              " ",
                              style: TextStyle(fontSize: 33.0),
                            ),
                          ),
                          SizedBox(
                            // space between two numbers
                            width: width * 0.05,
                            // width: 35,
                            height: height * 0.10,
                            // height: 34,
                            child: Text(
                              qustions[j].toString().substring(0, 2),
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32.0),
                            ),
                          ),
                          Align(
                            heightFactor: 0.01,
                            child: Column(
                              textDirection: TextDirection.rtl,
                              children: [
                                SizedBox(
                                  width: width * 0.09,
                                  height: height * 0.09,
                                  // width: 67,
                                  // height: 21,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      SizedBox(
                                        // width: 63,
                                        // height: 44,

                                        // height: height * 0.50,
                                        child: Text(
                                          "+",
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: width * 0.05,
                            height: height * 0.10,
                            // width: 35,
                            // height: 40,
                            child: Text(
                              qustions[j].toString().substring(5, 7),
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32.0),
                            ),
                          ),
                          Align(
                            heightFactor: 0.75,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: width * 0.09,
                                  height: height * 0.12,
                                  // width: 63,
                                  // height: 44,
                                  child: Text(
                                    "________",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (j == 0 || j == 1 || j == 2 || j == 3) {
      return SizedBox(
        height: height * 0.55,
        child: Align(
          alignment: Alignment.center,
          child: Wrap(
            children: [
              SizedBox(width: width * 0.40, child: _printImageY(Yy[j])),
              const Text(
                ' + ',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 60,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: width * 0.40, child: _printImageX(Xx[j])),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        height: height * 0.55,
        // height: 200,
        child: Column(
          children: [
            Center(
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'images/catFrame.png',
                      height: height * 0.49,
                      width: width * 0.30,
                      // fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SizedBox(
                            width: width * 0.02,
                            // width: 20,
                            child: Text(
                              "  ",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          SizedBox(
                            // width: 30,
                            // height: 50,
                            height: height *
                                0.2, // اللي يرتب مكان السؤال جوا الصورة
                            child: Text(
                              " ",
                              style: TextStyle(fontSize: 33.0),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.07,
                            height: height * 0.10,
                            // width: 59,
                            // height: 34,
                            child: Text(
                              qustions[j].toString().substring(0, 3),
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32.0),
                            ),
                          ),
                          Align(
                            heightFactor: 0.01,
                            child: Column(
                              textDirection: TextDirection.rtl,
                              children: [
                                SizedBox(
                                  //to Change the "+" position
                                  width: width * 0.088,
                                  height: height * 0.10,
                                  // width: 67,
                                  // height: 21,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      SizedBox(
                                        child: Text(
                                          "+",
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: width * 0.10,
                            height: height * 0.10,
                            // width: 80,
                            // height: 40,
                            child: Text(
                              qustions[j].toString().substring(5, 9),
                              style: TextStyle(
                                  letterSpacing: 4,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32.0),
                            ),
                          ),
                          Align(
                            heightFactor: 0.75,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: width * 0.09,
                                  height: height * 0.12,
                                  // width: 63,
                                  // height: 44,
                                  child: Text(
                                    "________",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  GifHint(int j) {
    //hint of ashrat
    if (j == 4 || j == 5 || j == 6 || j == 7) {
      return SizedBox(
        child: Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 100),
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
                        width: 80.0,
                        height: 70.0,
                        borderRadius: 40.0,
                        gradientOrientation: GradientOrientation.Horizontal,
                        onTap: (finish) {
                          AwesomeDialog(
                            context: context,
                            headerAnimationLoop: false,
                            dialogType: DialogType.noHeader,
                            body: Container(
                              height: height * 0.3,
                              width: width * 0.2,
                              child: Column(
                                children: [
                                  Text('مثال آخر لمساعدتك',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontFamily: 'ReadexPro',
                                          fontWeight: FontWeight.bold)),
                                  Image.asset(
                                    'images/Add_Tenth__AdobeExpress.gif',
                                  ),
                                ],
                              ),
                            ),
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                            width: 350,
                            animType: AnimType.LEFTSLIDE,
                            showCloseIcon: true,
                            btnOkIcon: Icons.check_circle,
                          ).show();
                        },
                        child: Text('مساعدة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 20.0,
                                color: Colors.white,
                                fontFamily: 'ReadexPro',
                                fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              // end Hint to help child
            ],
          ),
        ),
      );
      //end hint of ashrat
    }
    // hint of ahad
    else if (j == 0 || j == 1 || j == 2 || j == 3) {
      return SizedBox(
        child: Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 100),
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
                        width: 80.0,
                        height: 70.0,
                        borderRadius: 40.0,
                        gradientOrientation: GradientOrientation.Horizontal,
                        onTap: (finish) {
                          AwesomeDialog(
                            context: context,
                            //change the dialog type here ex: INFO
                            headerAnimationLoop: false,
                            dialogType: DialogType.noHeader,

                            body: Container(
                              height: height * 0.222,
                              width: width * 0.2,
                              child: Column(
                                children: [
                                  Text('مثال آخر لمساعدتك',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontFamily: 'ReadexPro',
                                          fontWeight: FontWeight.bold)),
                                  Image.asset(
                                    'images/Add_S__AdobeExpress.gif',
                                  ),
                                ],
                              ),
                            ),
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                            width: 350,
                            animType: AnimType.LEFTSLIDE,
                            showCloseIcon: true,
                            btnOkIcon: Icons.check_circle,
                          ).show();
                        },
                        child: Text('مساعدة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 20.0,
                                color: Colors.white,
                                fontFamily: 'ReadexPro',
                                fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              // end Hint to help child
            ],
          ),
        ),
      );
      //end hint of ahad
    }
    // hint of meat
    else {
      return SizedBox(
        child: Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 100),
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
                        width: 80.0,
                        height: 70.0,
                        borderRadius: 40.0,
                        gradientOrientation: GradientOrientation.Horizontal,
                        onTap: (finish) {
                          AwesomeDialog(
                            context: context,
                            //change the dialog type here ex: INFO
                            headerAnimationLoop: false,
                            dialogType: DialogType.noHeader,

                            body: Container(
                              height: height * 0.3,
                              width: width * 0.2,
                              child: Column(
                                children: [
                                  Text('مثال آخر لمساعدتك',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontFamily: 'ReadexPro',
                                          fontWeight: FontWeight.bold)),
                                  Image.asset(
                                    'images/Add_Hun__AdobeExpress.gif',
                                  ),
                                ],
                              ),
                            ),
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                            width: 350,
                            animType: AnimType.LEFTSLIDE,
                            showCloseIcon: true,
                            btnOkIcon: Icons.check_circle,
                          ).show();
                        },
                        child: Text('مساعدة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 20.0,
                                color: Colors.white,
                                fontFamily: 'ReadexPro',
                                fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              // end Hint to help child
            ],
          ),
        ),
      );
    }
    //end of hint meat
  }

  String replaceFarsiNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const farsi = ['۰', '۱', '۲', '۳', '٤', '٥', '٦', '۷', '۸', '۹'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], farsi[i]);
    }

    return input;
  }

  String year() {
    var y = replaceFarsiNumber(DateTime.now().year.toString());
    var m = replaceFarsiNumber(DateTime.now().month.toString());
    var d = replaceFarsiNumber(DateTime.now().day.toString());

    var year = d + '/' + m + '/' + y;

    return year;
  }

  String time() {
    var h = replaceFarsiNumber(DateTime.now().hour.toString());
    var min = replaceFarsiNumber(DateTime.now().minute.toString());
    var s = replaceFarsiNumber(DateTime.now().second.toString());

    if (h == '۱۲') {
      h = h + " مساءً ";
    } else if (h == '۱۳') {
      h = '۰۱';
      h = h + " مساءً ";
    } else if (h == '۱٤') {
      h = '۰۲';
      h = h + " مساءً ";
    } else if (h == '۱٥') {
      h = '۰۳';
      h = h + " مساءً ";
    } else if (h == '۱٦') {
      h = '۰٤';
      h = h + " مساءً ";
    } else if (h == '۱٧') {
      h = '۰٥';
      h = h + " مساءً ";
    } else if (h == '۱۸') {
      h = '۰٦';
      h = h + " مساءً ";
    } else if (h == '۱۹') {
      h = '۰٧';
      h = h + " مساءً ";
    } else if (h == '۲۰') {
      h = '۰۸';
      h = h + " مساءً ";
    } else if (h == '۲۱') {
      h = '۰۹';
      h = h + " مساءً ";
    } else if (h == '۲۲') {
      h = '۱۰';
      h = h + " مساءً ";
    } else if (h == '۲۳') {
      h = '۱۱';
      h = h + " مساءً ";
    } else if (h == '۰') {
      h = '۰۰';
      h = h + " صباحًا ";
    } else {
      h = h + " صباحًا ";
    }

    if (min == '۰') {
      min = "۰۰";
    } else if (min == '۱') {
      min = '۰۱';
    } else if (min == '۲') {
      min = '۰۲';
    } else if (min == '۳') {
      h = '۰۳';
    } else if (min == '٤') {
      min = '۰٤';
    } else if (min == '٥') {
      min = '۰٥';
    } else if (min == '٦') {
      min = '۰٦';
    } else if (min == '٧') {
      min = '۰٧';
    } else if (min == '۸') {
      min = '۰۸';
    } else if (min == '۹') {
      min = '۰۹';
    }
    if (s == '۰') {
      s = "۰۰";
    } else if (s == '۱') {
      s = '۰۱';
    } else if (s == '۲') {
      s = '۰۲';
    } else if (s == '۳') {
      s = '۰۳';
    } else if (s == '٤') {
      s = '۰٤';
    } else if (s == '٥') {
      s = '۰٥';
    } else if (s == '٦') {
      s = '۰٦';
    } else if (s == '٧') {
      s = '۰٧';
    } else if (s == '۸') {
      s = '۰۸';
    } else if (s == '۹') {
      s = '۰۹';
    }

    var time = s + ' : ' + min + ' : ' + h;
    DateTime now = new DateTime.now();
    DateTime currentPhoneDate = DateTime.now(); //DateTime

    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate); //To TimeStamp

    DateTime myDateTime = myTimeStamp.toDate(); // TimeStamp to DateTime
    print(DateTime.now().toLocal());
    return time;
  }
}
