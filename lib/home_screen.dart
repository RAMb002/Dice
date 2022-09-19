import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  double scale = 1;
  int durationMilliSeconds = 100;
  int diceOne = Random().nextInt(6) + 1;
  int diceTwo = Random().nextInt(6) + 1;
  int wallet = 0;
  late AnimationController controller;
  late Animation<double> animation;

  late AnimationController controllerTwo;
  late Animation<Color?> animationTwo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controllerTwo = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));

    animationTwo = ColorTween(begin: Colors.white, end: Colors.green).animate(controllerTwo);

    controller.forward();

    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {
          controller.forward();
          diceOne = Random().nextInt(6) + 1;
          diceTwo = Random().nextInt(6) + 1;
          scale = 0.7;
        });
        await Future.delayed(const Duration(milliseconds: 200));
        setState(() {
          scale = 1.1;
        });
        await Future.delayed(const Duration(milliseconds: 200));
        setState(() {
          scale = 0.9;
          durationMilliSeconds = 50;
        });
        await Future.delayed(const Duration(milliseconds: 100));
        setState(() {
          scale = 1;
          wallet = wallet + (diceOne + diceTwo);
        });
        // print(wallet);
      }
    });

    controllerTwo.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controllerTwo.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      diceOne = 0;
                      diceTwo = 0;
                    });
                    if (controllerTwo.status == AnimationStatus.completed) {
                      controllerTwo.reverse();
                    } else {
                      controllerTwo.forward();
                    }
                    controller.reset();
                    controller.forward();
                    for (int i = 0; i < 5; i++) {
                      await Future.delayed(const Duration(milliseconds: 200));
                      setState(() {
                        diceOne = Random().nextInt(6) + 1;
                        diceTwo = Random().nextInt(6) + 1;
                      });
                    }
                    // pLike.changeLikeGestureStatus(widget.index, true,widget.reelScreen);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Dice(
                          scale: scale,
                          durationMilliSeconds: durationMilliSeconds,
                          number: diceOne,
                          animation: animation,
                          animationTwo: animationTwo,
                        ),
                        Dice(
                          scale: scale,
                          durationMilliSeconds: durationMilliSeconds,
                          number: diceTwo,
                          animation: animation,
                          animationTwo: animationTwo,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: animationTwo.value!,blurRadius: 10,spreadRadius: 2)],
                color: animationTwo.value,
                shape: BoxShape.circle,
                border: Border.all(color: animationTwo.value!, width: 3.5)),
            child: Center(
              child: Text(wallet.toString(), style: const TextStyle(color: Colors.black, fontSize: 20)),
            ),
          ),)
        ],
      ),
    );
  }
}

class Dice extends StatelessWidget {
  const Dice(
      {super.key,
      required this.scale,
      required this.durationMilliSeconds,
      required this.number,
      required this.animation,
      required this.animationTwo});

  final double scale;
  final int durationMilliSeconds;
  final int number;
  final Animation<double> animation;

  final Animation<Color?> animationTwo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 20,
      child: Center(
        child: RotationTransition(
          turns: animation,
          child: AnimatedScale(
            scale: scale,
            duration: Duration(milliseconds: durationMilliSeconds),
            child: AnimatedBuilder(
                animation: animationTwo,
                builder: (context, child) {
                  return Container(
                    height: 125,
                    width: 125,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: Colors.black,
                      border: Border.all(color: animationTwo.value!, width: 3.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Visibility(
                        visible: number != 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                number != 1
                                    ? Dot(
                                        scale: scale,
                                        durationMilliSeconds: durationMilliSeconds,
                                        color: animationTwo.value!,
                                      )
                                    : const SizedBox(),
                                number == 6
                                    ? Dot(
                                        scale: scale,
                                        durationMilliSeconds: durationMilliSeconds,
                                        color: animationTwo.value!,
                                      )
                                    : const SizedBox(),
                                number != 1 && number != 2 && number != 3
                                    ? Dot(
                                        scale: scale,
                                        durationMilliSeconds: durationMilliSeconds,
                                        color: animationTwo.value!,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                number == 1 || number == 5 || number == 3
                                    ? Dot(
                                        scale: scale,
                                        durationMilliSeconds: durationMilliSeconds,
                                        color: animationTwo.value!,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                number == 5 || number == 4 || number == 6
                                    ? Dot(
                                        scale: scale,
                                        durationMilliSeconds: durationMilliSeconds,
                                        color: animationTwo.value!,
                                      )
                                    : const SizedBox(),
                                number == 6
                                    ? Dot(
                                        scale: scale,
                                        durationMilliSeconds: durationMilliSeconds,
                                        color: animationTwo.value!,
                                      )
                                    : const SizedBox(),
                                number != 1
                                    ? Dot(
                                        scale: scale,
                                        durationMilliSeconds: durationMilliSeconds,
                                        color: animationTwo.value!,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({super.key, required this.scale, required this.durationMilliSeconds, required this.color});

  final double scale;
  final int durationMilliSeconds;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: scale,
      duration: Duration(milliseconds: durationMilliSeconds),
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
