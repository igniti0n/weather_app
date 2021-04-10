import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.red,
                  ),
                )
              ],
            ),
            Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    color: Colors.orange,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
