import 'package:firebase_database/firebase_database.dart';

class User {
  String key;
  String name;
  String id;
  String pw;
  String email;
  String createTime;

  User(this.name, this.id, this.pw, this.email, this.createTime);

  User.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value['name'],
        id = snapshot.value['id'],
        pw = snapshot.value['pw'],
        email = snapshot.value['email'],
        createTime = snapshot.value['createTime'];

  toJson() {
    return {
      'name': name,
      'id': id,
      'pw': pw,
      'email': email,
      'createTime': createTime,
    };
  }
}
