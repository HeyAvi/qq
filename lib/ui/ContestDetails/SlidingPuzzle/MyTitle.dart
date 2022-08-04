
import 'package:flutter/material.dart';

class MyTitle extends StatelessWidget {
  var size;

  MyTitle(this.size);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.all(5.0),
      child: Text(
        "Sliding Puzzle",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
            decoration: TextDecoration.none),
      ),
    );
  }
}
