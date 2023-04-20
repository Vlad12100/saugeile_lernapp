import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqlliteteste/pages/home_page.dart';
import 'package:sqlliteteste/pages/word_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App für die Sau 🐖',
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();

// final controllerTerm = TextEditingController();
// final controllerTrans = TextEditingController();
//
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//       appBar: AppBar(
//         title: const Text('sqflite'),
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(16),
//         children: <Widget>[
//           TextField(
//             controller: controllerTerm,
//             decoration: InputDecoration(
//                 hintText: "Deutsches Wort...",
//                 hintStyle: TextStyle(
//                     color: Colors.purple,
//                     fontStyle: FontStyle.italic
//                 )
//             ),
//           ),
//           TextField(
//             controller: controllerTrans,
//             decoration: InputDecoration(
//                 hintText: "Übersetzung...",
//                 hintStyle: TextStyle(
//                     color: Colors.purple,
//                     fontStyle: FontStyle.italic
//                 )
//             ),
//           ),
//           SizedBox(
//             height: 50,
//           ),
//           ElevatedButton(
//               onPressed: () {},
//               child: Text("SEND")
//           ),
//           Container(
//             height: 300,
//             width: 200,
//           )
//         ],
//       ),
//   );
// }
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> pages = const <Widget>[];

  int index = 0;
  final screens = [HomePage(), WordListPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.black12,
        //   title: const Text("Vokabel lern App"),
        //   elevation: 5,
        // ),
        body: Scaffold(
            body: screens[index],
            bottomNavigationBar: NavigationBarTheme(
              data: NavigationBarThemeData(
                  indicatorColor: Colors.black12,
                  labelTextStyle: MaterialStateProperty.all(const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400))),
              child: NavigationBar(
                height: 60,
                backgroundColor: Color(0xFF414142),
                selectedIndex: index,
                onDestinationSelected: (index) =>
                    setState(() => this.index = index),
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.adb), label: "Lernen"),
                  NavigationDestination(
                      icon: Icon(Icons.ad_units), label: "Vokabular")
                ],
              ),
            )));
  }
}
