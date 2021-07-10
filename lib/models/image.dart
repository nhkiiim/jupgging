import 'package:firebase_database/firebase_database.dart';

class ImageURL {
  String key;
  String mapUrl;
  String trashUrl;
  String distance;
  String time;
  String comment;
  String createTime;

  ImageURL(this.mapUrl, this.trashUrl, this.distance, this.time, this.comment, this.createTime);

  ImageURL.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        mapUrl = snapshot.value['mapUrl'],
        trashUrl = snapshot.value['trashUrl'],
        distance = snapshot.value['distance'],
        time = snapshot.value['time'],
        comment = snapshot.value['comment'],
        createTime = snapshot.value['createTime'];

  toJson() {
    return {
      'mapUrl': mapUrl,
      'trashUrl': trashUrl,
      'distance': distance,
      'time': time,
      'comment' : comment,
      'createTime': createTime,
    };
  }
}
