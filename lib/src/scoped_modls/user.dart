import 'package:scoped_model/scoped_model.dart';


class User extends Model {
  String username;
  String email;
  String role = 'USER';
  String token;

  List<String> admins = [
    'mukmind369@gmail.com',
    'krseisenh@gmail.com',
    'win12034@gmail.com'
  ];

  User({this.username, this.email, this.role, this.token});

  String get userRole {
    return role;
  }

  String get userToken {
    return token;
  }

  void updateUserRole(String email) {
    if (admins.contains(email)) {
      role = 'ADMIN';
    } else {
      role = 'USER';
    }
    notifyListeners();
  }
}
