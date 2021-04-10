import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interview_app/presentation/home_screen/home_screen.dart';

const String ROUTE_HOME_SCREEN = "/home";

Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case ROUTE_HOME_SCREEN:
      return MaterialPageRoute(builder: (_) => HomeScreen());

    default:
      return MaterialPageRoute(builder: (_) => HomeScreen());
  }
}
