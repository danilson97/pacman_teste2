import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pac_man/path.dart';
import 'package:pac_man/pixel.dart';
import 'package:pac_man/player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 17;
  int player = numberInRow * 15 + 1;

  List<int> barries = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    22,
    33,
    44,
    55,
    66,
    77,
    99,
    110,
    121,
    132,
    143,
    154,
    165,
    176,
    177,
    178,
    179,
    180,
    181,
    183,
    182,
    184,
    185,
    186,
    175,
    164,
    153,
    142,
    131,
    120,
    109,
    87,
    76,
    65,
    54,
    43,
    32,
    21,
    24,
    35,
    46,
    57,
    79,
    80,
    81,
    70,
    59,
    26,
    37,
    38,
    39,
    28,
    30,
    41,
    52,
    63,
    61,
    72,
    83,
    84,
    85,
    101,
    102,
    103,
    114,
    125,
    105,
    116,
    127,
    106,
    107,
    123,
    134,
    145,
    156,
    158,
    147,
    148,
    149,
    160,
    129,
    140,
    151,
    162,
    88,
    98,
  ];

  List<int> food = [];
  List<int> noFood = [];

  String direction = "right";
  bool mouthClosed = false;
  void startGame() {
    getFood();
    Duration duration = const Duration(milliseconds: 120);
    Timer.periodic(duration, (timer) {
      mouthClosed = !mouthClosed;

      if (food.contains(player)) {
        food.remove(player);
        noFood.add(player);
      }

      switch (direction) {
        case "left":
          moveLeft();
          break;
        case "right":
          moveRight();
          break;
        case "up":
          moveUp();
          break;
        case "down":
          moveDown();
          break;
      }
    });
  }

  void getFood() {
    for (var i = 0; i < numberOfSquares; i++) {
      if (!barries.contains(i)) {
        food.add(i);
      }
    }
  }

  void moveLeft() {
    if (!barries.contains(player - 1)) {
      setState(() {
        player--;
      });
    }
  }

  void moveRight() {
    if (!barries.contains(player + 1)) {
      setState(() {
        player++;
      });
    }
  }

  void moveUp() {
    if (!barries.contains(player - numberInRow)) {
      setState(() {
        player -= numberInRow;
      });
    }
  }

  void moveDown() {
    if (!barries.contains(player + numberInRow)) {
      setState(() {
        player += numberInRow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var coisa = noFood.length * 10;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  direction = "down";
                } else if (details.delta.dy < 0) {
                  direction = "up";
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0) {
                  direction = "right";
                } else if (details.delta.dx < 0) {
                  direction = "left";
                }
              },
              child: Container(
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: numberOfSquares,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: numberInRow),
                    itemBuilder: (BuildContext context, int index) {
                      if (player == index) {
                        switch (direction) {
                          case "left":
                            return Transform.rotate(
                              angle: pi,
                              child: MyPlayer(),
                            );
                          case "right":
                            return MyPlayer();
                          case "up":
                            return Transform.rotate(
                              angle: 3 + pi / 2,
                              child: MyPlayer(),
                            );
                          case "down":
                            return Transform.rotate(
                              angle: pi / 2,
                              child: MyPlayer(),
                            );
                          default:
                            return MyPlayer();
                        }
                      } else if (barries.contains(index)) {
                        return MyPixel(
                          innerColor: Colors.blue[800],
                          outerColor: Colors.blue[900],
                          //child: Text(index.toString())
                        );
                      } else if (food.contains(index)) {
                        return MyPath(
                          innerColor: Colors.yellow,
                          outerColor: Colors.black,
                          //child: Text(index.toString())
                        );
                      } else if (noFood.contains(index)) {
                        return MyPath(
                          innerColor: Colors.black,
                          outerColor: Colors.black,
                          //child: Text(index.toString())
                        );
                      } else {
                        return MyPath(
                          innerColor: Colors.yellow,
                          outerColor: Colors.black,
                          //child: Text(index.toString())
                        );
                      }
                    }),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Score: $coisa",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  GestureDetector(
                      onTap: startGame,
                      child: const Text(
                        "P L A Y ",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
