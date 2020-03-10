import 'package:flutter/material.dart';
import 'package:nipat/src/components/custom_container.dart';
import 'package:nipat/src/components/widgets.dart';
import 'package:nipat/src/pages/camera_page/camera.dart';
import 'package:nipat/src/pages/insert_data_page/insert_info.dart';
import 'package:nipat/src/pages/profile_page/insert_sec.dart';
import 'package:nipat/src/pages/profile_page/profile.dart';
import 'package:nipat/src/scoped_models/user.dart';
import 'package:nipat/src/services/auth_service.dart';
import 'package:nipat/src/services/logging_service.dart';
import 'package:nipat/src/utils/constant.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  HomePage({
    this.userId,
    this.userEmail,
    this.auth,
    this.logoutCallback,
  });

  final String userId;
  final String userEmail;
  final BaseAuth auth;
  final VoidCallback logoutCallback;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Widget dataColumn(UserType role, BuildContext context) {
    switch (role) {
      case UserType.STUDENT:
        return studentViewColumn(context);
      case UserType.TEACHER:
        return teacherViewColumn(context);
      case UserType.ADMIN:
        return Column(
          children: <Widget>[
            studentViewColumn(context),
            teacherViewColumn(context),
          ],
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<User>(
      builder: (BuildContext context, Widget child, User user) {
        return Scaffold(
          backgroundColor: Color(0xFF3c4250),
          body: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 60,
                      bottom: 30,
                    ),
                    child: Text(
                      'Welcome ${widget.userEmail}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  dataColumn(user.role, context),
                ],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => signOut(),
            child: Icon(Icons.exit_to_app),
          ),
        );
      },
    );
  }

  Widget studentViewColumn(BuildContext context) {
    return Column(
      children: <Widget>[
        // add info
        buildSizedBox(13.0),
        CustomContainer(
          text: 'เพิ่มข้อมูลนิสิต',
          color: Constant.PRIMARY_COLOR,
          icon: Icons.verified_user,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InsertDataPage(),
            ),
          ),
        ),
        buildSizedBox(13.0),
        // edit student info
        CustomContainer(
          text: 'ดูข้อมูลนิสิต',
          color: Constant.ORANGE_COLOR,
          icon: Icons.portrait,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(),
            ),
          ),
        ),
      ],
    );
  }

  Widget teacherViewColumn(BuildContext context) {
    return Column(
      children: <Widget>[
        buildSizedBox(13.0),
        CustomContainer(
          text: 'เพิ่มหมู่เรียน',
          color: Constant.R_COLOR,
          icon: Icons.group_add,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InsertSecPage(),
            ),
          ),
        ),
        buildSizedBox(13.0),
        CustomContainer(
          text: 'ดูหมู่เรียน',
          color: Constant.G_COLOR,
          icon: Icons.group,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(),
            ),
          ),
        ),
        buildSizedBox(20.0),
      ],
    );
  }
}
