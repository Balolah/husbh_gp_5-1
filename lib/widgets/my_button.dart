
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:nice_buttons/nice_buttons.dart';

class MyButton extends StatelessWidget {
  MyButton(
      { this.title,
       this.onPressed,
       this.startColor,
       this.endColor,
       this.borderColor,
       this.textColor});

  final String title;
  final Function onPressed;
  final Color startColor;
  final Color endColor;
  final Color borderColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 155,
      ),
      child: NiceButtons(
        startColor: startColor,
        endColor: endColor,
        borderColor: borderColor,
        height: 42,
        stretch: true,
        
        gradientOrientation: GradientOrientation.Horizontal,
        onTap: (finish) {
          
          onPressed();
        },
        child: Text(
          title,
          style: TextStyle(
              color: textColor, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'ReadexPro',
                                            ),
        ),
      ),
    );
  }
}
