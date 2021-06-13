import 'package:flutter/material.dart';

Widget roundImage(double height, String url) {
  return Container(
    width: height,
    height: height,
    decoration: BoxDecoration(
      color: Colors.red,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          spreadRadius: 0.0,
          offset: Offset(2.0, 2.0), //(x,y)
          blurRadius: 5.0,
        )
      ],
      image: DecorationImage(image: NetworkImage('$url'), fit: BoxFit.fill),
    ),
  );
}
