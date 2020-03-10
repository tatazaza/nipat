import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nipat/src/models/student_check.dart';
import 'package:nipat/src/pages/camera_page/nisitchecked.dart';
import 'package:nipat/src/utils/constant.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:uuid/uuid.dart';

class CameraPage extends StatefulWidget {
  final String numbSec;

  const CameraPage({Key key, this.numbSec}) : super(key: key);
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  String readText = '';
  DocumentReference docRef;
  List<SutundentsCheckIn> sutundentsCheckIn;
  DateTime selectedDate = DateTime.now();
  String postId = Uuid().v4(); 
  TextEditingController _sec = TextEditingController();

  int getNisitCount(nisit) {
    if (nisit == null) {
      return 0;
    }else{
     int count = 0;
      nisit.values.forEach((val) {
        if (val != null) {
          count += 1;
        }
      });
      return count;
    }
  }


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(selectedDate.year - 80, 8),
        lastDate: DateTime(selectedDate.year + 1));
    if (picked != null && picked != selectedDate){
      setState(() {
        selectedDate = picked;
      });
      createNisitCheckIn(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constant.CAMERA),
        centerTitle: true,
        backgroundColor: Constant.BG_COLOR,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: () {
              _selectDate(context);
            })
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('students_time_check')
            .where('sec', isEqualTo: widget.numbSec)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          sutundentsCheckIn = snapshot.data.documents
                .map((doc) => SutundentsCheckIn.fromMap(doc.data)).toList();
          return ListView.builder(
            itemCount: sutundentsCheckIn.length,
            itemBuilder: (BuildContext context, index){           
              var now = sutundentsCheckIn[index].timestamp.toDate();
              return Card(
                child: ListTile(
                  title: Text('สัปดาห์ ${index + 1} วันที่ ${DateFormat("dd-MM-yyyy").format(now)} '),
                  trailing: InkWell(
                    onTap: () => _qrScan(sutundentsCheckIn[index].uid),
                    child: Icon(
                      Icons.camera_front
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => NisitChecked(uid: sutundentsCheckIn[index].uid)));
                  },
                  subtitle: Text(
                    'นิสิตเช็คชื่อทั้งหมด ${getNisitCount(sutundentsCheckIn[index].nitsitchecked)} คน'
                  ),
                ),
              );
            }
          );
        },
      ),
    );
  }

  Future _qrScan(String uid) async {
    Future<String> futureString = QRCodeReader()
        .setAutoFocusIntervalInMs(200)
        .setForceAutoFocus(true)
        .setTorchEnabled(true)
        .setHandlePermissions(true)
        .setExecuteAfterPermissionGranted(true)
        .scan();

    futureString.then(
      (text) => setState(() {
        final body = json.decode(text);
        readText = body['identificationNumber'];
        nisitCheckIn(uid,readText);
      }),
    ).catchError((err) {
      print(err);
    });
  }

  nisitCheckIn(String uid,String nisitId){
    Firestore.instance
      .document(uid).updateData({'nitsitchecked.$nisitId': nisitId});
  }
  
  createNisitCheckIn(timestamp) {
    Firestore.instance
      .collection('students_time_check')
      .document(postId)
      .setData({
        'uid': postId,
        'nitsitchecked': {},
        'sec': widget.numbSec,
        'timestamp': timestamp
      });
  }

  /*Future<bool> sendToCheck(String identification) async {
    print(identification);
    if (identification.isEmpty) return false;
    try {
      Firestore.instance
          .collection('students')
          .where('identificationNumber', isEqualTo: identification)
          .snapshots()
          .listen(
        (data) async {
          await Firestore.instance
              .collection('students_time_check')
              .document()
              .setData(
            {
              'docId': data.documents[0].documentID,
              'studentId': identification,
              'sec': widget.numbSec,
              'cheked': true,
              'date': DateTime.now().toIso8601String(),
            },
          );
        },
      );
    } catch (e) {
      logger.e(e.toString());
      return false;
    }
    return true;
  }*/
}
