import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqlliteteste/data/spaced_rep_words.dart';
import 'package:sqlliteteste/pages/add_word.dart';
import 'package:sqlliteteste/pages/update_word.dart';

class WordListPage extends StatefulWidget {
  const WordListPage({Key? key}) : super(key: key);

  @override
  State<WordListPage> createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste aller Wörter"),
      ),
      body: StreamBuilder<List<WordSpaced>>(
        stream: getWordsForList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Datenbank sagt NÖ 🐒");
          } else if (snapshot.hasData) {
            final words = snapshot.data;
            final length = words?.length ?? 0;
            return ListView.builder(
                itemCount: length,
                itemBuilder: (BuildContext context, int index) {
                  final word = words![index % length];
                  return Slidable(
                      endActionPane: ActionPane(
                        extentRatio: 0.4,
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: ((context) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UpdateWord(word)),
                              );
                            }),
                            icon: Icons.create,
                            backgroundColor: Colors.blue.shade300,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          SlidableAction(
                            onPressed: ((context) {
                              deleteWordFromFirebase(word.id);
                            }),
                            icon: Icons.delete,
                            backgroundColor: Colors.red.shade300,
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color(0xFF2A2A2A)),
                        margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                        width: double.infinity,
                        height: 70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 35,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Flexible(
                                    child: Text(
                                      word.term,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 35,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Flexible(
                                      child: Text(
                                    word.trans,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ));
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddWord()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}

