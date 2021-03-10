import 'package:flutter/material.dart';

class CommonStyle{
  static InputDecoration textFieldStyle({String labelTextStr=""}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelText: labelTextStr,
      labelStyle: TextStyle(color: Colors.grey[600]),
      focusColor: Colors.red,
      hoverColor: Colors.red,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red[400], width: 1,),
        gapPadding: 10,
        borderRadius: BorderRadius.circular(25),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red[400], width: 1,),
        gapPadding: 10,
        borderRadius: BorderRadius.circular(25),
      ),
    );}
}


// final textInputDecoration = InputDecoration(
//   filled: true,
//   fillColor: Colors.white,
//   labelText: 'Name',
//   labelStyle: TextStyle(color: Colors.grey[600]),
//   focusColor: Colors.red,
//   hoverColor: Colors.red,
//   border: OutlineInputBorder(
//     borderSide: BorderSide(color: Colors.red[400], width: 1,),
//     gapPadding: 10,
//     borderRadius: BorderRadius.circular(25),
//   ),
//   focusedBorder: OutlineInputBorder(
//     borderSide: BorderSide(color: Colors.red[400], width: 1,),
//     gapPadding: 10,
//     borderRadius: BorderRadius.circular(25),
//   ),
// );


// fillColor: Colors.white,
// filled: true,
// contentPadding: EdgeInsets.all(12.0),
// enabledBorder: OutlineInputBorder(
//   borderSide: BorderSide(color: Colors.white, width: 2.0),
// ),
// focusedBorder: OutlineInputBorder(
//   borderSide: BorderSide(color: Colors.pink, width: 2.0),
// ),