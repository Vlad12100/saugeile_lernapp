import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlliteteste/data/spaced_rep_words.dart';
import 'package:sqlliteteste/pages/add_word.dart';

import '../util/list_view_custom.dart';

class WordListPage extends StatefulWidget {
  const WordListPage({Key? key}) : super(key: key);

  @override
  State<WordListPage> createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  String textFieldValue = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: CupertinoSearchTextField(
            onChanged: (value) {
              setState(() {
                textFieldValue = value;
              });
            },
          )
      ),
      body: StreamBuilder<List<WordSpaced>>(
        stream: getWordsForList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Datenbank sagt NÖ 🐒");
          } else if (snapshot.hasData) {
            final words = snapshot.data;
            words!.sort((a, b) => a.trans.toLowerCase().compareTo(b.trans.toLowerCase()));
            final length = words?.length ?? 0;
            return ListView.builder(
                itemCount: length,
                itemBuilder: (BuildContext context, int index) {
                  final word = words![index % length];
                  if(textFieldValue.isEmpty) {
                    return ListViewCustom(word);
                  }
                  if(word.trans.toLowerCase().contains(textFieldValue.toLowerCase())) {
                    return ListViewCustom(word);
                  }
                  return Container();
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