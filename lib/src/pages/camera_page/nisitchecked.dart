import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nipat/src/models/student_check.dart';
import 'package:nipat/src/pages/profile_page/student_info.dart';
import 'package:shimmer/shimmer.dart';

class NisitChecked extends StatefulWidget {
  final String uid;
  NisitChecked({@required this.uid});

  @override
  _NisitCheckedState createState() => _NisitCheckedState();
}

class _NisitCheckedState extends State<NisitChecked> {
  SutundentsCheckIn sutundentsCheckIn;
  List<String> listnisit = [];

  int getNisitCount(nisit) {
    if (nisit == null){
      return 0;
    }
    int count = 0;
    nisit.values.forEach((val) {
      if(val == true){
        count ++;
      }
    });
    return count;
  }

  @override
  void initState(){
    getdata();
    super.initState();
  }

  getdata() async{
    DocumentSnapshot doc = await Firestore.instance.collection('students_time_check').document(widget.uid).get();
    sutundentsCheckIn = SutundentsCheckIn.fromMap(doc.data);
    sutundentsCheckIn.nitsitchecked.values.forEach((val){
      setState(() {
        listnisit.add(val);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายชื่อนิสิต'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height),
        ),
        physics: NeverScrollableScrollPhysics(),
        itemCount: listnisit.length,
        itemBuilder: (context, index){
          return FutureBuilder(
            future: Firestore.instance.collection('students').document(listnisit[index]).get(),
            builder: (contexts, snapshot){
              if(!snapshot.hasData){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, 
                            MaterialPageRoute(builder: (context) => StudentInfoPage(docID: listnisit[index])));
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Container(
                            height: 100.0,
                            width: 100.0,
                            margin: EdgeInsets.only(top: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(62.5),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(snapshot.data['image'])
                              )
                            ),
                          ),
                        ),
                      ),
                    
                    Text(snapshot.data['firstName'] + " " + snapshot.data['lastName']),
                    Text('ปี ' + snapshot.data['year']),
                    Text('หมู่ ' + snapshot.data['sec']),
                    SizedBox(width: 5),    
                  ],
                ),
              );
            }, 
          );
        },
      )
    );
  }
}

/*
GridView.builder(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3),
      itemCount: listnisit.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        return FutureBuilder(
          future: Firestore.instance.collection('students').document(listnisit[index]).get(),
          builder: (contexts, snapshot){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                                    
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.width / 2 - 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: FadeInImage(
                            image: NetworkImage(snapshot.data['image']),
                            fit: BoxFit.cover,
                            placeholder:
                                AssetImage('assets/icon/picture.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(snapshot.data['firstName'],
                      style: Theme.of(context).textTheme.body2),
                  SizedBox(width: 5),
                                
                ],
              ),
            );
          }, 
        );
      },
    )
*/