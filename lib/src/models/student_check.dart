import 'package:cloud_firestore/cloud_firestore.dart';

class SutundentsCheckIn{
  String uid;
  dynamic nitsitchecked;
  Timestamp timestamp;

  SutundentsCheckIn({
    this.timestamp,
    this.uid,
    this.nitsitchecked
  });

  

  SutundentsCheckIn.fromMap(Map snapshot) :
    uid = snapshot['uid'] ?? '',
    nitsitchecked = snapshot['nitsitchecked'] ?? '',
    timestamp = snapshot['timestamp'] ?? '';

  toJson(){
    return {
      'nitsitchecked': nitsitchecked,
      'uid': uid,
      'timestamp': timestamp
    };
  }
}