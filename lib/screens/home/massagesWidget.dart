import 'package:dating_app/models/massage.dart';
import 'package:dating_app/models/userData.dart';
import 'package:dating_app/screens/home/massageWidget.dart';
import 'package:dating_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesWidget extends StatelessWidget {
  final String uid;

  const MessagesWidget({
    @required this.uid,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);

    return StreamBuilder<List<Message>>(
      stream: DatabaseService.getMessages(uid, user.uid),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return buildText('Something Went Wrong Try later');
            } else {
              final messages = snapshot.data;

              return messages.isEmpty
                  ? buildText('Say Hi..')
                  : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return MessageWidget(
                      uid: uid,
                      message: message,
                      isMe: message.uid != user.uid,
                  );
                },
              );
            }
        }
      },
    );
  }

  Widget buildText(String text) => Center(
    child: Text(
      text,
      style: TextStyle(fontSize: 24),
    ),
  );
}
