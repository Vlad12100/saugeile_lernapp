import 'dart:math';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import '../data/spaced_rep_words.dart';
import '../util/flip_card_custom.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({Key? key}) : super(key: key);

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage>
    with SingleTickerProviderStateMixin {
  PageController _pageController = PageController(initialPage: 0);
  late AnimationController _controller;
  late Animation<Offset> translateAnimation;
  late Animation sizeAnimation;
  int? _currentPageIndex;

  double _offsetX = 0;
  double _rotation = 0.0;
  double _scale = 1.0;
  bool _buttonColorLeft = false;
  bool _buttonColorRight = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    sizeAnimation = Tween<double>(begin: 1, end: 2).animate(_controller);
    _currentPageIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lernen", style: TextStyle(fontSize: 25)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: StreamBuilder(
          stream: getWordsForUnknown(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final words = snapshot.data;
            final length = words?.length ?? 0;
            return length == 0
                ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 70,
                    ),
                    const Text(
                      "Du kannst alle Wörter",
                      style: TextStyle(fontSize: 25, letterSpacing: 1.0),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Image.asset('assets/images/happy_pig.png')
                  ],
                )
            )
                : PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (int page) {
                  setState(() {
                    _currentPageIndex = page;
                  });
                },
                controller: _pageController,
                itemBuilder: (context, index) {
                  final word = words![index % length];
                  return GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          _offsetX += details.delta.dx;
                          _rotation = (_offsetX / 100) * 5;
                          _scale = 1 - (_rotation.abs() / 100);
                          if (_rotation > 0) {
                            _buttonColorRight = true;
                            _buttonColorLeft = false;
                          } else {
                            _buttonColorLeft = true;
                            _buttonColorRight = false;
                          }
                        });
                      },
                      onPanEnd: (DragEndDetails details) {
                        setState(() {
                          if (_offsetX < -180) {
                            _currentPageIndex =
                                (_currentPageIndex! - 1) % length;
                            _pageController.jumpToPage(_currentPageIndex!);
                            //markWordAsKnown(word.id);
                            updateWordToTrue(word.id);
                          } else if (_offsetX > 180) {
                            _currentPageIndex =
                                (_currentPageIndex! + 1) % length;
                            _pageController.jumpToPage(_currentPageIndex!);
                          }
                          _buttonColorLeft = false;
                          _buttonColorRight = false;
                          _rotation = 0;
                          _offsetX = 0;
                          _scale = 1.0;
                        });
                      },
                      child: TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 400),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (BuildContext context,
                            double opacityAnimation, Widget? child) {
                          return Opacity(
                              opacity: opacityAnimation,
                              child: TweenAnimationBuilder(
                                duration: const Duration(milliseconds: 300),
                                tween: Tween<double>(begin: 0.95, end: 1),
                                builder: (BuildContext context,
                                    double scaleAnimation, Widget? child) {
                                  return Transform.scale(
                                      scale: scaleAnimation,
                                      child: Transform.translate(
                                          offset: Offset(_offsetX, 0),
                                          child: Transform.rotate(
                                            angle: _rotation * (pi / 180),
                                            child: Transform.scale(
                                                scale: _scale,
                                                child: AnimatedScale(
                                                  duration: const Duration(seconds: 1),
                                                  scale: 1,
                                                  child: Card(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(25)),
                                                      color: const Color(0xFF414142),
                                                      margin: const EdgeInsets.all(15),
                                                      child: GridTile(
                                                          header: Center(
                                                              child: Container(
                                                                  margin: const EdgeInsets.only(top: 4, right: 2, left: 2),
                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: const Color(0xFF2A2A2A)),
                                                                  height: 50,
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      Text("Level ${word.repetitions}", style: const TextStyle(
                                                                        fontSize: 16.0,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),),
                                                                      Text(
                                                                        'Card ${(index) % words.length + 1} of ${words.length}',
                                                                        style: const TextStyle(
                                                                          fontSize: 16.0,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                              )),
                                                          child: Stack(
                                                            children: [
                                                              SizedBox(
                                                                height: MediaQuery.of(context).size.height * 0.5,
                                                                width: double.infinity,
                                                                child: Center(
                                                                  child: FlipCard(
                                                                    speed: 400,
                                                                    direction: FlipDirection.HORIZONTAL,
                                                                    front: FlipCardCustom(context, word.trans),
                                                                    back: FlipCardCustom(context, word.term),
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(bottom: 0, left: 0,
                                                                  child: SizedBox(
                                                                      height: MediaQuery.of(context).size.height * 0.07,
                                                                      width: MediaQuery.of(context).size.width * 0.46,
                                                                      child: TextButton(
                                                                        style:
                                                                        TextButton.styleFrom(backgroundColor: _buttonColorLeft ? Colors.green : const Color(0xFF414142), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.0)))),
                                                                        onPressed:
                                                                            () {
                                                                          _currentPageIndex = (_currentPageIndex! - 1) % length;
                                                                          _pageController.jumpToPage(_currentPageIndex!);
                                                                        },
                                                                        child:
                                                                        const Text(
                                                                          "Kann ich",
                                                                          style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: 15.0,
                                                                          ),
                                                                        ),
                                                                      ))),
                                                              Positioned(bottom: 0, right: 0,
                                                                  child: SizedBox(
                                                                      height: MediaQuery.of(context).size.height * 0.07,
                                                                      width: MediaQuery.of(context).size.width * 0.46,
                                                                      child: TextButton(
                                                                        style:
                                                                        TextButton.styleFrom(backgroundColor: _buttonColorRight ? Colors.grey : const Color(0xFF414142), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(25.0)))),
                                                                        onPressed:
                                                                            () {
                                                                          _currentPageIndex = (_currentPageIndex! + 1) % length;
                                                                          _pageController.jumpToPage(_currentPageIndex!);
                                                                        },
                                                                        child: const Text("Kann ich noch nicht",
                                                                            style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 15.0,
                                                                            )),
                                                                      ))),
                                                            ],
                                                          ))),
                                                )),
                                          )));
                                },
                              ));
                        },
                      ));
                });
          },
        ),
      ),
    );
  }
}
