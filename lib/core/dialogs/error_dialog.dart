import 'dart:io';

import 'package:flutter/material.dart';
import 'package:interview_app/constants.dart';

showErrorDialog(BuildContext ctx) {
  final TextStyle? _style = Theme.of(ctx).textTheme.bodyText1;
  showDialog(
    context: ctx,
    builder: (context) => AlertDialog(
      backgroundColor: medium,
      title: Text(
        "You want to exit?",
        style: _style,
      ),
      actions: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            height: 30,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
                child: Text(
              "No",
              style: _style,
            )),
          ),
        ),
        GestureDetector(
          onTap: () => exit(0),
          child: Container(
            height: 30,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
                child: Text(
              "Exit",
              style: _style,
            )),
          ),
        ),
      ],
    ),
  );
}
