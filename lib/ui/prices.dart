import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qq/ui/home.dart';

class Prices extends StatefulWidget {
  late String _winnerZone;

  Prices(String winnerZone) {
    _winnerZone = winnerZone;
  }

  @override
  _PricesState createState() => _PricesState();
}

class _PricesState extends State<Prices> {
  var parsedListJson;
  String key1 = " ", value1 = "";
  double sum = 0.0;

  @override
  void initState() {
    super.initState();
    print(widget._winnerZone.toString());
    parsedListJson = jsonDecode(widget._winnerZone) as List;
    for (int i = 0; i < parsedListJson.length; i++) {
      Map map = parsedListJson[i];
      map.forEach((key, value) {
        value1 = value;
      });
      sum = sum + double.parse(value1);
    }
  }

  Future<bool> _willPopCallback() async {
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.h),
              child: AppBar(
                backgroundColor: Color(0xffEDEDF0),
                elevation: 0,
                automaticallyImplyLeading: false,
                title: Container(
                  width: MediaQuery.of(context).size.width.w,
                  padding: EdgeInsets.only(left: 10.w),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (Context) => Home(false, false)));
                        },
                        child: ImageIcon(
                          AssetImage(
                            "assets/left-arrow.png",
                          ),
                          color: Colors.black,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Flexible(
                        child: Text(
                          "Prices",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                            color: Color(0xff3E3C3C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                leadingWidth: MediaQuery.of(context).size.width.w,
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // First blue container
                _buildTopContainer(),
                // Button with offset
                _buildMidContainerWithButton(),
                // Bottom white container
                _buildBottomContainer(),
              ],
            )),
        onWillPop: _willPopCallback);
  }

  Widget _buildTopContainer() => Flexible(
        flex: 6,
        child: Container(
          color: Color(0xffEDEDF0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 10,
                shadowColor: Color(0xffF1D109),
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(150.0),
                  ),
                ),
                child: CircleAvatar(
                  radius: 110.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Image.asset("assets/coinsDropping.png"),
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
              SizedBox(
                height: 30.h,
              )
            ],
          ),
        ),
      );

  Widget _buildMidContainerWithButton() {
    final buttonHeight = 55.h;
    return Stack(
      children: [
        // Use same background color like the second container
        Container(height: buttonHeight, color: Colors.white),
        // Translate the button
        Transform.translate(
          offset: Offset(0.0, -buttonHeight / 2.0),
          child: Center(
            child: GestureDetector(
              onTap: () {/* do stuff */},
              child: Container(
                height: buttonHeight,
                width: 250.w,
                decoration: BoxDecoration(
                  color: Color(0xffF9FBF9),
                  borderRadius: BorderRadius.circular(buttonHeight / 2.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 16.0,
                      offset: Offset(0.0, 6.0),
                      color: Colors.black.withOpacity(0.16),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(24.0, 3.0, 24.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/rupeeSingleCoin.png",
                      height: 38,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(
                      'Rs. ' + sum.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomContainer() => Flexible(
        flex: 7,
        child: Container(
          color: Colors.white,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        "Top Players",
                        style: TextStyle(
                            color: Color(0xffAFB0B4),
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        "Reward",
                        style: TextStyle(
                            color: Color(0xffAFB0B4),
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: parsedListJson.length,
                itemBuilder: (BuildContext context, int index) {
                  key1 = " ";
                  value1 = "";
                  Map map = parsedListJson[index];
                  map.forEach((key, value) {
                    key1 = key;
                    value1 = value;
                  });
                  return InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      width: 60.w,
                                      height: 60.w,
                                      child: Image.asset(
                                        "assets/1stTag.png",
                                        width: 60.w,
                                      ),
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    key1,
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(0.h)),
                                Expanded(
                                    child: Row(
                                  children: [
                                    Text(
                                      "Rs. " + value1,
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Padding(padding: EdgeInsets.all(5.h)),
                                    Image.asset(
                                      "assets/rupeeCash.png",
                                      width: 40.w,
                                    )
                                  ],
                                )),
                                Padding(padding: EdgeInsets.all(5.h)),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5.h),
                              width:
                                  MediaQuery.of(context).size.width.w - 100.w,
                              color: Colors.grey,
                              height: 2.h,
                            )
                          ],
                        ),
                      ));
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "First",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal),
                ),
                Text(
                  " 1000",
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.normal),
                ),
                Text(
                  " Rankers's get",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.normal),
                ),
                Text(
                  " 10Rs",
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.green,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ]),
        ),
      );
}
