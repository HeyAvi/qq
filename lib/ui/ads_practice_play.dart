import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qq/ui/home.dart';
import 'package:qq/ui/widgets/text_with_underline.dart';
import 'package:qq/utils/ColorConstants.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:timelines/timelines.dart';

import '../ad_helper.dart';

class PracticePlayAds extends StatefulWidget {
  const PracticePlayAds({Key? key}) : super(key: key);

  @override
  State<PracticePlayAds> createState() => _PracticePlayAdsState();
}

class _PracticePlayAdsState extends State<PracticePlayAds>
    with SingleTickerProviderStateMixin {
  RewardedAd? _rewardedAd;

  bool _isRewardedAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  int _currentIndex = 0;

  void _loadRewardedAd() {
    RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {},
            );
            setState(() {
              _isRewardedAdLoaded = true;
            });
          },
          onAdFailedToLoad: (err) {
            log('Failed to load an interstitial ad: ${err.message}');
            _isRewardedAdLoaded = false;
          },
        ));
    // InterstitialAd.load(
    //   adUnitId: AdHelper.interstitialAdUnitId,
    //   request: const AdRequest(),
    //   adLoadCallback: InterstitialAdLoadCallback(
    //     onAdLoaded: (ad) {
    //       _interstitialAd = ad;
    //       ad.fullScreenContentCallback = FullScreenContentCallback(
    //         onAdDismissedFullScreenContent: (ad) {},
    //       );
    //       _isInterstitialAdReady = true;
    //     },
    //     onAdFailedToLoad: (err) {
    //       log('Failed to load an interstitial ad: ${err.message}');
    //       _isInterstitialAdReady = false;
    //     },
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: _isRewardedAdLoaded
              ? Column(
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
                                          onPressed: () {
                                            if (_isRewardedAdLoaded &&
                                                _currentIndex == 0) {
                                              _rewardedAd?.show(
                                                  onUserEarnedReward:
                                                      (AdWithoutView ad,
                                                          RewardItem reward) {
                                                log('User earned reward: ${reward.type}');
                                                setState(() {
                                                  _currentIndex = 1;
                                                  _loadRewardedAd();
                                                });
                                              });
                                            }
                                          },
                                          child: Text(
                                            _currentIndex > 0
                                                ? 'Watched'
                                                : 'Watch',
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              primary: _currentIndex > 0
                                                  ? ColorConstants.primaryColor2
                                                  : ColorConstants
                                                      .primaryColor),
                                        ),
                                      ),
                                      node: TimelineNode(
                                        indicator: CircleAvatar(
                                            radius: 30,
                                            backgroundColor:
                                                ColorConstants.primaryColor,
                                            child: _currentIndex < 1
                                                ? const Text(
                                                    '1',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  )
                                                : const Icon(Icons.check,
                                                    color: Colors.white)),
                                        endConnector: const SizedBox(
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
                                          onPressed: () {
                                            if (_isRewardedAdLoaded &&
                                                _currentIndex == 1) {
                                              _rewardedAd?.show(
                                                  onUserEarnedReward:
                                                      (AdWithoutView ad,
                                                          RewardItem reward) {
                                                log('User earned reward: ${reward.type}');
                                                setState(() {
                                                  _currentIndex = 2;
                                                  _loadRewardedAd();
                                                });
                                              });
                                            }
                                          },
                                          child: Text(_currentIndex > 1
                                              ? 'Watched'
                                              : 'Watch'),
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              primary: _currentIndex > 1
                                                  ? ColorConstants.primaryColor2
                                                  : ColorConstants
                                                      .primaryColor),
                                        ),
                                      ),
                                      node: TimelineNode(
                                        indicator: CircleAvatar(
                                            radius: 30,
                                            backgroundColor:
                                                ColorConstants.primaryColor,
                                            child: _currentIndex < 2
                                                ? const Text(
                                                    '2',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  )
                                                : const Icon(Icons.check,
                                                    color: Colors.white)),
                                        startConnector:
                                            const SolidLineConnector(
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
                                          onPressed: () {
                                            if (_isRewardedAdLoaded &&
                                                _currentIndex == 2) {
                                              _rewardedAd?.show(
                                                  onUserEarnedReward:
                                                      (AdWithoutView ad,
                                                          RewardItem reward) {
                                                log('User earned reward: ${reward.type}');
                                                setState(() {
                                                  _currentIndex = 3;
                                                });
                                              });
                                            }
                                          },
                                          child: Text(_currentIndex > 2
                                              ? 'Watched'
                                              : 'Watch'),
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              primary: _currentIndex > 2
                                                  ? ColorConstants.primaryColor2
                                                  : ColorConstants
                                                      .primaryColor),
                                        ),
                                      ),
                                      node: TimelineNode(
                                        startConnector: const SizedBox(
                                          height: 50,
                                          child: SolidLineConnector(
                                            color: ColorConstants.primaryColor,
                                          ),
                                        ),
                                        indicator: CircleAvatar(
                                            radius: 30,
                                            backgroundColor:
                                                ColorConstants.primaryColor,
                                            child: _currentIndex < 3
                                                ? const Text(
                                                    '3',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  )
                                                : const Icon(Icons.check,
                                                    color: Colors.white)),
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
                                      if (_currentIndex == 3) {
                                        setState(() {
                                          isChecked = !isChecked;
                                          print(isChecked);
                                        });
                                      } else {
                                        setState(() {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please watch all the videos",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: ColorConstants.primaryColor,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        });
                                      }
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
                                                offset:
                                                    Offset(0.0, 1.0), //(x,y)
                                                blurRadius: 6.0,
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                        AnimatedOpacity(
                                          duration:
                                              const Duration(milliseconds: 200),
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
                                        if (position ==
                                            SlidableButtonPosition.right) {
                                          icon = const Icon(Icons.check);
                                          Fluttertoast.showToast(
                                              msg: 'Will be available Soon!');
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Home(false, false)));
                                        } else {
                                          icon =
                                              const Icon(Icons.navigate_next, color: ColorConstants.primaryColor2,);
                                        }
                                      });
                                    }
                                  : null,
                              height: 40,
                              width: MediaQuery.of(context).size.width / 1.8,
                              dismissible: false,
                              color: isChecked ? ColorConstants.primaryColor2 : Colors.grey[300],
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
                )
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      color: ColorConstants.primaryColor,
                    ),
                    Text(
                      'Preparing ads...',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ))),
    );
  }

  Icon icon = const Icon(
    Icons.navigate_next,
    color: ColorConstants.primaryColor2,
  );

  bool isChecked = false;
}
