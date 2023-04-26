import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqlliteteste/data/spaced_rep_words.dart';
import 'package:sqlliteteste/pages/update_word.dart';

Widget ListViewCustom(WordSpaced word) {
  return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.4,
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: ((context) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdateWord(word)),
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
        margin:
        const EdgeInsets.only(top: 5, left: 5, right: 5),
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
                      word.trans,
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
                        word.term,
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
}