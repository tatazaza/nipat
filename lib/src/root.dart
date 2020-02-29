import 'package:flutter/material.dart';
import 'package:nipat/src/pages/home_page/home.dart';
import 'package:nipat/src/pages/login_page/login_page.dart';
import 'package:nipat/src/scoped_models/user.dart';
import 'package:nipat/src/services/auth_service.dart';
import 'package:scoped_model/scoped_model.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class Root extends StatefulWidget {
  Root({
    this.auth,
  });

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => _RootState();
}

class _RootState extends State<Root> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  String _userEmail = "";

  @override
  void initState() {
    super.initState();

    widget.auth.getCurrentUser().then((user) {
      user = null;
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() {
    final _user = ScopedModel.of<User>(context, rebuildOnChange: true);

    widget.auth.getCurrentUser().then((user) {
      _user.updateUserRole(user.email);
      _user.updateUserToken(user.uid.toString());
      setState(() {
        _userId = user.uid.toString();
        _userEmail = user.email;
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(authStatus);
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return LoginPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return HomePage(
            userId: _userId,
            userEmail: _userEmail,
            auth: widget.auth,
            logoutCallback: logoutCallback,
          );
        } else {
          return buildWaitingScreen();
        }
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
