import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nipat/src/components/loading_container.dart';
import 'package:nipat/src/models/student.dart';
import 'package:nipat/src/pages/camera_page/camera.dart';
import 'package:nipat/src/pages/profile_page/insert_sec.dart';
import 'package:nipat/src/pages/profile_page/insert_sec_student.dart';
import 'package:nipat/src/scoped_models/user.dart';
import 'package:nipat/src/services/alogolia_service.dart';
import 'package:nipat/src/utils/constant.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final _user = ScopedModel.of<User>(context, rebuildOnChange: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(Constant.PROFILE),
        centerTitle: true,
        backgroundColor: Constant.BG_COLOR,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InsertSecPage(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: DataSearch(),
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _user.role == UserType.TEACHER
            ? Firestore.instance
                .collection('sec')
                .where('teachId', isEqualTo: _user.token)
                .snapshots()
            : Firestore.instance.collection('sec').snapshots(),
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
                        document['number'],
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CameraPage(numbSec: document['number'])),
                        );
                      },
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

class DataSearch extends SearchDelegate<String> {
  final algoliaService = AlogoliaService.instance;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Student>>(
      future: algoliaService.performStudentSearch(text: query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final students = snapshot.data.map(
            (student) {
              return Container(
                child: Center(
                  child: GestureDetector(
                    child: Card(
                      color: Colors.yellow[200],
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(7.0),
                                child: Text(
                                  student.firstName,
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList();

          return ListView(children: students);
        } else if (snapshot.hasError) {
          return Center(
            child: Text("${snapshot.error.toString()}"),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
