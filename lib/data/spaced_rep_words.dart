

import 'package:cloud_firestore/cloud_firestore.dart';


class WordSpaced {
  String id;
  final term;
  final trans;
  bool isKnown;
  int repetitions;
  int intervalIndex;
  int nextReviewDate;

  WordSpaced({
    this.id = "",
    required this.term,
    required this.trans,
    this.isKnown = false,
    this.repetitions = 0,
    this.intervalIndex = 0,
    required this.nextReviewDate,
  });

  int get getInterval2 {
    return intervalIndex;
  }
  int get getRepetition {
    return repetitions;
  }

  void updateNextReviewDate() {
    int nextInterval = getNextInterval(getRepetition);
    nextReviewDate = DateTime.now().add(Duration(minutes: nextInterval)).millisecondsSinceEpoch;
    repetitions++;
    intervalIndex++;
  }

  static int getNextInterval(int repetitions) {
    List<int> intervals = [2, 6, 24, 48, 96, 168];
    if (repetitions < intervals.length) {
      return intervals[repetitions];
    }
    return intervals[intervals.length - 1];
  }

  static WordSpaced fromMap(Map<String, dynamic> map) {
    return WordSpaced(
      id: map['id'],
      term: map['term'],
      trans: map['trans'],
      isKnown: map['isKnown'],
      repetitions: map['repetitions'],
      intervalIndex: map['intervalIndex'],
      nextReviewDate: map['nextReviewDate'],
    );
  }
  //test
  void hhh() {
    print("xd");
  }

  // Funktion zur Umwandlung eines Word-Objekts in Firebase-Daten
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'term': term,
      'trans': trans,
      'isKnown': isKnown,
      'repetitions': repetitions,
      'intervalIndex': intervalIndex,
      'nextReviewDate': nextReviewDate,
    };
  }
}

void addWordToFirebase(WordSpaced word) {
  FirebaseFirestore.instance.collection('spaced_words').doc(word.id).set(word.toMap());
}

void updateWordInFirebase(WordSpaced word) {
  FirebaseFirestore.instance.collection('spaced_words').doc(word.id).update(word.toMap());
}

void deleteWordFromFirebase(String id) {
  FirebaseFirestore.instance.collection('spaced_words').doc(id).delete();
}

void updateWordToLvl3(String id) {
  FirebaseFirestore.instance.collection('spaced_words').doc(id).update({
    'repetitions': 3,
    'intervalIndex': 3,
    'nextReviewDate': DateTime.now().add(Duration(minutes: 24)).millisecondsSinceEpoch
  });
}

void updateWordToTrue(String id) {
  FirebaseFirestore.instance.collection('spaced_words').doc(id).update({
    'isKnown': true,
  });
}

void markWordAsKnownAndSetTimer(String id) {
  FirebaseFirestore.instance.collection('spaced_words').doc(id).update({
    'isKnown': true,
  }).then((_) {
    FirebaseFirestore.instance.collection('spaced_words').doc(id).get().then((snapshot) {
      WordSpaced word = WordSpaced.fromMap(snapshot.data()!);
      final x = word.nextReviewDate;
      word.updateNextReviewDate();
      FirebaseFirestore.instance.collection('spaced_words').doc(id).update({
        'repetitions': word.repetitions,
        'intervalIndex': word.intervalIndex,
        'nextReviewDate': word.nextReviewDate,
      });
    });
  });
}

Stream<List<WordSpaced>> getWordsForKnown() {
  return FirebaseFirestore.instance
      .collection('spaced_words')
      .where('nextReviewDate', isLessThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => WordSpaced.fromMap(doc.data()))
      .toList());
}

Stream<List<WordSpaced>> getWordsForUnknown() {
  return FirebaseFirestore.instance
      .collection('spaced_words')
      .where('isKnown', isEqualTo: false)
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => WordSpaced.fromMap(doc.data()))
      .toList());
}

Stream<List<WordSpaced>> getWordsForList() {
  return FirebaseFirestore.instance
      .collection('spaced_words')
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => WordSpaced.fromMap(doc.data()))
      .toList());
}


Future<List<WordSpaced>> fetchWordsFromDatabase() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference wordsRef = firestore.collection('spaced_words');

  QuerySnapshot snapshot = await wordsRef.get();
  List<WordSpaced> wordList = [];

  snapshot.docs.forEach((doc) {
    WordSpaced word = WordSpaced(
      id: doc.id,
      term: doc['term'],
      trans: doc['trans'],
      isKnown: doc['isKnown'],
      repetitions: doc['repetitions'],
      intervalIndex: doc['intervalIndex'],
      nextReviewDate: doc['nextReviewDate'],
    );
    // if (word.nextReviewDate <= DateTime.now().millisecondsSinceEpoch) {
    //   wordList.add(word);
    // }
    wordList.add(word);
  });

  return wordList;
}

// void fetchWordsFromDatabase() async {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   CollectionReference wordsRef = firestore.collection('words');
//
//   QuerySnapshot snapshot = await wordsRef.get();
//   List<Word> wordList = [];
//
//   snapshot.docs.forEach((doc) {
//     Word word = Word(
//       id: doc.id,
//       term: doc['term'],
//       trans: doc['trans'],
//       isKnown: doc['isKnown'],
//     );
//     // if (word.nextReviewDate <= DateTime.now().millisecondsSinceEpoch) {
//     //   wordList.add(word);
//     // }
//     wordList.add(word);
//   });
//   String term = "";
//   String trans = "";
//   bool isKnown = false;
//
//   // for(int i = 0; i < wordList.length; i++) {
//   //   term = wordList[i].term;
//   //   trans = wordList[i].trans;
//   //   isKnown = false;
//   //   print('WordSpaced(term: \'$term\', trans: \'$trans\', isKnown: \'$isKnown\', repetitions: 0, intervalIndex: 0, nextReviewDate: 1681329144211,)');
//   // }
// }