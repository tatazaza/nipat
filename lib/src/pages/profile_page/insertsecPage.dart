import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nipat/src/utils/constant.dart';
import '../../models/sec.dart';
import '../../widgets/widgets.dart';

class InsertsecPage extends StatefulWidget{
  @override
  _InsertsecPageState createState()=>_InsertsecPageState();}
  class _InsertsecPageState extends State<InsertsecPage>{
    Sec newSec = new Sec();
    final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
 
  void _submitForm() async {
    final FormState form = _formKey.currentState;
    form.save();

    print(newSec);
    DocumentReference docRef =
        await Firestore.instance.collection('Sec').add({
      "numbersec": newSec.numbersec,
    
    });

    print(docRef);
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
                      onSaved: (val) => newSec.numbersec = val,
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
                          child: Text(
                            "ยืนยัน",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            _submitForm();
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
