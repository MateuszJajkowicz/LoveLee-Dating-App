import 'package:dating_app/models/userData.dart';
import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String lid;
  final String name;
  final String avatarUrl;

  const ProfileHeaderWidget({
    @required this.lid,
    @required this.name,
    @required this.avatarUrl,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 80.0,
      padding: EdgeInsets.all(16).copyWith(left: 0),
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, '/loverProfile', arguments: UserData(lid: lid));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(color: Colors.white),
                CircleAvatar(radius: 16, backgroundImage: NetworkImage(avatarUrl)),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 4),
              ],
            ),
          )
        ],
      ),
    );
  }

    Widget buildIcon(IconData icon) {
      return Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white54,
        ),
        child: Icon(icon, size: 25, color: Colors.white),
      );
    }

  }

