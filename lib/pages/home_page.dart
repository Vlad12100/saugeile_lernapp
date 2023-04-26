import 'package:flutter/material.dart';
import 'package:sqlliteteste/pages/learn_known_page.dart';
import 'package:sqlliteteste/pages/learn_page.dart';
import 'package:sqlliteteste/pages/pig_page.dart';
import 'package:sqlliteteste/pages/word_write_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Center(
          child: Text(
            "Die saugeile Lernapp 🐖",
            style: TextStyle(fontSize: 25),
          ),
        )),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Flexible(
              flex: 1,
              child: Container(
              width: MediaQuery.of(context).size.width,
              height: 330,
              margin: const EdgeInsets.only(top: 5, right: 6, left: 6),
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color(0xFF404042)),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 5, right: 5, left: 5),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25)),
                          color: Color(0xFF2A2A2A)),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LearnPage()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            SizedBox(width: 20),
                            Icon(Icons.add, size: 30),
                            SizedBox(width: 20),
                            Text(
                              "Neue Wörter lernen",
                              style:
                              TextStyle(fontSize: 25, letterSpacing: 1.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 5),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25)),
                          color: Color(0xFF2A2A2A)),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LearnKnownPage()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            SizedBox(width: 20),
                            Icon(Icons.sync_rounded, size: 30),
                            SizedBox(width: 20),
                            Text(
                              "Wörter wiederholen",
                              style:
                              TextStyle(fontSize: 25, letterSpacing: 1.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   flex: 1,
                  //   child: Container(
                  //     margin: const EdgeInsets.only(
                  //         top: 5, right: 5, left: 5, bottom: 5),
                  //     decoration: const BoxDecoration(
                  //         borderRadius: BorderRadius.only(
                  //             bottomLeft: Radius.circular(25),
                  //             bottomRight: Radius.circular(25)),
                  //         color: Color(0xFF2A2A2A)),
                  //     child: InkWell(
                  //       onTap: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => const WordWritePage()),
                  //         );
                  //       },
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: const [
                  //           SizedBox(width: 20),
                  //           Icon(Icons.spellcheck, size: 30),
                  //           SizedBox(width: 20),
                  //           Text(
                  //             "Schreiben",
                  //             style:
                  //                 TextStyle(fontSize: 25, letterSpacing: 1.0),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),),
            Flexible(
                flex: 2,
                child: InkWell(
                  onDoubleTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PigPage()),
                    );
                  },
                  child: Image.asset('assets/images/waddles.png'),
                )
            )
          ],
        ));
  }
}
