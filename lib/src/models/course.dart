import 'package:nipat/src/models/section.dart';

class Course {
  String number;
  String name;
  String description;
  List<Section> sec;

  Course({
    this.number,
    this.name,
    this.description,
    this.sec,
  });
}
