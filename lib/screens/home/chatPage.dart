import 'package:dating_app/models/userData.dart';
import 'package:dating_app/screens/home/massagesWidget.dart';
import 'package:dating_app/screens/home/newMassageWidget.dart';
import 'package:dating_app/screens/home/profileHeaderWidget.dart';
import 'package:dating_app/services/database.dart';
import 'package:dating_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);

    final UserData args = ModalRoute.of(context).settings.arguments;

    var diff = DateTime.now().difference((DateTime.fromMillisecondsSinceEpoch(args.pairedDate)));
    print(diff.inMinutes);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: args.lid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData && diff.inMinutes < 2) {
            UserData userData = snapshot.data;
            return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.red[400],
              body: SafeArea(
                child: Column(
                  children: [
                    ProfileHeaderWidget(lid: args.lid, name: userData.name, avatarUrl: userData.avatarUrl),
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
                        child: MessagesWidget(uid: userData.uid),
                      ),
                    ),
                    NewMessageWidget(uid: userData.uid, name: userData.name, avatarUrl: args.avatarUrl)
                  ],
                ),
              ),
            );
    }
        if(diff.inMinutes >= 2){
          return Container(
              color: Colors.grey[100],
              child:
              AlertDialog(
                title: Text("Hey there!"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text("Do you want to chat with that person for 2 more days?"),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton.icon(
                    icon: Icon(Icons.mood),
                    label: Text('Yes!'),
                    onPressed: () async {
                      await DatabaseService(uid: user.uid).updateUserData(uid: user.uid, pairedDate: DateTime.now().millisecondsSinceEpoch);
                      await DatabaseService(uid: args.lid).updateUserData(uid: args.lid, pairedDate: DateTime.now().millisecondsSinceEpoch);
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton.icon(
                    icon: Icon(Icons.mood_bad),
                    label: Text('No'),
                    onPressed: () async {
                      await DatabaseService(uid: user.uid).deleteMessages(user.uid);
                      await DatabaseService(uid: args.lid).updateUserData(uid: args.lid, lid: 'null', pairedDate: DateTime(2020, 01, 01).millisecondsSinceEpoch);
                      await DatabaseService(uid: user.uid).updateUserData(uid: user.uid, lid: 'null', pairedDate: DateTime(2020, 01, 01).millisecondsSinceEpoch);
                      Navigator.popAndPushNamed(context, '/home');
                    },
                  ),
                ],
              ),
          );
        } else {
            return Loading();
          }
      });
    }
}
