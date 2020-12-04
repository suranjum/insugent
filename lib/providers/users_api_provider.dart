import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:insugent/constants.dart';
import 'package:insugent/models/users_model.dart';

class UsersApiProvider {
  static Future<List<User>> fetchUsers(Map _post) async {
    try {
      var response =
          await http.Client().post(kBaseUrl + "getUsers", body: _post);
      if (response.statusCode == 200) {
        String result = response.body;
        if (result.contains("{")) {
          final parsed = json.decode(result).cast<Map<String, dynamic>>();
          return parsed.map<User>((json) => User.fromJson(json)).toList();
        } else {
          print(result);
          return null;
        }
      } else {
        print('user: ' + response.body);
        return null;
      }
    } on Exception catch (e) {
      print('user: ' + e.toString());
      return null;
    }
  }

  static Future<int> fetchCount(Map _post) async {
    try {
      var response =
          await http.Client().post(kBaseUrl + "getUsersCount", body: _post);
      if (response.statusCode == 200) {
        String result = response.body;
        int parsed = int.parse(result);
        return parsed ?? 0;
      } else {
        print('school: ' + response.body);
        return 0;
      }
    } on Exception catch (e) {
      print('school: ' + e.toString());
      return 0;
    }
  }

  static Future<bool> updateUser(Map _post) async {
    try {
      var response =
          await http.Client().post(kBaseUrl + "updateUser", body: _post);
      if (response.statusCode == 200) {
        String result = response.body;
        if (result.contains("SUCCESS")) {
          return true;
        } else {
          print(result);
          return false;
        }
      } else {
        print('user: ' + response.body);
        return false;
      }
    } on Exception catch (e) {
      print('user: ' + e.toString());
      return false;
    }
  }

  static Future<bool> deleteUser(Map _post) async {
    try {
      var response =
          await http.Client().post(kBaseUrl + "deleteUser", body: _post);
      if (response.statusCode == 200) {
        String result = response.body;
        if (result.contains("SUCCESS")) {
          return true;
        } else {
          print(result);
          return false;
        }
      } else {
        print('user: ' + response.body);
        return false;
      }
    } on Exception catch (e) {
      print('user: ' + e.toString());
      return false;
    }
  }
}
