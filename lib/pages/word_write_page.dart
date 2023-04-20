import 'dart:math';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import '../data/spaced_rep_words.dart';
import '../util/flip_card_custom.dart';

class WordWritePage extends StatefulWidget {
  const WordWritePage({Key? key}) : super(key: key);

  @override
  State<WordWritePage> createState() => _WordWritePageState();
}

class _WordWritePageState extends State<WordWritePage>
    with SingleTickerProviderStateMixin {
  //PageController _pageController = PageController(initialPage: 0);
  final controller = TextEditingController();
  // late AnimationController _controller;
  // late Animation<Offset> translateAnimation;
  // late Animation sizeAnimation;
  // int? _currentPageIndex;

  bool textInput = false;
  late Color textFieldColor;


  @override
  void initState() {
    super.initState();
    textFieldColor = Colors.grey;
    // _controller =
    //     AnimationController(vsync: this, duration: Duration(seconds: 2));
    // sizeAnimation = Tween<double>(begin: 1, end: 2).animate(_controller);
    // _currentPageIndex = 0;
  }

  void test(){
    print("OBEN");
  }

  void textFieldValue(String wordValue, String textFielValue) {
    if(wordValue.toLowerCase() == textFielValue.toLowerCase()) {
      textFieldColor = Colors.green;
    } else {
      textFieldColor = Colors.red;
    }
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
                    //_currentPageIndex = page;
                  });
                },
                //controller: _pageController,
                itemBuilder: (context, index) {
                  final word = words![index % length];
                  return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      color: const Color(0xFF414142),
                      margin: const EdgeInsets.all(15),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 10, left: 30, right: 30,
                              child: Container(
                                height: 50,
                                color: Colors.red,
                                child: Center(
                                    child: Text(word.trans, style: TextStyle(fontSize: 25, letterSpacing: 1.0),))
                              )),
                          Positioned(
                              top: 90, left: 30, right: 30,
                              child: Container(
                                child: TextField(
                                  controller: controller,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 3, color: textFieldColor)
                                    ),
                                  ),
                                  onSubmitted: (value) {
                                    setState(() {
                                      textFieldValue(word.trans, value);
                                    });
                                  },
                                )
                              )),
                          Positioned(
                              top: 160, left: 30, right: 30,
                              child: Container(
                                child: OutlinedButton(
                                  child: Text("SUBMIT"),
                                  onPressed: () {
                                    setState(() {
                                      FocusScope.of(context).unfocus();
                                      textFieldValue(word.trans, controller.text);
                                    });
                                  },
                                ),
                              ))
                        ],
                      ));
                });
          },
        ),
      ),
    );
  }
}
