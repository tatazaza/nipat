import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nipat/src/pages/profile_page/edit_insert.dart';
import 'package:nipat/src/pages/profile_page/student_sec_info.dart';
import 'package:nipat/src/scoped_models/user.dart';
import 'package:nipat/src/utils/constant.dart';
import 'package:scoped_model/scoped_model.dart';

class StudentInfoPage extends StatefulWidget {
  final String docID;
  StudentInfoPage({
    Key key,
    this.docID,
  }) : super(key: key);

  _StudentInfoPageState createState() => _StudentInfoPageState();
}

class _StudentInfoPageState extends State<StudentInfoPage> {
  @override
  Widget build(BuildContext context) {
    final _user = ScopedModel.of<User>(context, rebuildOnChange: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.docID),
        centerTitle: true,
        backgroundColor: Constant.BG_COLOR,
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('students')
            .document(widget.docID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: Text("Loading"));
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: Card(
                          child: snapshot.data['image'] != null
                              ? Image.network(
                                  snapshot.data['image'],
                                  width: 300,
                                  height: 300,
                                  loadingBuilder: (
                                    BuildContext context,
                                    Widget child,
                                    ImageChunkEvent loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes
                                            : null,
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Text('No Image'),
                                ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  "ชื่อ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.group),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${snapshot.data['firstName'] ?? '-'} ${snapshot.data['lastName'] ?? '-'}',
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                    bottom: 5,
                                  ),
                                  child: Divider(
                                    height: 2,
                                  ),
                                ),
                                const Text(
                                  "หรัสนิสิต",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.group),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: Text(
                                        snapshot.data['identificationNumber'] ??
                                            '-',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                    bottom: 5,
                                  ),
                                  child: Divider(
                                    height: 2,
                                  ),
                                ),
                                const Text(
                                  "สาขา",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                    bottom: 5,
                                  ),
                                  child: Divider(
                                    height: 2,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.group),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      snapshot.data['faculty'] ?? '-',
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                    bottom: 5,
                                  ),
                                  child: Divider(
                                    height: 2,
                                  ),
                                ),
                                const Text(
                                  "คณะ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                    bottom: 5,
                                  ),
                                  child: Divider(
                                    height: 2,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.group),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      snapshot.data['department'] ?? '-',
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                    bottom: 5,
                                  ),
                                  child: Divider(
                                    height: 2,
                                  ),
                                ),
                                const Text(
                                  "หมู่เรียน",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                    bottom: 5,
                                  ),
                                  child: Divider(
                                    height: 2,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.group),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      snapshot.data['sec'] ?? '-',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Card(
                          child: snapshot.data['qr_image_url'] != null
                              ? Image.network(
                                  snapshot.data['qr_image_url'],
                                  width: 300,
                                  height: 300,
                                  loadingBuilder: (
                                    BuildContext context,
                                    Widget child,
                                    ImageChunkEvent loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes
                                            : null,
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Text('No Image'),
                                ),
                        ),
                      ),
                      _user.role != UserType.STUDENT
                          ? Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width - 15,
                              child: RaisedButton(
                                color: Constant.BG_COLOR,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  'Checkins',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StudentSecInfoPage(
                                      numbersec: snapshot.data['sec'],
                                      docID: widget.docID,
                                      studerntID:
                                          snapshot.data['identificationNumber'],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 15,
                        child: RaisedButton(
                          color: Constant.BG_COLOR,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'แก้ไขช้อมูล',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditInsertPage(
                                docID: widget.docID,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
