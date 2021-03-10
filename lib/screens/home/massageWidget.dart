import 'package:dating_app/models/massage.dart';
import 'package:dating_app/models/userData.dart';
import 'package:dating_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageWidget extends StatelessWidget {
  final String uid;
  final Message message;
  final bool isMe;

  const MessageWidget({
    @required this.uid,
    @required this.message,
    @required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);

    return Column(
      children: [
        Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            if (!isMe)
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/loverProfile', arguments: UserData(lid: uid));
                },
                child: CircleAvatar(
                    radius: 16, backgroundImage: NetworkImage(message.avatarUrl)),
              ),
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.fromLTRB(16,16,16,2),
              constraints: BoxConstraints(maxWidth: 140),
              decoration: BoxDecoration(
                color: isMe ? Colors.white : Colors.red[400],
                borderRadius: isMe
                    ? borderRadius.subtract(BorderRadius.only(bottomRight: radius))
                    : borderRadius.subtract(BorderRadius.only(bottomLeft: radius)),
              ),
              child: buildMessage(),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if(!isMe)
              SizedBox(width: 47.0),
            Text('${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(message.createdAt.millisecondsSinceEpoch))}', style: TextStyle(fontSize: 10),),
            if(isMe)
              SizedBox(width: 15.0),
          ],
        ),
      ],
    );
  }

  Widget buildMessage() => Column(
    crossAxisAlignment:
    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        message.message,
        style: TextStyle(color: isMe ? Colors.black : Colors.white),
        textAlign: isMe ? TextAlign.end : TextAlign.start,
      ),
    ],
  );
}
