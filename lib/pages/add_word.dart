import 'package:flutter/material.dart';
import 'package:sqlliteteste/data/spaced_rep_words.dart';
import 'package:uuid/uuid.dart';

class AddWord extends StatefulWidget {
  const AddWord({Key? key}) : super(key: key);

  @override
  State<AddWord> createState() => _AddWordState();
}

class _AddWordState extends State<AddWord> {
  final controllerTerm = TextEditingController();
  final controllerTrans = TextEditingController();
  var uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Neues Wort Hinzufügen"),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 220,
              margin: const EdgeInsets.only(top: 5, right: 6, left: 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color(0xFF404042)),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5, right: 5, left: 5),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25)),
                        color: Color(0xFF2A2A2A)),
                    height: 100,
                    width: MediaQuery.of(context).size.width * 1,
                    child: TextField(
                      style: const TextStyle(fontSize: 25),
                      controller: controllerTerm,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 20, bottom: 5, top: 35, right: 20),
                          border: InputBorder.none,
                          hintText: "Das Wort auf Russisch",
                          hintStyle: TextStyle()),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5, right: 5, left: 5),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25)),
                        color: Color(0xFF2A2A2A)),
                    height: 100,
                    width: MediaQuery.of(context).size.width * 1,
                    child: TextField(
                      style: const TextStyle(fontSize: 25),
                      controller: controllerTrans,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 20, bottom: 5, top: 35, right: 20),
                          border: InputBorder.none,
                          hintText: "Übersetzung",
                          hintStyle: TextStyle()),
                    )
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 300.0,
              height: 70.0,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    color: Colors.blue),
              child: RawMaterialButton(
                shape: const CircleBorder(),
                elevation: 0.0,
                child: const Text("Hinzufügen",  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.normal,),),
                onPressed: (){
                  WordSpaced word = WordSpaced(
                    id: uuid.v1(),
                      term: controllerTerm.text,
                      trans: controllerTrans.text,
                      isKnown: false,
                    intervalIndex: 0,
                    repetitions: 0,
                    nextReviewDate: DateTime.now().millisecondsSinceEpoch
                  );
                  addWordToFirebase(word);
                  Navigator.pop(context);
                },
              )
            )
          ],
        )));
  }
}
