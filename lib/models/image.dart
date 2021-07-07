import 'package:firebase_database/firebase_database.dart';

class ImageURL {
  String key;
  String url;
  String createTime;

  ImageURL(this.url, this.createTime);

  ImageURL.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        url = snapshot.value['url'],
        createTime = snapshot.value['createTime'];

  toJson() {
    return {
      'url': url,
      'createTime': createTime,
    };
  }
}
