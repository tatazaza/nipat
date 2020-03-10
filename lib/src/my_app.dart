import 'package:flutter/material.dart';
import 'package:nipat/src/root.dart';
import 'package:nipat/src/scoped_models/user.dart';
import 'package:nipat/src/services/auth_service.dart';
import 'package:nipat/src/utils/constant.dart';
import 'package:scoped_model/scoped_model.dart';

class MyApp extends StatelessWidget {
  final User _model = User();
  @override
  Widget build(BuildContext context) {
    return ScopedModel<User>(
      model: _model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Constant.APP_NAME,
        home: Root(
          auth: AuthServices(),
        ),
      ),
    );
  }
}
