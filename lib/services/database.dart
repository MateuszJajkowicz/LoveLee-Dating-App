import 'package:dating_app/models/massage.dart';
import 'package:dating_app/models/userData.dart';
import 'package:dating_app/models/loverData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';


class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference loversCollection = FirebaseFirestore.instance.collection('lovers');

  Future<String> findPair(String gender, int ageMin, int ageMax, int heightMin,
      int heightMax, String hairColor, String hairLength, int distance, GeoPoint position,
      bool haveAvatar, List<dynamic> interests, String politics) async {

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, isNotEqualTo: this.uid)
        .where('lid', isEqualTo: 'null')
        .where('wantToBePaired', isEqualTo: true)
        .get();

    final List<UserData> documents = result.docs.map((doc){
          return UserData(
            uid: doc.get('uid'),
            age: doc.get('age'),
            height: doc.get('height'),
            gender: doc.get('gender'),
            hairColor: doc.get('hairColor'),
            hairLength: doc.get('hairLength'),
            position: doc.get('position'),
            avatarUrl: doc.get('avatarUrl'),
            interests: doc.get('interests'),
            politics: doc.get('politics'),
          );
        }).toList();

    String bestMatch = 'null';
    int counter = 0;
    for (var item in documents ){
      print(item.uid);
      int bestCounter = 0;
      if(item.gender == gender){
        bestCounter += 1;
        print(bestCounter);
      } else continue;
      if(item.height >= heightMin && item.height <= heightMax){
        bestCounter += 1;
        print(bestCounter);
      } else continue;
      if(2021-item.age >= ageMin && 2021-item.age <= ageMax){
        bestCounter += 1;
        print(bestCounter);
      } else continue;
      if(item.hairColor == hairColor){
        bestCounter += 1;
        print(bestCounter);
      } else continue;
      if(item.hairLength == hairLength){
        bestCounter += 1;
        print(bestCounter);
      } else continue;
      if(item.politics == politics){
        bestCounter += 1;
        print(bestCounter);
        print("bestCounter");
      } else continue;
      double startLatitude = item.position.latitude;
      double startLongitude = item.position.longitude;
      double endLatitude = position.latitude;
      double endLongitude = position.longitude;

      double distanceInKilometers = Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude) * 0.001;
      if(distanceInKilometers <= distance.toDouble() ){
        bestCounter += 1;

      } else continue;

      if(haveAvatar) {
        if(item.avatarUrl != 'https://image.freepik.com/free-icon/important-person_318-10744.jpg')
          {
            bestCounter += 1;
          }else continue;
      }

      print(interests);
      print(item.interests);
      if(listEquals(item.interests, interests)){
        bestCounter += 1;
        print("test");
      } else {
        print("test2");
        continue;
      }

      if(bestCounter > counter){
        counter = bestCounter;
        bestMatch = item.uid;
      }
    }
    return bestMatch;
  }

  Future<String> findPairRandomly(String gender, int ageMin, int ageMax, int distance, GeoPoint position,) async {

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, isNotEqualTo: this.uid)
        .where('lid', isEqualTo: 'null')
        .where('wantToBePairedRandomly', isEqualTo: true)
        .get();

    final List<UserData> documents = result.docs.map((doc){
      return UserData(
        uid: doc.get('uid'),
        age: doc.get('age'),
        gender: doc.get('gender'),
        position: doc.get('position'),
      );
    }).toList();

    String bestMatch = 'null';
    int counter = 0;
    for (var item in documents ){
      int bestCounter = 0;
      if(item.gender == gender){
        bestCounter += 1;
      } else continue;
      if(2021-item.age >= ageMin && 2021-item.age <= ageMax){
        bestCounter += 1;
      } else continue;

      double startLatitude = item.position.latitude;
      double startLongitude = item.position.longitude;
      double endLatitude = position.latitude;
      double endLongitude = position.longitude;

      double distanceInKilometers = Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude) * 0.001;
      print(distance);
      if(distanceInKilometers <= distance.toDouble() ){
        bestCounter += 1;
      } else continue;

      if(bestCounter > counter){
        counter = bestCounter;
        bestMatch = item.uid;
      }
    }
    return bestMatch;
  }

  Future<void> setUserData({String uid, bool isNewUser, String lid, String name, String gender, int age, int height, bool wantToBePaired,
    bool wantToBePairedRandomly, String avatarUrl, String hairColor, String hairLength, String cigarettes, String alcohol, GeoPoint position,
    int pairedDate, List<dynamic> interests, bool isPositionUpdated, bool isUserProfileUpdated, bool isLoverProfileUpdated, String politics}) async {
    return await usersCollection.doc(uid).set({
      'uid' : this.uid ?? '',
      'isNewUser' : isNewUser ?? false,
      'lid' : lid ?? '',
      'name': name ?? '',
      'gender': gender ?? '',
      'age': age ?? 0,
      'height': height ?? 0,
      'wantToBePaired': wantToBePaired ?? true,
      'wantToBePairedRandomly': wantToBePairedRandomly ?? true,
      'avatarUrl': avatarUrl ?? 'https://image.freepik.com/free-icon/important-person_318-10744.jpg',
      'hairColor': hairColor ?? 'Brown',
      'hairLength': hairLength ?? 'Short',
      'cigarettes': cigarettes ?? 'I prefer not to say',
      'alcohol': alcohol ?? 'I prefer not to say',
      'position': position,
      'interests': interests,
      'pairedDate' : pairedDate,
      'isPositionUpdated' : isPositionUpdated,
      'isUserProfileUpdated' : isUserProfileUpdated,
      'isLoverProfileUpdated' : isLoverProfileUpdated,
      'politics' : politics,
    });
  }

  Future<void> updateUserData({String uid, bool isNewUser, String lid, String name, String gender, int age, int height, bool wantToBePaired,
    bool wantToBePairedRandomly, String avatarUrl, String hairColor, String hairLength, String cigarettes, String alcohol, GeoPoint position,
    int pairedDate, List<dynamic> interests, int lastMessageTime, bool isPositionUpdated, bool isUserProfileUpdated, bool isLoverProfileUpdated, String politics}) async {
    return await usersCollection.doc(uid).update({
      if(uid != null) 'uid' : uid ?? '',
      if(isNewUser != null)'isNewUser' : isNewUser ?? false,
      if(lid != null)'lid' : lid ?? '',
      if(name != null)'name': name ?? '',
      if(gender != null)'gender': gender ?? 'null',
      if(age != null)'age': age ?? 0,
      if(height != null)'height': height ?? 0,
      if(wantToBePaired != null)'wantToBePaired': wantToBePaired ?? true,
      if(wantToBePairedRandomly != null)'wantToBePairedRandomly': wantToBePairedRandomly ?? true,
      if(avatarUrl != null)'avatarUrl': avatarUrl,
      if(hairColor != null)'hairColor': hairColor,
      if(hairLength != null)'hairLength': hairLength,
      if(cigarettes != null)'cigarettes': cigarettes,
      if(alcohol != null)'alcohol': alcohol,
      if(position != null)'position': position,
      if(pairedDate != null)'pairedDate' : pairedDate,
      if(interests != null)'interests' : interests,
      if(lastMessageTime != null)'lastMessageTime' : lastMessageTime,
      if(isPositionUpdated != null)'isPositionUpdated' : isPositionUpdated,
      if(isUserProfileUpdated != null)'isUserProfileUpdated' : isUserProfileUpdated,
      if(isLoverProfileUpdated != null)'isLoverProfileUpdated' : isLoverProfileUpdated,
      if(politics != null)'politics' : politics,
    });
  }

  Future<void> setLoverData({String gender, int ageMin, int ageMax, int heightMin, int heightMax, String hairColor, String hairLength,
    String cigarettes, String alcohol, int distance, List<dynamic> interests, bool haveAvatar, String politics}) async {
    return await loversCollection.doc(uid).set({
      'gender': gender,
      'ageMin': ageMin,
      'ageMax': ageMax,
      'heightMin': heightMin,
      'heightMax' : heightMax,
      'hairColor' : hairColor,
      'hairLength' : hairLength,
      'cigarettes' : cigarettes,
      'alcohol' : alcohol,
      'distance' : distance,
      'interests' : interests,
      'haveAvatar' : haveAvatar,
      'politics' : politics,
    });
  }

  Future<void> updateLoverData({String gender, int ageMin, int ageMax, int heightMin, int heightMax, String hairColor, String hairLength,
    String cigarettes, String alcohol, int distance, List<dynamic> interests, bool haveAvatar, String politics}) async {
    return await loversCollection.doc(uid).update({
      if(gender != null)'gender': gender,
      if(ageMin != null)'ageMin': ageMin,
      if(ageMax != null)'ageMax': ageMax,
      if(heightMin != null)'heightMin': heightMin,
      if(heightMax != null)'heightMax' : heightMax,
      if(hairColor != null)'hairColor' : hairColor,
      if(hairLength != null)'hairLength' : hairLength,
      if(cigarettes != null)'cigarettes' : cigarettes,
      if(alcohol != null)'alcohol' : alcohol,
      if(distance != null)'distance' : distance,
      if(interests != null)'interests' : interests,
      if(haveAvatar != null)'haveAvatar' : haveAvatar,
      if(politics != null)'politics' : politics,
    });
  }

  Future<void> uploadMessage(String uid, String name, String message, String avatarUrl) async {
    String duoId = uid.hashCode <= this.uid.hashCode ? uid + '_' + this.uid : this.uid + '_' + uid;
    final refMessages = FirebaseFirestore.instance.collection('chats/$duoId/messages');

    final newMessage = Message(
      uid: uid,
      avatarUrl: avatarUrl,
      name: name,
      message: message,
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());
  }

  Future<void> deleteMessages(String uid) async {
    String duoId = uid.hashCode <= this.uid.hashCode ? uid + '_' + this.uid : this.uid + '_' + uid;
    final refMessages = FirebaseFirestore.instance.collection('chats');

    await refMessages.doc(duoId).delete();
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      isNewUser: snapshot.get('isNewUser'),
      lid: snapshot.get('lid'),
      name: snapshot.get('name'),
      gender: snapshot.get('gender'),
      age: snapshot.get('age'),
      height: snapshot.get('height'),
      wantToBePaired: snapshot.get('wantToBePaired'),
      wantToBePairedRandomly: snapshot.get('wantToBePairedRandomly'),
      avatarUrl: snapshot.get('avatarUrl'),
      hairLength: snapshot.get('hairLength'),
      hairColor: snapshot.get('hairColor'),
      cigarettes: snapshot.get('cigarettes'),
      alcohol: snapshot.get('alcohol'),
      interests: snapshot.get('interests'),
      position: snapshot.get('position'),
      pairedDate: snapshot.get('pairedDate'),
      isPositionUpdated: snapshot.get('isPositionUpdated'),
      isUserProfileUpdated: snapshot.get('isUserProfileUpdated'),
      isLoverProfileUpdated: snapshot.get('isLoverProfileUpdated'),
      politics: snapshot.get('politics'),
    );
  }

  LoverData _loverDataFromSnapshot(DocumentSnapshot snapshot) {
    return LoverData(
        uid: uid,
        gender: snapshot.get('gender')['gender'],
        ageMin: snapshot.get('ageMin')['ageMin'],
        ageMax: snapshot.get('ageMax')['ageMax'],
        heightMin: snapshot.get('heightMin')['heightMin'],
        heightMax: snapshot.get('heightMax')['heightMax'],
        hairColor: snapshot.get('hairColor')['hairColor'],
        hairLength: snapshot.get('hairLength')['hairLength'],
        cigarettes: snapshot.get('cigarettes')['cigarettes'],
        alcohol: snapshot.get('alcohol')['alcohol'],
        distance: snapshot.get('distance')['distance'],
        interests: snapshot.get('interests')['interests'],
        haveAvatar: snapshot.get('haveAvatar')['haveAvatar'],
        politics: snapshot.get('politics')['politics'],
    );
  }

  // get user doc stream
  Stream<UserData> get userData {
    return usersCollection.doc(uid).snapshots()
      .map(_userDataFromSnapshot);
  }

  Stream<LoverData> get loverData {
    return loversCollection.doc(uid).snapshots()
        .map(_loverDataFromSnapshot);
  }

  static Stream<List<Message>> getMessages(String uid1, String uid2) {
    String duoId = uid1.hashCode <= uid2.hashCode ? uid1 + '_' + uid2 : uid2 + '_' + uid1;
    return FirebaseFirestore.instance
        .collection('chats/$duoId/messages')
        .orderBy(MessageField.createdAt, descending: true)
        .snapshots()
        .transform(Utils.transformer(Message.fromJson));
  }
}