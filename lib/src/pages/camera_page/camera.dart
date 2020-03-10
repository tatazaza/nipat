import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nipat/src/components/custom_container.dart';
import 'package:nipat/src/services/logging_service.dart';
import 'package:nipat/src/utils/constant.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class CameraPage extends StatefulWidget {
  final String numbSec;

  const CameraPage({Key key, this.numbSec}) : super(key: key);
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  String readText = '';
  DocumentReference docRef;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constant.CAMERA),
        centerTitle: true,
        backgroundColor: Constant.BG_COLOR,
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200.0,
            child: Center(
              child: Text(readText ?? '-'),
            ),
          ),
          CustomContainer(
            text: 'Check',
            color: Constant.BG_COLOR,
            icon: Icons.check,
            onPressed: () async {
              bool done = await sendToCheck(readText);
              if (done) Navigator.pop(context);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _qrScan(),
        tooltip: 'Scan QR',
        child: Icon(Icons.camera_front),
      ),
    );
  }

  Future _qrScan() async {
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
        print(body['identificationNumber']);
        readText = body['identificationNumber'];
      }),
    );
  }

  Future<bool> sendToCheck(String identification) async {
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
  }
}
