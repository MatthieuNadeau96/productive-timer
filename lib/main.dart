import 'dart:async';
import 'dart:math' as math show pi;
import 'package:flutter/material.dart';
import './counters.dart';
import './header_button.dart';
import './playButton.dart';
import './playButtonPressed.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Color(0xffECF0F3),
        primaryColor: Color(0xff3372F7),
        textTheme: TextTheme(
          title: TextStyle(
            color: Color(0xff2C2C2C),
          ),
        ),
        iconTheme: IconThemeData(
          color: Color(0xff7D839A),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController controller;
  bool isPlaying = false;
  bool muted = false;
  bool notificationsOff = false;

  int workTime = 1200;
  int breakTime = 300;
  int longBreakTime = 1500;
  int completedWork = 1;
  int testWorkTime = 5;
  int currentMode = 5;
  int _start = 10;
  Timer _timer;
  bool paused = false;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            isPlaying = false;
            timer.cancel();
          } else if (paused) {
            timer.cancel();
            paused = false;
          } else {
            isPlaying = true;
            _start = _start - 1;
          }
        },
      ),
    );
  }

  void pauseTimer() {
    setState(() {
      isPlaying = false;
      paused = true;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffEEF2F4),
            themeData.canvasColor,
            Color(0xffD4D8DB),
            Color(0xffBDC0C3),
          ],
          stops: [0.1, 0.3, 0.8, 1],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                Row(
                  // Header
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    HeaderButton(
                      toggleHandler: muted,
                      onPress: () {
                        setState(() {
                          muted = !muted;
                        });
                      },
                      icon: muted
                          ? Icon(
                              Icons.volume_off,
                              size: 20,
                            )
                          : Icon(
                              Icons.volume_up,
                              size: 20,
                            ),
                    ),
                    Text(
                      'Pomodoro',
                      style: TextStyle(
                        color: themeData.textTheme.title.color,
                        fontSize: 30,
                      ),
                    ),
                    HeaderButton(
                      toggleHandler: notificationsOff,
                      onPress: () {
                        setState(() {
                          notificationsOff = !notificationsOff;
                        });
                      },
                      icon: notificationsOff
                          ? Icon(
                              Icons.notifications_off,
                              size: 20,
                            )
                          : Icon(
                              Icons.notifications_active,
                              size: 20,
                            ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                // Countdown Timer
                Container(
                  height: 275,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.all(Radius.circular(200)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffA5A8AB),
                        offset: Offset(4.0, 4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      ),
                      BoxShadow(
                        color: Color(0xffffffff),
                        offset: Offset(-4.0, -4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xffEEF2F4),
                        themeData.canvasColor,
                        Color(0xffD4D8DB),
                        Color(0xffBDC0C3),
                      ],
                      stops: [0.1, 0.3, 0.8, 1],
                    ),
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: Center(
                    child: Text(
                      '$_start',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Work',
                  style: TextStyle(fontSize: 24),
                ),
                Container(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      (completedWork >= 1
                          ? Counters(completed: true)
                          : Counters(
                              completed: false,
                            )),
                      (completedWork >= 2
                          ? Counters(completed: true)
                          : Counters(
                              completed: false,
                            )),
                      (completedWork >= 3
                          ? Counters(completed: true)
                          : Counters(
                              completed: false,
                            )),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                // Play Pause Button
                Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          child: isPlaying
                              ? PlayButtonPressed(
                                  icon: Icon(
                                    Icons.pause,
                                  ),
                                )
                              : PlayButton(
                                  icon: Icon(Icons.play_arrow),
                                ),
                          onTap: () {
                            isPlaying ? pauseTimer() : startTimer();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
