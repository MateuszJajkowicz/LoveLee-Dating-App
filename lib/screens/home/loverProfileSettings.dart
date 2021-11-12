import 'package:dating_app/models/userData.dart';
import 'package:dating_app/models/loverData.dart';
import 'package:dating_app/services/database.dart';
import 'package:dating_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoverProfileSettings extends StatefulWidget {
  @override
  _LoverProfileSettingsState createState() => _LoverProfileSettingsState();
}

class _LoverProfileSettingsState extends State<LoverProfileSettings> {

  final _formKey = GlobalKey<FormState>();

  final List<int> age = [for(var i=18; i<121; i+=1) i];
  final List<String> gender = ['Male', 'Female'];
  final List<String> hairColor = ['Blond', 'Brown', 'Dark'];
  final List<String> hairLength = ['Short', 'Medium', 'Long'];
  final List<String> cigarettes = ["Smoking", 'Do not smoke', 'Sometimes', 'I prefer not to say'];
  final List<String> alcohol = ["Drinking", 'Do not drink', 'Sometimes', 'I prefer not to say'];
  final List<String> interests = ["Music", 'Movies', 'Books', 'Video Games', 'Cars', 'Fashion', 'Sport', 'Cooking', 'Dancing'];
  final List<int> distance = [for(var i=10; i<500; i+=10) i];
  final List<String> politics = ["Liberal / Left", 'Centrist', 'Conservative / Right', 'Other'];

  // form values
  RangeValues _currentAgeValues;
  String _currentGender;
  String _currentHairColor;
  String _currentHairLength;
  int _currentAgeMin;
  int _currentAgeMax;
  RangeValues _currentHeightValues;
  int _currentHeightMin;
  int _currentHeightMax;
  int _currentDistance;
  bool _currentHaveAvatar;
  String _currentCigarettes;
  String _currentAlcohol;
  String _currentPolitics;
  List<dynamic> _currentInterests = [];

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);

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
                      //secondary: Icon(Icons.assignment),
                      onChanged: (bool newValue) {
                        setState(() {
                          userInterests[index] = newValue;
                          _currentInterests = userInterests;
                          print(_currentInterests);
                        });
                      },
                    );
                  },
                ),
              );
            });
      });
    }

    return StreamBuilder<LoverData>(
        stream: DatabaseService(uid: user.uid).loverData,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            LoverData loverData = snapshot.data;
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
                      title: const Text('Lover Profile Settings'),
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
                          padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Update your lover settings',
                                    style: TextStyle(fontSize: 22.0),
                                  ),
                                  SizedBox(height: 20.0),
                                  Container(
                                    height: 60.0,
                                    child: DropdownButtonFormField(
                                      value: _currentGender ?? loverData.gender,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'Gender',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red[400], width: 1),
                                          gapPadding: 10,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red[400], width: 1),
                                          gapPadding: 10,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                      ),
                                      //decoration: textInputDecoration,
                                      items: gender.map((gender) {
                                        return DropdownMenuItem(
                                          value: gender,
                                          child: Text('$gender'),
                                        );
                                      }).toList(),
                                      onChanged: (value) => setState(() => _currentGender = value ),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                        foregroundColor: MaterialStateProperty.all<Color>(Colors.red[400]),
                                        elevation: MaterialStateProperty.all(0.0),
                                      ),
                                      child: Text(
                                        'Update lover interests',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        _showSettingsPanel(loverData.interests);
                                      }
                                  ),
                                  SizedBox(height: 20.0),
                                  Text(
                                    "Min age: ${_currentAgeMin ?? loverData.ageMin.round()}, Max age: ${_currentAgeMax ?? loverData.ageMax.round()}",
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  RangeSlider (
                                    activeColor: Colors.red[400],
                                    inactiveColor: Colors.red[100],
                                    values: (_currentAgeValues ?? RangeValues(loverData.ageMin.toDouble(), loverData.ageMax.toDouble())),
                                    min: 0,
                                    max: 120,
                                    divisions: 120,
                                    onChanged: (RangeValues values) {
                                      setState(() {
                                        _currentAgeValues = values;
                                        _currentAgeMin = values.start.toInt();
                                        _currentAgeMax = values.end.toInt();
                                      });
                                    },
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    "Min height: ${_currentHeightMin ?? loverData.heightMin.round()}, Max height: ${_currentHeightMax ?? loverData.heightMax.round()}",
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  RangeSlider (
                                    activeColor: Colors.red[400],
                                    inactiveColor: Colors.red[100],
                                    values: (_currentHeightValues ?? RangeValues(loverData.heightMin.toDouble(), loverData.heightMax.toDouble())),
                                    min: 0,
                                    max: 250,
                                    divisions: 250,
                                    onChanged: (RangeValues values) {
                                      setState(() {
                                        _currentHeightValues = values;
                                        _currentHeightMin = values.start.toInt();
                                        _currentHeightMax = values.end.toInt();
                                      });
                                    },
                                  ),
                                  Text(
                                    "Distance: ${_currentDistance ?? loverData.distance.round()} km",
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  Slider(
                                    activeColor: Colors.red[400],
                                    inactiveColor: Colors.red[100],
                                    value: (_currentDistance ?? loverData.distance).toDouble(),
                                    min: 10.0,
                                    max: 500.0,
                                    divisions: 49,
                                    onChanged: (val) => setState(() => _currentDistance = val.round()),
                                  ),
                                  SizedBox(height: 10.0),
                                  Container(
                                    height: 60.0,
                                    child: DropdownButtonFormField(
                                      value: _currentHairColor ?? loverData.hairColor,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'Hair color',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red[400], width: 1),
                                          gapPadding: 10,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red[400], width: 1),
                                          gapPadding: 10,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                      ),
                                      items: hairColor.map((hairColor) {
                                        return DropdownMenuItem(
                                          value: hairColor,
                                          child: Text('$hairColor'),
                                        );
                                      }).toList(),
                                      onChanged: (value) => setState(() => _currentHairColor = value ),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Container(
                                    height: 60.0,
                                    child: DropdownButtonFormField(
                                      value: _currentHairLength ?? loverData.hairLength,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'Hair length',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red[400], width: 1),
                                          gapPadding: 10,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red[400], width: 1),
                                          gapPadding: 10,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                      ),
                                      items: hairLength.map((hairLength) {
                                        return DropdownMenuItem(
                                          value: hairLength,
                                          child: Text('$hairLength'),
                                        );
                                      }).toList(),
                                      onChanged: (value) => setState(() => _currentHairLength = value ),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Container(
                                    height: 60.0,
                                    child: DropdownButtonFormField(
                                      value: _currentCigarettes ?? loverData.cigarettes,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'Attitude to cigarettes',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red[400], width: 1),
                                          gapPadding: 10,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red[400], width: 1),
                                          gapPadding: 10,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                      ),
                                      items: cigarettes.map((cigarettes) {
                                        return DropdownMenuItem(
                                          value: cigarettes,
                                          child: Text('$cigarettes'),
                                        );
                                      }).toList(),
                                      onChanged: (value) => setState(() => _currentCigarettes = value ),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Container(
                                    height: 60.0,
                                    child: DropdownButtonFormField(
                                      value: _currentAlcohol ?? loverData.alcohol,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'Attitude to alcohol',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red[400], width: 1),
                                          gapPadding: 10,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red[400], width: 1),
                                          gapPadding: 10,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                      ),
                                      items: alcohol.map((alcohol) {
                                        return DropdownMenuItem(
                                          value: alcohol,
                                          child: Text('$alcohol'),
                                        );
                                      }).toList(),
                                      onChanged: (value) => setState(() => _currentAlcohol = value ),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'I want my partner to have his own avatar',
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Switch(
                                            value: _currentHaveAvatar ?? loverData.haveAvatar,
                                            onChanged: (value) {
                                              setState(() {
                                                _currentHaveAvatar = value;
                                              });
                                            },
                                            activeTrackColor: Colors.red[100],
                                            activeColor: Colors.red[400],
                                            inactiveTrackColor: Colors.red[100],
                                            inactiveThumbColor: Colors.red[100],
                                          )
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  Container(
                                    height: 60.0,
                                    child: DropdownButtonFormField(
                                      value: _currentPolitics ?? loverData.politics,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'Political beliefs',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red[400], width: 1),
                                          gapPadding: 10,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red[400], width: 1),
                                          gapPadding: 10,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                      ),
                                      //decoration: textInputDecoration,
                                      items: politics.map((politic) {
                                        return DropdownMenuItem(
                                          value: politic,
                                          child: Text('$politic'),
                                        );
                                      }).toList(),
                                      onChanged: (value) => setState(() => _currentPolitics = value ),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                        foregroundColor: MaterialStateProperty.all<Color>(Colors.red[400]),
                                      ),
                                      child: Text(
                                        'Update',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        if(_formKey.currentState.validate()){
                                          //await DatabaseService(uid: user.uid).check();
                                          await DatabaseService(uid: user.uid).updateLoverData(
                                            gender: _currentGender ?? snapshot.data.gender,
                                            ageMin: _currentAgeMin ?? snapshot.data.ageMin,
                                            ageMax: _currentAgeMax ?? snapshot.data.ageMax,
                                            heightMin: _currentHeightMin ?? snapshot.data.heightMin,
                                            heightMax: _currentHeightMax ?? snapshot.data.heightMax,
                                            hairColor: _currentHairColor ?? snapshot.data.hairColor,
                                            hairLength: _currentHairLength ?? snapshot.data.hairLength,
                                            cigarettes: _currentCigarettes ?? snapshot.data.cigarettes,
                                            alcohol: _currentAlcohol ?? snapshot.data.alcohol,
                                            distance: _currentDistance ?? snapshot.data.distance,
                                            haveAvatar: _currentHaveAvatar ?? snapshot.data.haveAvatar,
                                            politics: _currentPolitics ?? snapshot.data.politics,
                                          );
                                          if(_currentInterests.length != 0){
                                            await DatabaseService(uid: user.uid).updateLoverData(interests: _currentInterests);
                                          }
                                          await DatabaseService(uid: user.uid).updateUserData(uid: user.uid, isLoverProfileUpdated: true);
                                          Navigator.pop(context);
                                        }
                                      }
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