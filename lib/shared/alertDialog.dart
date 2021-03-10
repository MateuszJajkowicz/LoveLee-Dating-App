// import 'package:dating_app/models/userData.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
//
// class MyAlertDialog extends StatelessWidget {
//
//   final UserData args = ModalRoute.of(context).settings.arguments;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: AlertDialog(
//         title: Text("We are sorry, but you don't have pair now"),
//         content: SingleChildScrollView(
//           child: ListBody(
//             children: <Widget>[
//               Text("Try search for pair!"),
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           FlatButton.icon(
//             icon: Icon(Icons.mood),
//             label: Text('Yes!'),
//             onPressed: () async {
//               print(user.uid);
//               print(user.lid);
//               await DatabaseService(uid: user.uid).updateUserData(uid: user.uid, pairedDate: DateTime.now().millisecondsSinceEpoch);
//               await DatabaseService(uid: args.lid).updateUserData(uid: args.lid, pairedDate: DateTime.now().millisecondsSinceEpoch);
//               Navigator.of(context).pop();
//             },
//           ),
//           FlatButton.icon(
//             icon: Icon(Icons.mood_bad),
//             label: Text('No'),
//             onPressed: () async {
//               await DatabaseService(uid: user.uid).updateUserData(uid: user.uid, lid: 'null', pairedDate: DateTime(2020, 01, 01).millisecondsSinceEpoch);
//               await DatabaseService(uid: user.lid).updateUserData(uid: user.lid, lid: 'null', pairedDate: DateTime(2020, 01, 01).millisecondsSinceEpoch);
//               //Navigator.pushNamed(context, '/home');
//               Navigator.popAndPushNamed(context, '/home');
//               //Navigator.of(context).pop();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }