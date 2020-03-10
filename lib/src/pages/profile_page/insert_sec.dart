import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nipat/src/components/widgets.dart';
import 'package:nipat/src/models/section.dart';
import 'package:nipat/src/pages/home_page/home.dart';
import 'package:nipat/src/scoped_models/user.dart';
import 'package:nipat/src/services/logging_service.dart';
import 'package:nipat/src/utils/constant.dart';
import 'package:scoped_model/scoped_model.dart';

class InsertSecPage extends StatefulWidget {
  @override
  _InsertSecPageState createState() => _InsertSecPageState();
}

class _InsertSecPageState extends State<InsertSecPage> {
  Section newSec = Section();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    final _user = ScopedModel.of<User>(context, rebuildOnChange: true);
    final FormState form = _formKey.currentState;
    form.save();
    if (newSec.number.isNotEmpty) {
      try {
        DocumentReference docRef =
            await Firestore.instance.collection('sec').add(
          {
            "number": newSec.number,
            "teachId": _user.userToken,
          },
        );
        logger.d(docRef.documentID);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } catch (e) {
        logger.e(e.toString());
        return;
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constant.INSERT),
        centerTitle: true,
        backgroundColor: Constant.BG_COLOR,
      ),
      body: Form(
        key: _formKey,
        autovalidate: true,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'หมู่เรียน',
                      labelText: 'หมู่เรียน',
                      prefixIcon: const Icon(
                        Icons.person,
                      ),
                    ),
                    onSaved: (val) => newSec.number = val,
                  ),
                  buildSizedBox(13.0),
                  Container(
                    height: 50,
                    width: double.infinity,
                    child: RaisedButton(
                      color: Constant.BG_COLOR,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        "ยืนยัน",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => _submitForm(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
