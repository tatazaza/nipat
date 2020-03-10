import 'package:scoped_model/scoped_model.dart';

enum UserType { ADMIN, TEACHER, STUDENT }

class User extends Model {
  String username;
  String email;
  UserType role;
  String token;

  List<String> admins = [
    'mukmind369@gmail.com',
    'krseisenh@gmail.com',
  ];

  List<String> teacher = ['win12034@gmail.com'];

  User({
    this.username,
    this.email,
    this.role,
    this.token,
  });

  UserType get userRole {
    return role;
  }

  String get userToken {
    return token;
  }

  void updateUserRole(String email) {
    if (admins.contains(email)) {
      role = UserType.ADMIN;
    } else if (teacher.contains(email)) {
      role = UserType.TEACHER;
    } else {
      role = UserType.STUDENT;
    }
    notifyListeners();
  }

  void updateUserToken(String utoken) {
    token = utoken;
    notifyListeners();
  }
}
