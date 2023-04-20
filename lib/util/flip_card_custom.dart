import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget FlipCardCustom(BuildContext context, String word) {
  return Container(
    margin: const EdgeInsets.only(left: 4, right: 4),
    padding: const EdgeInsets.all(7),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: const Color(0xFF2A2A2A)),
    height: MediaQuery.of(context).size.height * 0.33,
    width: double.infinity,
    alignment: Alignment.center,
    child:
    Text(word,
      textAlign: TextAlign.center,
      style:
      const TextStyle(
        color: Colors.white,
        fontSize: 36.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}