import 'package:dating_app/models/userData.dart';
import 'package:dating_app/services/database.dart';
import 'package:dating_app/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/shared/constants.dart';

class LoverProfile extends StatelessWidget {

  final List<String> interests = ["Music", 'Movies', 'Books', 'Video Games', 'Cars', 'Fashion', 'Sport', 'Cooking', 'Dancing'];

  @override
  Widget build(BuildContext context) {

    final UserData args = ModalRoute.of(context).settings.arguments;

    Future<void> _showSettingsPanel(List<dynamic> userInterests) async {
      showModalBottomSheet(context: context, builder: (context) {
        return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                child: ListView.builder(
                  itemCount: interests.length,
                  itemBuilder: (BuildContext context, int index){
                    return CheckboxListTile(
                      title: Text(interests[index].toString()
                      ),
                      value: userInterests[index],
                      onChanged: (bool newValue) {
                        setState(() {
                        });
                      },
                    );
                  },
                ),
              );
            });
      });
    }

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: args.lid).userData,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            UserData userData = snapshot.data;
            return Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.red[400],
              body: SafeArea(
                child: Column(
                  children: [
                    AppBar(
                      toolbarHeight: 60.0,
                      elevation: 0.0,
                      backgroundColor: Colors.red[400],
                      title: const Text('Lover Profile'),
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
                          padding: EdgeInsets.fromLTRB(42, 20, 42, 20),
                          child: Form(
                            //key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 10.0),
                                  Container(
                                      width: 100.0,
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.fitWidth,
                                              image: NetworkImage(userData.avatarUrl)
                                          )
                                      )
                                  ),
                                  SizedBox(height: 20.0),
                                  Container(
                                    child: TextFormField(
                                      enabled: false,
                                      initialValue: userData.name,
                                      decoration: CommonStyle.textFieldStyle(labelTextStr: 'Name'),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  TextFormField(
                                    enabled: false,
                                    initialValue: userData.gender,
                                    decoration: CommonStyle.textFieldStyle(labelTextStr: 'Gender'),
                                  ),
                                  SizedBox(height: 20.0),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          foregroundColor: MaterialStateProperty.all<Color>(Colors.red[400]),
                                          elevation: MaterialStateProperty.all(0.0),
                                      ),
                                      child: Text(
                                        'Lover interests',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        _showSettingsPanel(userData.interests);
                                      }
                                  ),
                                  SizedBox(height: 20.0),
                                  TextFormField(
                                    enabled: false,
                                    initialValue: userData.age.toString(),
                                    decoration: CommonStyle.textFieldStyle(labelTextStr: 'Age'),
                                  ),
                                  SizedBox(height: 20.0),
                                  TextFormField(
                                    enabled: false,
                                    initialValue: userData.height.toString(),
                                    decoration: CommonStyle.textFieldStyle(labelTextStr: 'Height'),
                                  ),
                                  SizedBox(height: 20.0),
                                  TextFormField(
                                    enabled: false,
                                    initialValue: userData.hairColor,
                                    decoration: CommonStyle.textFieldStyle(labelTextStr: 'Hair color'),
                                  ),
                                  SizedBox(height: 20.0),
                                  TextFormField(
                                    enabled: false,
                                    initialValue: userData.hairLength,
                                    decoration: CommonStyle.textFieldStyle(labelTextStr: 'Hair length'),
                                  ),
                                  SizedBox(height: 20.0),
                                  TextFormField(
                                    enabled: false,
                                    initialValue: userData.cigarettes,
                                    decoration: CommonStyle.textFieldStyle(labelTextStr: 'Attitude to cigarettes'),
                                  ),
                                  SizedBox(height: 20.0),
                                  TextFormField(
                                    maxLength: 50,
                                    enabled: false,
                                    initialValue: userData.alcohol,
                                    decoration: CommonStyle.textFieldStyle(labelTextStr: 'Attitude to alcohol'),
                                  ),
                                  TextFormField(
                                    maxLength: 50,
                                    enabled: false,
                                    initialValue: userData.politics,
                                    decoration: CommonStyle.textFieldStyle(labelTextStr: 'Political beliefs'),
                                  ),
                                ],
                              ),
                            ),
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
        }
    );
  }
}