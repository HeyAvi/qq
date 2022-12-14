
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:qq/ui/BottomNavigationWidget.dart';
import 'package:qq/ui/profile_screen.dart';
import 'package:qq/ui/home.dart';
import 'package:qq/ui/notificationScreen.dart';
import 'package:qq/ui/termsAndCondition.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerSupport extends StatefulWidget {
  const CustomerSupport({Key? key}) : super(key: key);

  @override
  _CustomerSupportState createState() => _CustomerSupportState();
}

class _CustomerSupportState extends State<CustomerSupport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },

            icon: Icon(Icons.arrow_back, color: Colors.white, size: 30,),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(


            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.asset('assets/support.png', color: Colors.green,)
                ),


                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Text("Customer Support"
                  , textAlign: TextAlign.center, style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold
                  ),),

                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Text("In case of any query, please contact us"
                  , textAlign: TextAlign.center, style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold
                  ),),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Text("Email will be sent to"
                  , textAlign: TextAlign.center, style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.normal
                  ),),
                Padding(
                  padding: EdgeInsets.all(2),
                ),
                InkWell(
                  child: Text("email123@gmail.com"
                    , textAlign: TextAlign.center, style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold
                    ),),

                  onTap: (){
                    setState(() {
                      _makePhoneCall('mailto:email123@gmail.com');
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Text("Or call us at"
                  , textAlign: TextAlign.center, style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.normal
                  ),),
                Padding(
                  padding: EdgeInsets.all(2),
                ),
                InkWell(
                  child: Text("9123456789"
                    , textAlign: TextAlign.center, style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold
                    ),),

                  onTap: () {
                    setState(() {
                      _makePhoneCall('tel:9123456789');
                    });
                  },
                ),


                Padding(
                  padding: EdgeInsets.all(100),
                ),


              ],
            ),


          ),
        ),
        bottomNavigationBar:  BottomNavigationWidget(1)
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}