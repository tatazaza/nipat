class Student {
  String firstName;
  String lastName;
  String identificationNumber;
  String faculty;
  String department;
  String year;
  String imageUrl;
  String sec;
  String email;

  Student({this.identificationNumber, this.firstName, this.sec});

  factory Student.fromJSON(Map<String, dynamic> json) {
    return Student(
      identificationNumber: json['identificationNumber'],
      firstName: json['firstName'],
      sec: json['sec'],
    );
  }
}
