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
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
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
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> pages = const <Widget>[];

  int index = 0;
  final screens = [const HomePage(), const WordListPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scaffold(
            body: screens[index],
            bottomNavigationBar: NavigationBarTheme(
              data: NavigationBarThemeData(
                  indicatorColor: Colors.black12,
                  labelTextStyle: MaterialStateProperty.all(const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400))),
              child: NavigationBar(
                height: 60,
                backgroundColor: const Color(0xFF414142),
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
