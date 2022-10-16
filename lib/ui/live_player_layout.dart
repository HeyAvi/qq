import 'package:flutter/material.dart';
import 'package:qq/ui/widgets/text_with_underline.dart';

class LivePlayerLayout extends StatefulWidget {
  const LivePlayerLayout({Key? key}) : super(key: key);

  @override
  State<LivePlayerLayout> createState() => _LivePlayerLayoutState();
}

class _LivePlayerLayoutState extends State<LivePlayerLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              Card(
                color: Colors.black87,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('7/10',
                          style:
                          TextStyle(color: Colors.yellow, fontSize: 18)),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Winners',
                          style: TextStyle(color: Colors.white)),
                      const SizedBox(
                        width: 20,
                      ),
                      Card(
                        color: Colors.red[700],
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(2.0),
                                child: CircleAvatar(
                                  radius: 3,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              Text('Live',
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: TextWithUnderline(text: '450,000'),
                      )
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/puzzleImage1.jpeg'),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/puzzleImage1.jpeg'),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/puzzleImage1.jpeg'),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/puzzleImage1.jpeg'),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/puzzleImage1.jpeg'),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/puzzleImage1.jpeg'),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/puzzleImage1.jpeg'),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/puzzleImage1.jpeg'),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/puzzleImage1.jpeg'),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/puzzleImage1.jpeg'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
