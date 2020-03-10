import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nipat/src/components/loading_container.dart';
import 'package:nipat/src/utils/constant.dart';

class StudentSecInfoPage extends StatefulWidget {
  final String numbersec;
  final String docID;
  final String studerntID;
  StudentSecInfoPage({
    Key key,
    this.numbersec,
    this.docID,
    this.studerntID,
  }) : super(key: key);

  @override
  _InsertSecStudentPageState createState() => _InsertSecStudentPageState();
}

class _InsertSecStudentPageState extends State<StudentSecInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkins'),
        centerTitle: true,
        backgroundColor: Constant.BG_COLOR,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('students_time_check')
            .where('sec', isEqualTo: widget.numbersec)
            .where('studentId', isEqualTo: widget.studerntID)
            .where('cheked', isEqualTo: true)
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
                    var parsedDate = DateTime.parse(document['date']);
                    return Card(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              "วัน/เดือน:"
                              "${parsedDate.day.toString()}/${parsedDate.month.toString()}/${parsedDate.year.toString()}",
                            ),
                            Text(
                              "เวลา"
                              "${parsedDate.hour.toString()}:${parsedDate.minute.toString()}",
                            ),
                          ],
                        ),
                      ),
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
