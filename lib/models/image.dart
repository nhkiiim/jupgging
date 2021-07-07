import 'package:firebase_database/firebase_database.dart';

class Image {
  String key;
  String url;
  String createTime;

  Image(this.url, this.createTime);

  Image.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        url = snapshot.value['url'],
        createTime = snapshot.value['createTime'];

  toJson() {
    return {
      'name': url,
      'createTime': createTime,
    };
  }
}
