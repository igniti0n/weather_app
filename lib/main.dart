import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interview_app/constants.dart';
import 'package:interview_app/core/navigation/route_generator.dart';
import 'package:interview_app/instance_creator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: createInstances(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container();
          }
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.grey,
              textTheme: TextTheme(
                  bodyText1: TextStyle(
                    fontSize: 16,
                    color: light,
                    fontWeight: FontWeight.bold,
                  ),
                  headline1: TextStyle(
                    fontSize: 24,
                    color: light,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            initialRoute: ROUTE_HOME_SCREEN,
            onGenerateRoute: onGenerateRoute,
          );
        });
  }
}
