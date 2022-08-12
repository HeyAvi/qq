import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qq/utils/ColorConstants.dart';

// todo not in use
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Flex(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      direction: Axis.vertical,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            decoration: const BoxDecoration(
              color: ColorConstants.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      bottom:
                                          3, // This can be the space you need between text and underline
                                    ),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.white,
                                          width:
                                              1.0, // This would be the width of the underline
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      '\$ 18000',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(
                                  color: Colors.black,
                                  thickness: 3,
                                  height: 0,
                                ),
                              ],
                            ),
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            '18000',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color:
                                                  ColorConstants.primaryColor2,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          RotatedBox(
                                            quarterTurns: 1,
                                            child: Image.asset(
                                                "assets/tokens.png",
                                                height: 30,
                                                width: 30),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    left: 95,
                                    top: 0,
                                    bottom: 0,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 17,
                                            height: 17,
                                            decoration: BoxDecoration(
                                                color: Colors.yellow,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: Colors.black,
                                                  width: 2,
                                                )),
                                          ),
                                          const Text('+',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                            height: 80,
                            width: 80,
                            child: Image.asset("assets/accountMan.png")),
                      ],
                    ),
                  ),
                  Image.asset('assets/4-2-treasure-picture-thumb.png',
                      height: 130, width: 130),
                  const Text(
                    "No Contest",
                    style: TextStyle(
                        color: Colors.white, fontSize: 25, letterSpacing: 2),
                  ),

                ],
              ),
            ),
          ),
        ),
        Flexible(flex: 1, child: Column()),
      ],
    ));
  }
}
