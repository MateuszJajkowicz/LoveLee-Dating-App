import 'package:dating_app/models/userData.dart';
import 'package:dating_app/services/database.dart';
import 'package:dating_app/shared/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class UserProfileSettings extends StatefulWidget {
  @override
  _UserProfileSettingsState createState() => _UserProfileSettingsState();
}

class _UserProfileSettingsState extends State<UserProfileSettings> {

  final _formKey = GlobalKey<FormState>();
  final List<int> age = [for(var i=1896; i<2004; i+=1) i];
  final List<int> height = [for(var i=0; i<251; i+=1) i];
  final List<String> gender = ['Male', 'Female'];
  final List<String> hairColor = ['Blond', 'Brown', 'Dark'];
  final List<String> hairLength = ['Short', 'Medium', 'Long'];
  final List<String> cigarettes = ["Smoking", 'Do not smoke', 'Sometimes', 'I prefer not to say'];
  final List<String> alcohol = ["Drinking", 'Do not drink', 'Sometimes', 'I prefer not to say'];
  final List<String> interests = ["Music", 'Movies', 'Books', 'Video Games', 'Cars', 'Fashion', 'Sport', 'Cooking', 'Dancing'];
  final List<String> politics = ["Liberal / Left", 'Centrist', 'Conservative / Right', 'Other'];

  // form values
  String _currentName;
  String _currentGender;
  String _currentHairColor;
  String _currentHairLength;
  String _currentCigarettes;
  String _currentAlcohol;
  String _currentPolitics;
  int _currentAge;
  int _currentHeight;
  bool _currentWantToBePaired;
  bool _currentWantToBePairedRandomly;
  File _imageFile;
  String _uploadedFileURL;
  GeoPoint _currentPosition;
  List<dynamic> _currentInterests = [];
  bool updated = false;

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);
    GeoPoint position;

    Future<void> _pickImage(ImageSource source) async{
      File selected = File(await ImagePicker().getImage(source: source, imageQuality: 50).then((pickedFile) => pickedFile.path));

      setState(() {
        _imageFile = selected;
      });
    }

    Future<GeoPoint> getCurrentLocation() async {
      try {
        Location location = Location();
        LocationData locationData;
        locationData = await location.getLocation();
        position = GeoPoint(locationData.latitude, locationData.longitude);
        setState(() {
          updated = true;
        });
        print(position);
      } catch (e) {
        print(e);
      }
      return position;
    }

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

    uploadFile(File image) async {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('avatarImages/image' + DateTime.now().toString());
      UploadTask uploadTask = ref.putFile(image);
      uploadTask.then((res) async {
        _uploadedFileURL = await res.ref.getDownloadURL();
        await DatabaseService(uid: user.uid).updateUserData(uid: user.uid, avatarUrl: _uploadedFileURL);
      });
    }

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
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
                      title: const Text('User Profile'),
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
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Update your profile settings',
                                    style: TextStyle(fontSize: 22.0),
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(width: 50.0),
                                      if(_imageFile != null) ... [
                                        Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.fitWidth,
                                                  image: FileImage(_imageFile, scale: 50.0)
                                              )
                                          )
                                        ),
                                      ] else ... [
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
                                      ],
                                    PopupMenuButton(
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 1,
                                          child: Icon(Icons.camera_alt)
                                        ),
                                        PopupMenuItem(
                                          value: 2,
                                          child: Icon(Icons.insert_photo),
                                        ),
                                      ],
                                      onSelected: (value) async {
                                          if(value == 1){
                                            await _pickImage(ImageSource.camera);
                                          }
                                          if(value == 2){
                                            await _pickImage(ImageSource.gallery);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 20.0),
                                      RaisedButton(
                                          elevation: 0.0,
                                          color: Colors.red[400],
                                          child: Text(
                                            'Update your location',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () async {
                                            var position = await getCurrentLocation();
                                            _currentPosition =  position;
                                            updated = true;
                                          }
                                      ),
                                      if(updated)
                                        Icon(Icons.check_circle, color: Colors.red[400],),
                                      if(!updated)
                                        Icon(Icons.check_circle, color: Colors.grey[100],),
                                    ],
                                  ),
                                  SizedBox(height: 20.0),

                                  TextFormField(
                                    initialValue: userData.name,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: 'Name',
                                      labelStyle: TextStyle(color: Colors.grey[600]),
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
                                    validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                                    onChanged: (val) => setState(() => _currentName = val),
                                  ),
                                  SizedBox(height: 20.0),
                                  Container(
                                    height: 60.0,
                                    child: DropdownButtonFormField(
                                      value: _currentGender ?? userData.gender,
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
                                      items: gender.map((gender) {
                                        return DropdownMenuItem(
                                          value: gender,
                                          child: Text('$gender'),
                                        );
                                      }).toList(),
                                      onChanged: (value) => setState(() => _currentGender = value ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'I want to be paired',
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Switch(
                                          value: _currentWantToBePaired ?? userData.wantToBePaired,
                                          onChanged: (value) {
                                            setState(() {
                                              _currentWantToBePaired = value;
                                            });
                                          },
                                          activeTrackColor: Colors.red[100],
                                          activeColor: Colors.red[400],
                                          inactiveTrackColor: Colors.red[100],
                                          inactiveThumbColor: Colors.red[100],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            'I want to be paired randomly',
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Switch(
                                            value: _currentWantToBePairedRandomly ?? userData.wantToBePairedRandomly,
                                            onChanged: (value) {
                                              setState(() {
                                                _currentWantToBePairedRandomly = value;
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
                                  RaisedButton(
                                      elevation: 0.0,
                                      color: Colors.red[400],
                                      child: Text(
                                        'Update your interests',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        _showSettingsPanel(userData.interests);
                                      }
                                  ),
                                  SizedBox(height: 20.0),
                                  Container(
                                    height: 60.0,
                                    child: DropdownButtonFormField(
                                      value: _currentAge ?? userData.age,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'Year of birth',
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
                                      items: age.map((age) {
                                        return DropdownMenuItem(
                                          value: age,
                                          child: Text('$age'),
                                        );
                                      }).toList(),
                                      onChanged: (value) => setState(() => _currentAge = value ),
                                    ),
                                  ),
                                  SizedBox(height: 30.0),
                                  Container(
                                    height: 60.0,
                                    child: DropdownButtonFormField(
                                      isDense: false,
                                      itemHeight: 50.0,
                                      value: _currentHeight ?? userData.height,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'Height',
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
                                      items: height.map((height) {
                                        return DropdownMenuItem(
                                          value: height,
                                          child: Text('$height m'),
                                        );
                                      }).toList(),
                                      onChanged: (value) => setState(() => _currentHeight = value ),
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Container(
                                    height: 60.0,
                                    child: DropdownButtonFormField(
                                      value: _currentHairColor ?? userData.hairColor,
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
                                      value: _currentHairLength ?? userData.hairLength,
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
                                      //decoration: textInputDecoration,
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
                                      value: _currentCigarettes ?? userData.cigarettes,
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
                                      //decoration: textInputDecoration,
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
                                      value: _currentAlcohol ?? userData.alcohol,
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
                                  Container(
                                    height: 60.0,
                                    child: DropdownButtonFormField(
                                      value: _currentPolitics ?? userData.politics,
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
                                  RaisedButton(
                                    elevation: 0.0,
                                    color: Colors.red[400],
                                    child: Text(
                                      'Update',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      if(_formKey.currentState.validate()){
                                        if(_imageFile != null){
                                          await uploadFile(_imageFile);
                                        }
                                        await DatabaseService(uid: user.uid).updateUserData(
                                          uid: user.uid,
                                          isNewUser: true,
                                          lid: snapshot.data.lid,
                                          name: _currentName ?? snapshot.data.name,
                                          age: _currentAge ?? snapshot.data.age,
                                          height: _currentHeight ?? snapshot.data.height,
                                          wantToBePaired: _currentWantToBePaired ?? snapshot.data.wantToBePaired,
                                          wantToBePairedRandomly: _currentWantToBePairedRandomly ?? snapshot.data.wantToBePairedRandomly,
                                          gender: _currentGender ?? snapshot.data.gender,
                                          hairColor: _currentHairColor ?? snapshot.data.hairColor,
                                          hairLength: _currentHairLength ?? snapshot.data.hairLength,
                                          cigarettes: _currentCigarettes ?? snapshot.data.cigarettes,
                                          alcohol: _currentAlcohol ?? snapshot.data.alcohol,
                                          position: _currentPosition ?? snapshot.data.position,
                                          politics: _currentPolitics ?? snapshot.data.politics,
                                          isUserProfileUpdated: true,
                                        );
                                        if(_currentInterests.length != 0){
                                          await DatabaseService(uid: user.uid).updateUserData(uid: user.uid, interests: _currentInterests);
                                        }
                                        if(updated){
                                          await DatabaseService(uid: user.uid).updateUserData(uid: user.uid, isPositionUpdated: true);
                                        }
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