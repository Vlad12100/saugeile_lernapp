import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class WordSpaced {
  String id;
  // ignore: prefer_typing_uninitialized_variables
  final term;
  // ignore: prefer_typing_uninitialized_variables
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
    nextReviewDate = DateTime.now()
        .add(Duration(minutes: nextInterval))
        .millisecondsSinceEpoch;
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
  FirebaseFirestore.instance
      .collection('spaced_words')
      .doc(word.id)
      .set(word.toMap());
}

void updateWordInFirebase(WordSpaced word) {
  FirebaseFirestore.instance
      .collection('spaced_words')
      .doc(word.id)
      .update(word.toMap());
}

void deleteWordFromFirebase(String id) {
  FirebaseFirestore.instance.collection('spaced_words').doc(id).delete();
}

void updateWordToLvl3(String id) {
  FirebaseFirestore.instance.collection('spaced_words').doc(id).update({
    'repetitions': 3,
    'intervalIndex': 3,
    'nextReviewDate':
        DateTime.now().add(const Duration(minutes: 20)).millisecondsSinceEpoch
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
    FirebaseFirestore.instance
        .collection('spaced_words')
        .doc(id)
        .get()
        .then((snapshot) {
      WordSpaced word = WordSpaced.fromMap(snapshot.data()!);
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
      .where('nextReviewDate',
          isLessThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => WordSpaced.fromMap(doc.data())).toList());
}

Stream<List<WordSpaced>> getWordsForUnknown() {
  return FirebaseFirestore.instance
      .collection('spaced_words')
      .where('isKnown', isEqualTo: false)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => WordSpaced.fromMap(doc.data())).toList());
}

Stream<List<WordSpaced>> getWordsForList() {
  return FirebaseFirestore.instance.collection('spaced_words').snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => WordSpaced.fromMap(doc.data())).toList());
}

Future<List<WordSpaced>> fetchWordsFromDatabase() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference wordsRef = firestore.collection('spaced_words');

  QuerySnapshot snapshot = await wordsRef.orderBy('term').get();
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

var uuid = const Uuid();

// void addListOfWordsToFirebase() {
//   for (WordSpaced w in page_2) {
//     w.id = uuid.v1();
//     addWordToFirebase(w);
//     print(w.id);
//   }
// }

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

List page_1 = [
  WordSpaced(
    term: 'Правило',
    trans: 'Regel',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Цвет',
    trans: 'Farbe',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'умный/ -ная/ -ное',
    trans: 'clever',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'странный/ -ная/ -ное',
    trans: 'seltsam',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'разный/ -ная/ -ное',
    trans: 'anders',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'шина',
    trans: 'ermüden',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'ранее',
    trans: 'zuvor',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Телевизор',
    trans: 'Fernseher',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'слушать',
    trans: 'hören',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'попробовать/пробовать',
    trans: 'probieren',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Автобус',
    trans: 'Bus',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'ждать',
    trans: 'warten',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'подожди/-те меня',
    trans: 'warte/ -t auf mich',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Oвощи',
    trans: 'Gemüse',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'мне нужно',
    trans: 'ich brauche',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'показать',
    trans: 'zeigen',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'найти',
    trans: 'finden',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Фрукты',
    trans: 'Obst',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Мясо',
    trans: 'Fleisch',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Вино',
    trans: 'Wein',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'bezahlen',
    trans: 'bezahlen',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Пальто',
    trans: 'Mantel',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Одежда',
    trans: 'Klamotten',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'осмотреться',
    trans: 'umsehen',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Rock',
    trans: 'Юбка',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Брюки',
    trans: 'Hose',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Платье',
    trans: 'Kleid',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
];

List page_2 = [
  WordSpaced(
    term: 'Весна',
    trans: 'Frühling',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Осень',
    trans: 'Herbst',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Цветы',
    trans: 'Blumen',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Лето',
    trans: 'Sommer',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'грязный/ -ная/ -ное',
    trans: 'schmutzig',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Ветер',
    trans: 'Wind',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Небо',
    trans: 'Himmel',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'сильный/ -ная/ -ное',
    trans: 'stark',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Облака',
    trans: 'Wolken',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'плюс',
    trans: 'plus',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'минус',
    trans: 'minus',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Температура',
    trans: 'Temperatur',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Градус',
    trans: 'Grad',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Солнце',
    trans: 'Sonne',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'отлично',
    trans: 'ausgezeichnet',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'красивый',
    trans: 'wunderschön 👆',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Сад',
    trans: 'Garten',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Туман',
    trans: 'Nebel',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Море',
    trans: 'Meer',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Звезда',
    trans: 'Stern',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Север',
    trans: 'Norden',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Юг',
    trans: 'Süden',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Запад',
    trans: 'Westen',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Восток',
    trans: 'Osten',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Команда',
    trans: 'Team',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Футболист',
    trans: 'Fußballspieler',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'Футбольный мяч',
    trans: 'Fußball Ball',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'большой/ -ая/ -ое',
    trans: 'groß',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'красивый/ -ая/ -ое',
    trans: 'schön',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'умный/ -ая/ -ое',
    trans: 'klug',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'быстрый/ -ая/ -ое',
    trans: 'schnell',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'вкусный/ -ая/ -ое',
    trans: 'lecker',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'новый/ -ая/ -ое',
    trans: 'neu',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'старый/ -ая/ -ое',
    trans: 'alt',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'горячий/ -ая/ -ое',
    trans: 'heiß',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'холодный/ -ая/ -ое',
    trans: 'kalt',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
  WordSpaced(
    term: 'длинный/ -ая/ -ое',
    trans: 'lang',
    isKnown: false,
    repetitions: 0,
    intervalIndex: 0,
    nextReviewDate: 1681329144211,
  ),
];

