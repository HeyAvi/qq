import 'dart:math' as math;
import 'package:flutter/material.dart';

class CorrectOverlay extends StatefulWidget {
  final bool _isCorrect;
  final VoidCallback _onTap;

  const CorrectOverlay(this._isCorrect, this._onTap, {Key? key}) : super(key: key);

  @override
  State createState() => CorrectOverlayState();
}

class CorrectOverlayState extends State<CorrectOverlay> with SingleTickerProviderStateMixin {
  Animation<double>? _iconAnimation;
  AnimationController? _iconAnimationController;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(
        duration: const Duration(seconds: 2), vsync: this);
    _iconAnimation = CurvedAnimation(
        parent: _iconAnimationController!, curve: Curves.elasticOut);
    _iconAnimation!.addListener(() => setState(() {}));
    _iconAnimationController!.forward();
  }

  @override
  void dispose() {
    _iconAnimationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: InkWell(
        onTap: () => widget._onTap(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: Transform.rotate(
                angle: _iconAnimation!.value * 2 * math.pi,
                child: Icon(
                  widget._isCorrect == true ? Icons.done : Icons.clear,
                  size: _iconAnimation!.value * 80.0,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
            ),
            Text(
              widget._isCorrect == true ? "Correct!" : "Wrong!",
              style: const TextStyle(color: Colors.white, fontSize: 30.0),
            )
          ],
        ),
      ),
    );
  }
}
