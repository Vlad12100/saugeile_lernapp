import 'package:flutter/material.dart';
import '../data/spaced_rep_words.dart';

class WordWritePage extends StatefulWidget {
  const WordWritePage({Key? key}) : super(key: key);

  @override
  State<WordWritePage> createState() => _WordWritePageState();
}

class _WordWritePageState extends State<WordWritePage>
    with AutomaticKeepAliveClientMixin {
  PageController pageController = PageController(initialPage: 0);
  var pageStrKey = const PageStorageKey(["List_Page"]);
  PageStorageBucket _bucket = PageStorageBucket();
  final controller = TextEditingController();
  bool _enabled = false;
  double nextButtonOpacity = 0.0;
  int hitHintCounter = 0;
  int correctLetters = 0;
  bool isvalid = false;
  bool rightColor = false;

  @override
  void initState() {
    super.initState();
  }


  void compareWordAndTextField(String textField, String word) {
    correctLetters = 0;
    hitHintCounter++;
    if (textField == "") {
      controller.text = word[0];
    }

    for (int i = 0; i < textField.length; i++) {
      if (textField[i].toLowerCase() == word[i].toLowerCase()) {
        correctLetters++;
      }
    }
    controller.text = word.substring(0, correctLetters + 1);
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    if (hitHintCounter >= 3) {
      showNextButton(word);
    }
  }

  void makeNextButtonVisable() {
    setState(() {
      _enabled = true;
      nextButtonOpacity = 1.0;
      hitHintCounter = 0;
    });
  }

  void makeNextButtonUnvisable() {
    setState(() {
      _enabled = false;
      nextButtonOpacity = 0.0;
      hitHintCounter = 0;
    });
  }

  void showNextButton(String word) {
    makeNextButtonVisable();
    controller.text = word;
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    FocusScope.of(context).unfocus();
  }

  void onSubmit(String textField, String word) {
    if (textField.toLowerCase() == word.toLowerCase()) {
      rightColor = !rightColor;
      makeNextButtonVisable();
    } else {
      setState(() {
        isvalid = true;
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Schreiben", style: TextStyle(fontSize: 25)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: StreamBuilder(
          stream: getWordsForList(),
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
                  ))
                : PageStorage(
              bucket: _bucket,
              child: PageView.builder(
                  key: const PageStorageKey<String>("page"),
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (int page) {
                    setState(() {
                      makeNextButtonUnvisable();
                      //_currentPageIndex = page;
                    });
                  },
                  controller: pageController,
                  itemBuilder: (context, index) {
                    final word = words![index % length];
                    return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        color: const Color(0xFF414142),
                        margin: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                      child: Text(
                                        word.trans,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 36.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30, right: 30),
                                      child: TextField(
                                          controller: controller,
                                          onChanged: (value) {
                                            setState(() {
                                              isvalid = false;
                                            });
                                          },
                                          onSubmitted: (value) {
                                            onSubmit(value, word.term);
                                          },
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 25),
                                          textInputAction:
                                          TextInputAction.done,
                                          decoration: InputDecoration(
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(width: 1.5, color: rightColor ? Colors.green : Colors.grey),
                                              ),
                                              errorText: isvalid
                                                  ? "NÖ! Versuch's nochmal"
                                                  : null)),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30, right: 30),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(
                                              borderRadius:
                                              BorderRadius.circular(25),
                                              onTap: () {
                                                compareWordAndTextField(
                                                    controller.text,
                                                    word.term);
                                              },
                                              child: Container(
                                                height: 50,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        25),
                                                    color: Colors.grey),
                                                child: const Center(
                                                    child: Icon(
                                                      Icons.lightbulb_outlined,
                                                      color: Colors.black,
                                                      size: 30,
                                                    )),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            InkWell(
                                              borderRadius:
                                              BorderRadius.circular(25),
                                              onTap: () {
                                                setState(() {
                                                  isvalid = false;
                                                  showNextButton(word.term);
                                                });
                                              },
                                              child: Ink(
                                                height: 50,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        25),
                                                    color: Colors.grey),
                                                child: const Center(
                                                    child: Icon(
                                                      Icons
                                                          .question_mark_outlined,
                                                      color: Colors.black,
                                                      size: 30,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ))
                                  ],
                                )),
                            Expanded(flex: 1, child: Container()),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: InkWell(
                                        borderRadius:
                                        BorderRadius.circular(25),
                                        onTap: () {
                                          onSubmit(
                                              controller.text, word.term);
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(25),
                                              color: Colors.grey),
                                          child: const Center(
                                            child: Text("SUBMIT",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        child: Opacity(
                                          opacity: nextButtonOpacity,
                                          child: InkWell(
                                            splashColor: Colors.green,
                                            borderRadius:
                                            BorderRadius.circular(25),
                                            onTap: _enabled
                                                ? () {
                                              controller.clear();
                                              pageController.nextPage(
                                                  duration: const Duration(
                                                      microseconds:
                                                      300),
                                                  curve: Curves.linear);
                                              setState(() {
                                                isvalid = false;
                                              });
                                            }
                                                : null,
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      25),
                                                  color: Colors.green),
                                              child: const Center(
                                                child: Text("NEXT PAGE",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                        )),
                                  ],
                                ))
                          ],
                        ));
                  }),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
