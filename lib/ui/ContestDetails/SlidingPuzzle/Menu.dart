
import 'package:flutter/material.dart';
import 'Time.dart';
import 'ResetButton.dart';
import 'Move.dart';

class Menu extends StatelessWidget {

  VoidCallback reset;
  int move;
  int secondsPassed;
  var size;

  Menu(this.reset, this.move, this.secondsPassed, this.size);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ResetButton(reset, "Reset"),
          Move(move),
          Time(secondsPassed),
        ],
      ),
    );
  }
}