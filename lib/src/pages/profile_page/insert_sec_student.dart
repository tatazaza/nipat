import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nipat/src/components/loading_container.dart';
import 'package:nipat/src/pages/camera_page/camera.dart';
import 'package:nipat/src/pages/profile_page/student_info.dart';
import 'package:nipat/src/scoped_models/user.dart';
import 'package:nipat/src/utils/constant.dart';
import 'package:scoped_model/scoped_model.dart';

class InsertSecStudentPage extends StatefulWidget {
  final String numbersec;

  final String docID;
  final String studerntID;
  InsertSecStudentPage({
    Key key,
    this.numbersec,
    this.docID,
    this.studerntID,
  }) : super(key: key);

  @override
  _InsertSecStudentPageState createState() => _InsertSecStudentPageState();
}

class _InsertSecStudentPageState extends State<InsertSecStudentPage> {
  @override
  Widget build(BuildContext context) {
    final _user = ScopedModel.of<User>(context, rebuildOnChange: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(Constant.INSERT),
        centerTitle: true,
        backgroundColor: Constant.BG_COLOR,
        actions: <Widget>[
          _user.role != UserType.STUDENT
              ? IconButton(
                  icon: Icon(Icons.camera_front),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CameraPage(numbSec: widget.numbersec),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _user.role != UserType.STUDENT
            ? Firestore.instance
                .collection('students_time_check')
                .where('sec', isEqualTo: widget.numbersec)
                .where('cheked', isEqualTo: true)
                // .where(
                //   "date",
                //   isLessThanOrEqualTo: DateTime.now().toIso8601String(),
                // )
                .snapshots()
            : Firestore.instance
                .collection('students')
                .where('sec', isEqualTo: widget.numbersec)
                .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return LoadingContainer();
            default:
              return ListView(
                children: snapshot.data.documents.map(
                  (DocumentSnapshot document) {
                    return ListTile(
                      title: Text(
                        document['studentId'] ?? document['firstName'],
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentInfoPage(
                              docID: document['docId'] ?? document.documentID,
                            ),
                          ),
                        );
                      },
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black,
                      ),
                      onLongPress: () => _user.role != UserType.STUDENT
                          ? showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('ต้องการลบข้อมูลนิสิต?'),
                                  content: Text('ลบข้อมูลนิสิต'),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('ยกเลิก'),
                                    ),
                                    FlatButton(
                                      onPressed: () async {
                                        await Firestore.instance
                                            .collection('students')
                                            .document(document['docId'])
                                            .delete();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('ยืนยัน'),
                                    )
                                  ],
                                );
                              },
                            )
                          : {},
                    );
                  },
                ).toList(),
              );
          }
        },
      ),
    );
  }
}
