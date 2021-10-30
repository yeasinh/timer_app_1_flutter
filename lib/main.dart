import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work Timer',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Work Timer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CountDownController _controller = CountDownController();
  AudioPlayer audioPlayer = AudioPlayer();

  late int _duration = 10;

  bool _isWorkPressed = false;
  bool _isLongPressed = false;
  bool _isShortPressed = false;

  bool _hasStarted = false;
  bool _isPaused = false;

  int workTime = 60 * 60;
  int longTime = 20 * 60;
  int shortTime = 10 * 60;

  void startPressed() {
    setState(() {
      if (_isWorkPressed) {
        _duration = workTime;
      } else if (_isLongPressed) {
        _duration = longTime;
      } else if (_isShortPressed) {
        _duration = shortTime;
      } else {
        print('');
      }
    });

    setState(() {
      _isWorkPressed = false;
      _isLongPressed = false;
      _isShortPressed = false;

      if (!_hasStarted) {
        _controller.start();
        _hasStarted = true;
      } else {
        _controller.restart();
        _hasStarted = false;
      }
    });
  }

  void stopPressed() {
    setState(() {
      _isWorkPressed = false;
      _isLongPressed = false;
      _isShortPressed = false;

      if (!_isPaused) {
        _controller.pause();
        _isPaused = true;
      } else {
        _controller.resume();
        _isPaused = false;
      }
    });
  }

  void workPressed() {
    setState(() {
      _isWorkPressed = true;
      _isLongPressed = false;
      _isShortPressed = false;
      _duration = workTime;
    });
  }

  void longPressed() {
    setState(() {
      _isWorkPressed = false;
      _isLongPressed = true;
      _isShortPressed = false;
    });
  }

  void shortPressed() {
    setState(() {
      _isWorkPressed = false;
      _isLongPressed = false;
      _isShortPressed = true;
    });
  }

  playAudio() {
    playLocal() async {
      int result = await audioPlayer.play('assets/song.mp3', isLocal: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    workPressed();
                    print(_duration);
                  },
                  child: const Text(
                    'Work Time',
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.deepPurple),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    shortPressed();
                  },
                  child: const Text(
                    'Short Break',
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.indigo),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    longPressed();
                  },
                  child: const Text(
                    'Long Break',
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.teal),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                ),
              ],
            ),
            // CircularCountDownTimer(
            //   duration: _duration,
            //   initialDuration: _duration,
            //   controller: _controller,
            //   width: MediaQuery.of(context).size.width / 2,
            //   height: MediaQuery.of(context).size.height / 2,
            //   ringColor: (Colors.grey[300])!,
            //   ringGradient: null,
            //   fillColor: Colors.deepOrange,
            //   fillGradient: null,
            //   backgroundColor: Colors.white,
            //   backgroundGradient: null,
            //   strokeWidth: 10.0,
            //   strokeCap: StrokeCap.round,
            //   textStyle: const TextStyle(
            //       fontSize: 30.0,
            //       color: Colors.black,
            //       fontWeight: FontWeight.bold),
            //   textFormat: CountdownTextFormat.HH_MM_SS,
            //   isReverse: true,
            //   isReverseAnimation: false,
            //   isTimerTextShown: true,
            //   autoStart: false,
            //   onStart: () {
            //     // print('Countdown Started');
            //   },
            //   onComplete: () {
            //     // playAudio();
            //     // Alert(
            //     //     context: context,
            //     //     title: 'Done',
            //     //     style: const AlertStyle(
            //     //       isCloseButton: true,
            //     //       isButtonVisible: false,
            //     //       titleStyle: TextStyle(
            //     //         color: Colors.white,
            //     //         fontSize: 30.0,
            //     //       ),
            //     //     ),
            //     //     type: AlertType.success
            //     // ).show();
            //   },
            // ),
            Stack(
              children: [
                CircularProgressIndicator(
                  value: _duration.toDouble(),
                ),
                CountdownTimer(
                  endTime: _duration,
                  onEnd: () {},
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.extended(
                  onPressed: () {
                    startPressed();
                  },
                  icon: Icon(_hasStarted
                      ? Icons.subdirectory_arrow_left
                      : Icons.check),
                  label: Text(_hasStarted ? 'Restart' : 'Start'),
                  backgroundColor: Colors.green[800],
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    stopPressed();
                  },
                  icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                  label: Text(_isPaused ? 'Resume' : 'Pause'),
                  backgroundColor: Colors.red[800],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
