import 'package:flutter/material.dart';
import 'package:qq/ui/widgets/text_with_underline.dart';
import 'package:qq/utils/ColorConstants.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:timelines/timelines.dart';

class PracticePlayAds extends StatefulWidget {
  const PracticePlayAds({Key? key}) : super(key: key);

  @override
  State<PracticePlayAds> createState() => _PracticePlayAdsState();
}

class _PracticePlayAdsState extends State<PracticePlayAds>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[300],
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey[700],
                    size: 18,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Step Required',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.primaryColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'watch ads to join practice play',
                    // style: TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //     color: ColorConstants.primaryColor),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TimelineTile(
                              // nodeAlign: TimelineNodeAlign.start,
                              contents: Padding(
                                padding: const EdgeInsets.all(25),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Watch'),
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      primary: ColorConstants.primaryColor),
                                ),
                              ),
                              node: const TimelineNode(
                                indicator: CircleAvatar(
                                    radius: 30,
                                    backgroundColor:
                                        ColorConstants.primaryColor,
                                    child:
                                        Icon(Icons.check, color: Colors.white)),
                                endConnector: SizedBox(
                                  height: 50,
                                  child: SolidLineConnector(
                                    color: ColorConstants.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            TimelineTile(
                              // nodeAlign: TimelineNodeAlign.start,
                              oppositeContents: Padding(
                                padding: const EdgeInsets.all(25),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Watch'),
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      primary: ColorConstants.primaryColor),
                                ),
                              ),
                              node: const TimelineNode(
                                indicator: CircleAvatar(
                                    radius: 30,
                                    backgroundColor:
                                        ColorConstants.primaryColor,
                                    child:
                                        Icon(Icons.check, color: Colors.white)),
                                startConnector: SolidLineConnector(
                                  color: ColorConstants.primaryColor,
                                ),
                                endConnector: SizedBox(
                                  height: 50,
                                  child: SolidLineConnector(
                                    color: ColorConstants.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            TimelineTile(
                              // nodeAlign: TimelineNodeAlign.start,
                              contents: Padding(
                                padding: const EdgeInsets.all(25),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Watch'),
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      primary: ColorConstants.primaryColor),
                                ),
                              ),
                              node: const TimelineNode(
                                startConnector: SizedBox(
                                  height: 50,
                                  child: SolidLineConnector(
                                    color: ColorConstants.primaryColor,
                                  ),
                                ),
                                indicator: CircleAvatar(
                                    radius: 30,
                                    backgroundColor:
                                        ColorConstants.primaryColor,
                                    child:
                                        Icon(Icons.check, color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'before you join read carefully',
                  ),
                  const TextWithUnderline(
                    text: 'Terms & Conditions',
                    textColor: ColorConstants.primaryColor,
                    borderColor: ColorConstants.primaryColor,
                    underlineHeight: 0.5,
                    lineHeight: 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isChecked = !isChecked;
                                print(isChecked);
                              });
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 30,
                                  margin: const EdgeInsets.only(
                                      bottom: 3.0, right: 2.0),
                                  height: 30,
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[300],
                                  ),
                                ),
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 200),
                                  opacity: isChecked ? 1.0 : 0.0,
                                  child: const Icon(
                                    Icons.check,
                                    color: ColorConstants.primaryColor,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        'i Agree.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: SlidableButton(
                      tristate: true,
                      onChanged: isChecked
                          ? (position) {
                              setState(() {
                                if (position == SlidableButtonPosition.right) {
                                  icon = const Icon(Icons.check);
                                } else {
                                  icon = const Icon(Icons.navigate_next);
                                }
                              });
                            }
                          : null,
                      height: 40,
                      width: MediaQuery.of(context).size.width / 1.8,
                      dismissible: false,
                      color: ColorConstants.primaryColor2,
                      label: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 18,
                          child: icon),
                      child: const Center(
                        child: Text(
                          'Swipe to Enter',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Icon icon = const Icon(
    Icons.navigate_next,
    color: ColorConstants.primaryColor2,
  );

  bool isChecked = false;
}
