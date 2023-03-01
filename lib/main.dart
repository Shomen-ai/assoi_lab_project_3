import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Измерение температуры термопреобразователями сопротивления',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(
          title: 'Измерение температуры термопреобразователями сопротивления'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Variables for timer
  int seconds = 0, minutes = 20, hours = 0, bufSeconds = 0;
  String digitSeconds = "00", digitMinutes = "20", digitHours = "00";
  Timer? timer;
  bool started = false;
  List laps = [];
  int pressed = 0;
  bool heatState = false;

  // stop function for timer
  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  // reset function for timer
  void reset() {
    timer!.cancel();
    setState(() {
      seconds = 0;
      minutes = 20;
      hours = 0;

      digitSeconds = "00";
      digitMinutes = "20";
      digitHours = "00";

      started = false;
      laps = [];
    });
  }

  // add laps function for timer
  void addLaps() {
    String lap = "$digitHours:$digitMinutes:$digitSeconds";
    setState(() {
      laps.add(lap);
    });
  }

  // start function for timer
  void start(int duration) {
    started = true;
    timer = Timer.periodic(Duration(milliseconds: duration), (timer) {
      int localSeconds = seconds + 1;
      int localMinutes = minutes;
      int localHours = hours + duration;

      if (localSeconds > 9) {
        localMinutes++;
        localSeconds = 0;
      }

      if (localMinutes == 41 && localSeconds == 0) {
        myDuration = 57000;
        myHeight = 81;
        stop();
        start(600);
      }
      if (localMinutes == 50 && localSeconds == 5) {
        myDuration = 73500;
        myHeight = 48;
        stop();
        start(700);
      }
      if (localMinutes == 61 && localSeconds == 0) {
        myDuration = 88000;
        myHeight = 15;
        stop();
        start(800);
      }
      if (localMinutes == 72 && localSeconds == 0) {
        myDuration = 8000;
        myHeight = 7;
        stop();
        buf_timer();
      }

      setState(() {
        seconds = localSeconds;
        minutes = localMinutes;
        hours = localHours;
        digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
        digitHours = (hours >= 10) ? "$hours" : "0$hours";
      });
    });
  }

  void countdown(int duration) {
    started = true;
    timer = Timer.periodic(Duration(milliseconds: duration), (timer) {
      int localSeconds = seconds;
      int localMinutes = minutes;
      int localHours = hours + duration;

      if (localSeconds == 0) {
        localMinutes--;
        localSeconds = 9;
      } else {
        localSeconds--;
      }
      if (localMinutes == 20 && localSeconds == 0) {
        stop();
      }

      if (localMinutes == 41 && localSeconds == 5) {
        myDuration = 105000;
        myHeight = 180;
        stop();
        countdown(500);
      }
      if (localMinutes == 52 && localSeconds == 0) {
        myDuration = 57000;
        myHeight = 114;
        stop();
        countdown(500);
      }
      if (localMinutes == 61 && localSeconds == 0) {
        myDuration = 73500;
        myHeight = 81;
        stop();
        countdown(600);
      }
      if (localMinutes == 71 && localSeconds == 5) {
        myDuration = 88000;
        myHeight = 48;
        stop();
        countdown(700);
      }

      setState(() {
        seconds = localSeconds;
        minutes = localMinutes;
        hours = localHours;
        digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
        digitHours = (hours >= 10) ? "$hours" : "0$hours";
      });
    });
  }

  void buf_timer() {
    started = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int bufSecondsTimer = bufSeconds + 1;
      if (bufSecondsTimer == 8) {
        myHeight = 15;
        myDuration = 8000;
        pressed = 1;
        heatState = false;
        stop();
        countdown(800);
      }
      setState(() {
        bufSeconds = bufSecondsTimer;
      });
    });
  }

  double myHeight = 180;
  int myDuration = 105000;

//180 105000
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lab_stand
            SizedBox(
              height: 1000.0,
              width: 1100.0,
              child: Stack(
                children: [
                  // кнопка старт
                  Positioned(
                    right: 50,
                    bottom: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green)),
                        onPressed: () {
                          if (pressed == 0) {
                            myHeight = 114;
                            pressed = 1;
                            heatState = true;
                            return start(500);
                          }
                        },
                        child: const Text(
                          "СТАРТ",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  // ОВЕН ТРМ 201
                  Positioned(
                      left: 50,
                      top: 100,
                      child: Container(
                        height: 300,
                        width: 300,
                        color: Colors.black,
                      )),
                  Positioned(
                      left: 60,
                      top: 110,
                      child: Container(
                        height: 250,
                        width: 280,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white)),
                      )),
                  Positioned(
                      left: 70,
                      top: 120,
                      child: Container(
                        height: 55,
                        width: 220,
                        color: const Color(0xFF800b0b),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "$digitMinutes.$digitSeconds",
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 48.0,
                                fontFamily: 'LCDNova'),
                          ),
                        ),
                      )),
                  Positioned(
                      left: 60,
                      top: 365,
                      child: SizedBox(
                        height: 30,
                        width: 280,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "ТРМ 201",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "ОВЕН",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )),

                  // ОВЕН БП14-Д4
                  Positioned(
                      left: 50,
                      top: 500,
                      child: Container(
                        height: 320,
                        width: 300,
                        color: Colors.black,
                      )),
                  // white strokes
                  Positioned(
                      left: 50,
                      top: 540,
                      child: Container(
                        height: 1,
                        width: 300,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white)),
                      )),
                  Positioned(
                      left: 50,
                      top: 570,
                      child: Container(
                        height: 1,
                        width: 300,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white)),
                      )),
                  // + - и выход
                  const Positioned(
                      left: 64.5,
                      top: 500,
                      child: Text(
                        "-    +",
                        style: TextStyle(color: Colors.white),
                      )),
                  const Positioned(
                      left: 137,
                      top: 500,
                      child: Text(
                        "-    +",
                        style: TextStyle(color: Colors.white),
                      )),
                  const Positioned(
                      left: 233,
                      top: 500,
                      child: Text(
                        "-    +",
                        style: TextStyle(color: Colors.white),
                      )),
                  const Positioned(
                      left: 305,
                      top: 500,
                      child: Text(
                        "-    +",
                        style: TextStyle(color: Colors.white),
                      )),
                  const Positioned(
                      left: 60,
                      top: 545,
                      child: Text(
                        "ВЫХОД 1",
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      )),
                  const Positioned(
                      left: 135,
                      top: 545,
                      child: Text(
                        "ВЫХОД 2",
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      )),
                  const Positioned(
                      left: 205,
                      top: 545,
                      child: Text(
                        "ВЫХОД 3",
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      )),
                  const Positioned(
                      left: 280,
                      top: 545,
                      child: Text(
                        "ВЫХОД 4",
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      )),
                  // holes
                  Positioned(
                    top: 520,
                    left: 60,
                    child: Container(
                      width: 280,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // green lamps
                  Positioned(
                      left: 60,
                      top: 620,
                      child: Container(
                        height: 15,
                        width: 15,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.green),
                      )),
                  Positioned(
                      left: 135,
                      top: 620,
                      child: Container(
                        height: 15,
                        width: 15,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.green),
                      )),
                  Positioned(
                      left: 250,
                      top: 620,
                      child: Container(
                        height: 15,
                        width: 15,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.green),
                      )),
                  Positioned(
                      left: 320,
                      top: 620,
                      child: Container(
                        height: 15,
                        width: 15,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.green),
                      )),
                  // holes and white strokes
                  Positioned(
                      left: 50,
                      top: 740,
                      child: Container(
                        height: 1,
                        width: 300,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white)),
                      )),
                  Positioned(
                    top: 790,
                    left: 60,
                    child: Container(
                      width: 280,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white30),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      left: 50,
                      top: 780,
                      child: Container(
                        height: 1,
                        width: 300,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white)),
                      )),
                  // Text (Овен + БП14-Д4 + СЕТЬ + вертикальные палочки)
                  const Positioned(
                      left: 165,
                      top: 612.5,
                      child: Text(
                        "ОВЕН",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      )),
                  const Positioned(
                      left: 60,
                      top: 712.5,
                      child: Text(
                        "БП14-Д4",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      )),
                  const Positioned(
                      left: 280,
                      top: 750,
                      child: Text(
                        "     СЕТЬ\n-90...264В",
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      )),
                  Positioned(
                      top: 805,
                      left: 332,
                      child: Container(
                        width: 1,
                        height: 15,
                        decoration: const BoxDecoration(color: Colors.white),
                      )),
                  Positioned(
                      top: 805,
                      left: 308,
                      child: Container(
                        width: 1,
                        height: 15,
                        decoration: const BoxDecoration(color: Colors.white),
                      )),

                  // ОВЕН НТП-1
                  Positioned(
                      top: 100,
                      left: 450,
                      child: Container(
                        height: 300,
                        width: 100,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: Colors.white),
                      )),
                  Positioned(
                      top: 150,
                      left: 450,
                      child: Container(
                          height: 200, width: 100, color: Colors.teal)),

                  Positioned(
                      top: 110,
                      left: 455,
                      child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              border: Border.all(color: Colors.black)))),
                  Positioned(
                      top: 110,
                      left: 492.5,
                      child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              border: Border.all(color: Colors.black)))),
                  Positioned(
                      top: 110,
                      left: 530,
                      child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              border: Border.all(color: Colors.black)))),
                  Positioned(
                      top: 130,
                      left: 455,
                      child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              border: Border.all(color: Colors.black)))),
                  Positioned(
                      top: 130,
                      left: 492.5,
                      child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              border: Border.all(color: Colors.black)))),
                  Positioned(
                      top: 130,
                      left: 530,
                      child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              border: Border.all(color: Colors.black)))),

                  const Positioned(
                      top: 155,
                      left: 455,
                      child: Text(
                        "НПТ-1",
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      )),
                  const Positioned(
                      top: 320,
                      left: 475,
                      child: Text(
                        "ОВЕН",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      )),
                  Positioned(
                      top: 360,
                      left: 455,
                      child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              border: Border.all(color: Colors.black)))),
                  Positioned(
                      top: 360,
                      left: 492.5,
                      child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              border: Border.all(color: Colors.black)))),
                  Positioned(
                      top: 360,
                      left: 530,
                      child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              border: Border.all(color: Colors.black)))),
                  Positioned(
                      top: 380,
                      left: 455,
                      child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              border: Border.all(color: Colors.black)))),
                  Positioned(
                      top: 380,
                      left: 492.5,
                      child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              border: Border.all(color: Colors.black)))),
                  Positioned(
                      top: 380,
                      left: 530,
                      child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              border: Border.all(color: Colors.black)))),

                  // ОВЕН ЭП-10
                  Positioned(
                      top: 500,
                      left: 400,
                      child: Container(
                          height: 300,
                          width: 500,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 4)))),
                  Positioned(
                      top: 390,
                      left: 460,
                      child: Container(
                          width: 2, height: 300, color: Colors.black)),
                  Positioned(
                      top: 390,
                      left: 535,
                      child: Container(
                          width: 2, height: 250, color: Colors.black)),
                  Positioned(
                      top: 640,
                      left: 535,
                      child: Container(
                        height: 2,
                        width: 100,
                        color: Colors.black,
                      )),
                  Positioned(
                      top: 690,
                      left: 460,
                      child: Container(
                        height: 2,
                        width: 175,
                        color: Colors.black,
                      )),
                  Positioned(
                      top: 550,
                      left: 600,
                      child: Container(
                        width: 150,
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 2)),
                      )),
                  Positioned(
                      top: 642,
                      left: 600,
                      child: Container(
                        width: 30,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                      )),
                  Positioned(
                      top: 620,
                      left: 735,
                      child: Container(
                        width: 30,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 3)),
                      )),
                  Positioned(
                    top: 645,
                    left: 745,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black),
                    ),
                  ),
                  const Positioned(
                      top: 640,
                      left: 770,
                      child: Text(
                        "Rt1",
                        style: TextStyle(fontSize: 16.0),
                      )),

                  // thermometer
                  Positioned(
                      left: 635,
                      top: 20,
                      child: Image.asset(
                        'assets/thermometer.png',
                        width: 600,
                      )),
                  Positioned(
                      left: 805,
                      top: 539,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      )),
                  Positioned(
                      left: 818.9,
                      top: 169,
                      child: Container(
                        height: 380,
                        width: 5.5,
                        color: Colors.red,
                      )),
                  Positioned(
                      left: 818.6,
                      top: 169,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: myDuration),
                        height: myHeight,
                        width: 6,
                        color: Colors.white,
                      )),
                  //cabels
                  Positioned(
                      top: 450,
                      left: 250,
                      child:
                          Container(height: 50, width: 3, color: Colors.black)),
                  Positioned(
                      top: 450,
                      left: 250,
                      child: Container(
                          height: 3, width: 150, color: Colors.black)),
                  Positioned(
                      top: 383,
                      left: 400,
                      child:
                          Container(height: 70, width: 3, color: Colors.black)),
                  Positioned(
                      top: 383,
                      left: 400,
                      child:
                          Container(height: 3, width: 50, color: Colors.black)),
                  Positioned(
                      top: 200,
                      left: 340,
                      child: Container(
                          height: 3, width: 110, color: Colors.black)),
                  Positioned(
                      top: 70,
                      left: 300,
                      child:
                          Container(height: 30, width: 3, color: Colors.black)),
                  Positioned(
                      top: 70,
                      left: 300,
                      child: Container(
                          height: 3, width: 350, color: Colors.black)),
                  Positioned(
                      top: 70,
                      left: 650,
                      child: Container(
                          height: 100, width: 3, color: Colors.black)),
                  Positioned(
                      top: 50,
                      left: 100,
                      child:
                          Container(height: 50, width: 3, color: Colors.pink)),
                  Positioned(
                      top: 50,
                      left: 100,
                      child:
                          Container(height: 3, width: 150, color: Colors.pink)),
                  Positioned(
                    top: 47,
                    left: 241,
                    child: Transform.rotate(
                      angle: math.pi / 4,
                      child:
                          Container(height: 3, width: 10, color: Colors.pink),
                    ),
                  ),
                  Positioned(
                    top: 53,
                    left: 241,
                    child: Transform.rotate(
                      angle: -math.pi / 4,
                      child:
                          Container(height: 3, width: 10, color: Colors.pink),
                    ),
                  ),
                  const Positioned(
                      left: 140,
                      top: 30,
                      child: Text("RS485", style: TextStyle(fontSize: 18))),
                  // heat up button
                  Positioned(
                      top: 167,
                      left: 631,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (!heatState) ? Colors.green : Colors.red,
                            border: Border.all(color: Colors.black, width: 2),
                        ),
                      )),
                ],
              ),
            ),

            // // Timer
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: SizedBox(
            //     width: 350.0,
            //     height: 350.0,
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         const SizedBox(
            //           height: 10.0,
            //         ),
            //         const Center(
            //             child: Text("Секундомер",
            //                 style: TextStyle(
            //                     fontSize: 18.0, fontWeight: FontWeight.bold))),
            //         const SizedBox(
            //           height: 10.0,
            //         ),
            //         Container(
            //           height: 250.0,
            //           width: 500.0,
            //           decoration: BoxDecoration(
            //             border: Border.all(width: 2.0),
            //             borderRadius: BorderRadius.circular(45.0),
            //           ),
            //           child: Column(
            //             children: [
            //               Padding(
            //                 padding: const EdgeInsets.only(
            //                     top: 16.0, left: 8.0, right: 8.0, bottom: 8.0),
            //                 child: Text(
            //                   "$digitHours:$digitMinutes:$digitSeconds",
            //                   style: const TextStyle(fontSize: 40),
            //                 ),
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Container(
            //                   width: 300,
            //                   height: 150 - 11,
            //                   child: ListView.builder(
            //                     itemCount: laps.length,
            //                     itemBuilder: (context, index) {
            //                       return Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Row(
            //                           mainAxisAlignment:
            //                               MainAxisAlignment.spaceBetween,
            //                           children: [
            //                             Text(
            //                               "Круг ${index + 1}",
            //                               style:
            //                                   const TextStyle(fontSize: 16.0),
            //                             ),
            //                             Text(
            //                               "${laps[index]}",
            //                               style:
            //                                   const TextStyle(fontSize: 16.0),
            //                             ),
            //                           ],
            //                         ),
            //                       );
            //                     },
            //                   ),
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //         const SizedBox(height: 10.0),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             const SizedBox(height: 20.0),
            //             Ink(
            //               decoration: ShapeDecoration(
            //                 color: (!started) ? Colors.green : Colors.red,
            //                 shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(5.0)),
            //               ),
            //               child: IconButton(
            //                 icon: (!started)
            //                     ? const Icon(Icons.play_arrow)
            //                     : const Icon(Icons.pause),
            //                 color: Colors.white,
            //                 onPressed: () {
            //                   return (!started) ? start(500) : stop();
            //                 },
            //               ),
            //             ),
            //             Ink(
            //               decoration: ShapeDecoration(
            //                 color: Colors.yellow,
            //                 shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(5.0)),
            //               ),
            //               child: IconButton(
            //                 icon: const Icon(Icons.flag),
            //                 color: Colors.white,
            //                 onPressed: () {
            //                   return addLaps();
            //                 },
            //               ),
            //             ),
            //             Ink(
            //               decoration: ShapeDecoration(
            //                 color: Colors.orange,
            //                 shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(5.0)),
            //               ),
            //               child: IconButton(
            //                 icon: const Icon(Icons.restart_alt),
            //                 color: Colors.white,
            //                 onPressed: () {
            //                   return reset();
            //                 },
            //               ),
            //             ),
            //             const SizedBox(height: 20.0),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
