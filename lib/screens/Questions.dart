// import 'package:flutter/cupertino.dart';

class Question {
  final String id;
  final String title;
  String image;
  final Map<String, bool> options;

  Question({
     this.id,
     this.title,
     this.options,
     this.image,
  });

  @override
  //to print the questions on console
  String toString() {
    return 'Question(id: $id, title: $title, options: $options)';
  }
}
