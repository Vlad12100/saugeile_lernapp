import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlliteteste/data/spaced_rep_words.dart';

import '../pages/write_page_popup.dart';

Widget FlipCardCustom(BuildContext context, String word, WordSpaced wordSpaced) {
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
   Column(
     children: [
       Expanded(
         flex: 1,
           child: Container(
             child: Row(
               mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 InkWell(
                   onTap: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                           builder: (context) => WritePagePopup(wordSpaced)),
                     );
                   },
                   child: Icon(Icons.create_sharp, size: 40),
                 ),
                 SizedBox(
                   width: 30,
                 )
               ],
             ),
           )
       ),
       Expanded(
         flex: 2,
         child:  Text(word,
         textAlign: TextAlign.center,
         style:
         const TextStyle(
           color: Colors.white,
           fontSize: 36.0,
           fontWeight: FontWeight.bold,
         ),
       ),)
     ],
   )
  );
}