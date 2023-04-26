import 'package:flutter/material.dart';

class PigPage extends StatefulWidget {
  const PigPage({Key? key}) : super(key: key);

  @override
  State<PigPage> createState() => _PigPageState();
}

class _PigPageState extends State<PigPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Center(
              child: Text(
                "Du Sau 👆",
                style: TextStyle(fontSize: 25),
              ),
            )),
        body: Column(
          children: [
            Flexible(
              child: Image.asset(
                'assets/images/pid_dance_gif.gif',
                height: double.infinity,
                width: double.infinity,
              ),),
            Flexible(child: Image.asset(
              'assets/images/waddles_gif.gif',
              height: double.infinity,
              width: double.infinity,
            ),),
            Flexible(child: Image.asset(
              'assets/images/cute_pig_gif.gif',
              height: double.infinity,
              width: double.infinity,
            ),)
          ],
        ));
  }
}
