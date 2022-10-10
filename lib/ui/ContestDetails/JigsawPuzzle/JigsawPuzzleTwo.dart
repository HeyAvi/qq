import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qq/bloc/ContestBloc/ContestBloc.dart';
import 'package:qq/models/ParentContestQuestiondata.dart';
import 'package:qq/services/ContestServcie.dart';
import 'package:qq/services/ServicesLocator.dart';
import 'package:qq/ui/ContestDetails/JigsawPuzzle/CorrectOverlay.dart';
import 'package:qq/ui/ContestDetails/JigsawPuzzle/PuzzlePiece.dart';
import 'package:qq/ui/ContestDetails/JigsawPuzzle/ScoreWidget.dart';
import 'package:qq/utils/ApiConstants.dart';
import 'package:qq/utils/ColorConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

const IMAGE_PATH = 'image_path';

class JigsawPuzzleTwo extends StatefulWidget {
  Map<String, dynamic>? dynamicContent;
  final VoidCallback onIndexChanged;
  List<ParentContestQuestiondata>? contestQuestiondataDataLists;
  int? indexs;
  final ContestExampleService? contestExampleService;

  JigsawPuzzleTwo(
    Map<String, dynamic>? _dynamicContent,
    List<ParentContestQuestiondata>? contestQuestiondataDataList,
    int index, {
    Key? key,
    required this.onIndexChanged,
    required this.contestExampleService,
  }) : super(key: key) {
    dynamicContent = _dynamicContent;
    contestQuestiondataDataLists = contestQuestiondataDataList;
    indexs = index;
  }

  @override
  _JigsawPuzzleTwoState createState() => _JigsawPuzzleTwoState();
}

class _JigsawPuzzleTwoState extends State<JigsawPuzzleTwo> {
  File? _image;
  String? _imagePath;
  List<Widget> pieces = [];
  late SharedPreferences prefs;
  final int rows = 3;
  final int cols = 3;
  String imageUrl = "";
  Uint8List? bytes;

  late File file;
  ContestService contestService = getIt<ContestService>();

  int _start = 7200;
  int seconds = 0;
  late Timer _timer;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
            seconds++;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    imageUrl = ApiConstants.IMAGE_URL + widget.dynamicContent!["content"];
    downloadImage();
    startTimer();
  }

  void downloadImage() async {
    try {
      final ByteData imageData =
          await NetworkAssetBundle(Uri.parse(imageUrl)).load("");
      bytes = imageData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      file = await File('${tempDir.path}/image.png').create();
      file.writeAsBytesSync(bytes!);
      _image = File(file.path);
      _imagePath = _image!.path;
      pieces.clear();
      if (mounted) {
        ScoreWidget.of(context).allInPlaceCount = 0;
        setState(() {});
      }
      splitImage(Image.file(file));
    } on PlatformException catch (error) {
      print(error);
    }
  }

  // we need to find out the image size, to be used in the PuzzlePiece widget
  Future<Size> getImageSize(Image image) async {
    final Completer<Size> completer = Completer<Size>();

    image.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(
          Size(info.image.width.toDouble(), info.image.height.toDouble()));
    }));

    final Size imageSize = await completer.future;

    return imageSize;
  }

  // here we will split the image into small pieces
  // using the rows and columns defined above; each piece will be added to a stack
  void splitImage(Image image) async {
    Size imageSize = await getImageSize(image);

    for (int x = 0; x < rows; x++) {
      for (int y = 0; y < cols; y++) {
        if (mounted) {
          setState(() {
            pieces.add(
              PuzzlePiece(
                key: GlobalKey(),
                image: image,
                imageSize: imageSize,
                row: x,
                col: y,
                maxRow: rows,
                maxCol: cols,
                bringToTop: bringToTop,
                sendToBack: sendToBack,
              ),
            );
          });
        }
      }
    }
  }

  // when the pan of a piece starts, we need to bring it to the front of the stack
  void bringToTop(Widget widget) {
    if (mounted) {
      setState(() {
        pieces.remove(widget);
        pieces.add(widget);
      });
    }
  }

// when a piece reaches its final position,
// it will be sent to the back of the stack to not get in the way of other, still movable, pieces
  void sendToBack(Widget widget) {
    if (mounted) {
      setState(() {
        pieces.remove(widget);
        pieces.insert(0, widget);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isAnswerTrue;
    return Scaffold(
      backgroundColor: Colors.white,
        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // clipBehavior: Clip.antiAliasWithSaveLayer,
                height: 400,
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: _image == null
                    ? const Center(child: Text(''))
                    : ScoreWidget.of(context).allInPlaceCount == rows * cols
                        ? Overlay(
                            initialEntries: [
                              OverlayEntry(builder: (context) {
                                //widget.onIndexChanged();
                                return CorrectOverlay(true, () {
                                  if (mounted) {
                                    setState(() {
                                      ScoreWidget.of(context).allInPlaceCount = 0;
                                    });
                                  }
                                });
                              })
                            ],
                          )
                        : Stack(
                            children: pieces,
                          ),
              ),
            )),
        floatingActionButton: Row(children: [
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 80,
              ),
              SizedBox(
                width: 150,
                child: FloatingActionButton.extended(
                  backgroundColor: ColorConstants.primaryColor3,
                  onPressed: () {
                    isAnswerTrue = (ScoreWidget.of(context).allInPlaceCount ==
                        rows * cols);
                    BlocProvider.of<ContestBloc>(context).add(
                        SubmitQuestionDataEvent(
                            context: context,
                            contestId: widget.contestExampleService?.contestdata
                                    ?.contest_id ??
                                contestService.contestdata!.contest_id,
                            // todo check here
                            questionId: widget.dynamicContent!["question_id"],
                            answerGiven: "yes",
                            isAnswerTrue: isAnswerTrue.toString(),
                            moves: "1",
                            timeTaken: seconds.toString(),
                            contestQuestiondataDataList:
                                widget.contestQuestiondataDataLists,
                            currentIndex: widget.indexs!));
                  },
                  heroTag: null,
                  label: const Text("SUBMIT"),
                ),
              )
            ],
          )),
          FloatingActionButton(
            backgroundColor: ColorConstants.primaryColor3,
            child: const Icon(Icons.image),
            onPressed: () {
              showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Image.network(imageUrl);
                  });
            },
            heroTag: null,
          ),
        ]));
  }
}
