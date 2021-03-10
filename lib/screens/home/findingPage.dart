import 'dart:async';
import 'package:dating_app/models/loverData.dart';
import 'package:dating_app/services/database.dart';
import 'package:dating_app/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/models/userData.dart';

class FindingPage extends StatefulWidget {
  @override
  _FindingPageState createState() => _FindingPageState();
}

class _FindingPageState extends State<FindingPage> {

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);
    final UserData args = ModalRoute.of(context).settings.arguments;
    bool isDisable;
    if(args.lid == 'null' && args.isUserProfileUpdated && args.isLoverProfileUpdated && args.isPositionUpdated){
      isDisable = false;
    } else isDisable = true;

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('We are sorry, but there is no pair for you now.'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Please try again soon or change your criteria.'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.mood_bad),
                label: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _showMyDialog2() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Hello there!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('If both buttons are disabled that means you already have partner or you need to update your and lover profiles, including your position.'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.check),
                label: Text('Ok!'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return StreamBuilder<LoverData>(
        stream: DatabaseService(uid: user.uid).loverData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            LoverData loverData = snapshot.data;
            return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.red[400],
              body: SafeArea(
                child: Column(
                  children: [
                    AppBar(
                      title: Text('LoveLee Dating App'),
                      backgroundColor: Colors.red[400],
                      elevation: 0.0,
                      toolbarHeight: 60.0,
                      actions: <Widget>[
                        FlatButton.icon(
                          icon: Icon(Icons.help),
                          label: Text(''),
                          onPressed: () async {
                            _showMyDialog2();
                          },
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RaisedButton(
                                color: Colors.red[400],
                                child: Text('Find me a pair'),
                                onPressed: isDisable ? null : () async {
                                  String result = await DatabaseService(uid: user.uid).findPair(loverData.gender, loverData.ageMin, loverData.ageMax, loverData.heightMin,
                                    loverData.heightMax, loverData.hairColor, loverData.hairLength, loverData.distance, args.position, loverData.haveAvatar, loverData.interests, loverData.politics);
                                  if(result == 'null'){
                                    _showMyDialog();
                                  } else {
                                    await DatabaseService(uid: user.uid).updateUserData(uid: user.uid, lid: result, pairedDate: DateTime.now().millisecondsSinceEpoch);
                                    await DatabaseService(uid: result).updateUserData(uid: result, lid: user.uid, pairedDate: DateTime.now().millisecondsSinceEpoch);
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                              RaisedButton(
                                color: Colors.red[400],
                                child: Text('Find me a pair randomly'),
                                onPressed: isDisable ? null : () async {
                                  String result = await DatabaseService(uid: user.uid).findPairRandomly(loverData.gender, loverData.ageMin, loverData.ageMax, loverData.distance, args.position );
                                  if(result == 'null'){
                                    _showMyDialog();
                                  } else {
                                    await DatabaseService(uid: user.uid).updateUserData(uid: user.uid, lid: result, pairedDate: DateTime.now().millisecondsSinceEpoch);
                                    await DatabaseService(uid: result).updateUserData(uid: result, lid: user.uid, pairedDate: DateTime.now().millisecondsSinceEpoch);
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Loading();
          }
        });

  }
}