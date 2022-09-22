import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qq/ui/widgets/text_with_underline.dart';
import 'package:qq/utils/ColorConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:timelines/timelines.dart';

import '../ad_helper.dart';
import '../bloc/TicketsBloc/TicketsBloc.dart';
import '../dataproviders/TicketsProvider.dart';
import '../models/Ticketdata.dart';
import '../repository/TicketsRepository.dart';
import '../services/ContestServcie.dart';
import '../services/ServicesLocator.dart';
import 'ContestDetails/ContestMainPage.dart';

class PracticePlayAds extends StatelessWidget {
  final List<Ticketdata>? ticketDataList;

  const PracticePlayAds({Key? key, this.ticketDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => TicketsBloc(TicketsRepository(Dio())),
        child: PracticePlay(
          ticketDataList: ticketDataList,
        ),
      ),
    );
  }
}

class PracticePlay extends StatefulWidget {
  final List<Ticketdata>? ticketDataList;

  const PracticePlay({Key? key, this.ticketDataList}) : super(key: key);

  @override
  State<PracticePlay> createState() => _PracticePlayState();
}

class _PracticePlayState extends State<PracticePlay>
    with SingleTickerProviderStateMixin {
  RewardedAd? _rewardedAd;
  String userId = '';

  bool _isRewardedAdLoaded = false;

  @override
  void initState() {
    super.initState();
    ticketDataList = widget.ticketDataList;
    getSharedPreferencesData();
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
  }

  List<Ticketdata>? ticketDataList;
  ContestExampleService contestExampleService = getIt<ContestExampleService>();

  Future<void> getSharedPreferencesData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId").toString();
    print('userId: ' + userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: _isRewardedAdLoaded
              ? BlocListener<TicketsBloc, TicketsState>(
                  listener: (context, state) {
                    if (state is TicketsCompleteState) {
                      setState(() {
                        ticketDataList = state.ticketDataList;
                      });
                      print(' ticket ${state.ticketDataList}');
                      if (state.contestUserSubmit) {
                        print(
                            'contest user submit from ads ${state.contestUserSubmit}');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContestMainPage(
                              contestExampleService: contestExampleService,
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey[300],
                          child: IconButton(
                            iconSize: 16,
                            color: Colors.grey[700],
                            icon: const Icon(
                              Icons.close,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                backgroundColor:
                                                    _currentIndex > 0
                                                        ? ColorConstants
                                                            .primaryColor2
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
                                              color:
                                                  ColorConstants.primaryColor,
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
                                                backgroundColor:
                                                    _currentIndex > 1
                                                        ? ColorConstants
                                                            .primaryColor2
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
                                          endConnector: const SizedBox(
                                            height: 50,
                                            child: SolidLineConnector(
                                              color:
                                                  ColorConstants.primaryColor,
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
                                                backgroundColor:
                                                    _currentIndex > 2
                                                        ? ColorConstants
                                                            .primaryColor2
                                                        : ColorConstants
                                                            .primaryColor),
                                          ),
                                        ),
                                        node: TimelineNode(
                                          startConnector: const SizedBox(
                                            height: 50,
                                            child: SolidLineConnector(
                                              color:
                                                  ColorConstants.primaryColor,
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
                                                backgroundColor:
                                                    ColorConstants.primaryColor,
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
                                            duration: const Duration(
                                                milliseconds: 200),
                                            opacity: isChecked ? 1.0 : 0.0,
                                            child: const Icon(
                                              Icons.check,
                                              color:
                                                  ColorConstants.primaryColor,
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
                                onChanged: true
                                    ? (position) {
                                        setState(() {
                                          if (position ==
                                              SlidableButtonPosition.right) {
                                            icon = const Icon(Icons.check);
                                            BlocProvider.of<TicketsBloc>(
                                                    context)
                                                .add(SubmitContextUserEvent(
                                                    context: context,
                                                    userId: userId,
                                                    contestId:
                                                        contestExampleService
                                                            .contestdata!
                                                            .contest_id,
                                                    ticketDataList:
                                                        ticketDataList,
                                                    status: Status.P));
                                          } else {
                                            icon = const Icon(
                                              Icons.navigate_next,
                                              color:
                                                  ColorConstants.primaryColor2,
                                            );
                                          }
                                        });
                                      }
                                    : null,
                                height: 40,
                                width: MediaQuery.of(context).size.width / 1.8,
                                dismissible: false,
                                color: isChecked
                                    ? ColorConstants.primaryColor2
                                    : Colors.grey[300],
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
