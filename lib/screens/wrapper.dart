import 'package:dating_app/models/userData.dart';
import 'package:dating_app/screens/authenticate/authenticate.dart';
import 'package:dating_app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);

    if (user == null){
      return Authenticate();
    } else {
      return Home();
    }
    
  }
}