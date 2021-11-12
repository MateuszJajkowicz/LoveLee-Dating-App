import 'dart:async';
import 'package:dating_app/services/auth.dart';
import 'package:dating_app/services/database.dart';
import 'package:dating_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/models/userData.dart';


class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("We are sorry, but you don't have pair now"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Try search for pair!"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton.icon(
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

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userdata = snapshot.data;
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.red[400],
            body: SafeArea(
              child: Column(
                children: [
                  AppBar(
                    toolbarHeight: 60.0,
                    title: Text('LoveLee Dating App'),
                    backgroundColor: Colors.red[400],
                    elevation: 0.0,
                    actions: <Widget>[
                      TextButton.icon(
                        icon: Icon(Icons.exit_to_app),
                        label: Text('Logout'),
                        onPressed: () async {
                          await _auth.signOut();
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
                    ),
                  ),

                  BottomAppBar(
                    color: Colors.red[400],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                                Icons.search
                            ),
                            onPressed: () async {
                              Navigator.pushNamed(context, '/findingPage', arguments: UserData(lid: userdata.lid, position: userdata.position, isPositionUpdated: userdata.isPositionUpdated, isUserProfileUpdated: userdata.isUserProfileUpdated, isLoverProfileUpdated: userdata.isLoverProfileUpdated,));
                            }
                        ),
                        IconButton(
                            icon: Icon(
                                Icons.chat
                            ),
                            onPressed: () {
                              if(userdata.lid != 'null') {
                                // Timer(Duration(seconds: 10), () {
                                //   _showMyDialog2(userdata.lid);
                                // });
                                Navigator.pushNamed(context, '/chatPage', arguments: UserData(lid: userdata.lid, avatarUrl: userdata.avatarUrl, pairedDate: userdata.pairedDate));
                              } else _showMyDialog();
                            }
                        ),
                        IconButton(
                            icon: Icon(
                                Icons.person
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/userProfileSettings');
                            }
                          //=> _showSettingsPanel()
                        ),
                        IconButton(
                            icon: Icon(
                                Icons.favorite
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/loverProfileSettings');
                            }
                        ),
                      ],
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