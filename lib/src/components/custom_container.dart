import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final String text;
  final Color color;
  final Function() onPressed;
  final IconData icon;

  const CustomContainer({
    Key key,
    this.text,
    this.color,
    this.onPressed,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 20,
          left: 20,
        ),
        child: FlatButton(
          color: color,
          onPressed: onPressed,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Icon(
                icon,
                size: 70,
                color: Colors.white,
              ),
              SizedBox(width: 30),
              Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
