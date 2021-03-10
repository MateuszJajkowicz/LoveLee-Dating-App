import 'package:dating_app/models/userData.dart';
import 'package:dating_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NewMessageWidget extends StatefulWidget {
  final String uid;
  final String name;
  final String avatarUrl;

  const NewMessageWidget({
    @required this.uid,
    @required this.name,
    @required this.avatarUrl,
    Key key,
  }) : super(key: key);

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final _controller = TextEditingController();
  String message = '';

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);

    void sendMessage() async {
      FocusScope.of(context).unfocus();
      await DatabaseService(uid: user.uid).uploadMessage(widget.uid, widget.name, message, widget.avatarUrl);
      _controller.clear();
    }

    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              cursorColor: Colors.red,
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Type your message',
                labelStyle: TextStyle(color: Colors.red[400]),
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
              ),
              onChanged: (value) =>
                  setState(() {
                    message = value;
                  }),
            ),
          ),
          SizedBox(width: 20),
          GestureDetector(
            onTap: message.trim().isEmpty ? null : sendMessage,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red[400],
              ),
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

