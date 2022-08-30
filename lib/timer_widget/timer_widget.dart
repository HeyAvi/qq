import 'package:flutter/material.dart';

import '../utils/ColorConstants.dart';

class HomeTimer extends StatelessWidget {
  final Widget boxWidget;
  final String boxName;
  final bool? showColon;

  const HomeTimer(
      {Key? key, required this.boxWidget, required this.boxName, this.showColon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                  boxWidget
                ],
              ),
            ),
            Positioned(
              top: -3,
              child: Container(
                width: 30,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(boxName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        )),
                  ),
                ),
                decoration: const BoxDecoration(
                  color: ColorConstants.orangeColor,
                ),
              ),
            ),
          ],
        ),
        if (showColon ?? true)
          const Text(
            ':',
            style: TextStyle(
                color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }
}
