import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:insugent/constants.dart';
import 'package:insugent/models/clients_model.dart';

class ClientsApiProvider {
  static Future<List<Client>> fetchClients(Map _post) async {
    try {
      var response = await http.Client()
          .post(Uri.parse(kBaseUrl + "getClients"), body: _post);
      if (response.statusCode == 200) {
        String result = response.body;
        if (result.contains("{")) {
          final parsed = json.decode(result).cast<Map<String, dynamic>>();
          return parsed.map<Client>((json) => Client.fromJson(json)).toList();
        } else {
          print(result);
          return null;
        }
      } else {
        print('client: ' + response.body);
        return null;
      }
    } on Exception catch (e) {
      print('client: ' + e.toString());
      return null;
    }
  }

  static Future<int> fetchCount(Map _post) async {
    try {
      var response = await http.Client()
          .post(Uri.parse(kBaseUrl + "getClientsCount"), body: _post);
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

  static Future<bool> updateClient(Map _post) async {
    try {
      var response = await http.Client()
          .post(Uri.parse(kBaseUrl + "updateClient"), body: _post);
      if (response.statusCode == 200) {
        String result = response.body;
        if (result.contains("SUCCESS")) {
          return true;
        } else {
          print(result);
          return false;
        }
      } else {
        print('client: ' + response.body);
        return false;
      }
    } on Exception catch (e) {
      print('client: ' + e.toString());
      return false;
    }
  }

  static Future<bool> deleteClient(Map _post) async {
    try {
      var response = await http.Client()
          .post(Uri.parse(kBaseUrl + "deleteClient"), body: _post);
      if (response.statusCode == 200) {
        String result = response.body;
        if (result.contains("SUCCESS")) {
          return true;
        } else {
          print(result);
          return false;
        }
      } else {
        print('client: ' + response.body);
        return false;
      }
    } on Exception catch (e) {
      print('client: ' + e.toString());
      return false;
    }
  }

  static Future<bool> activateClient(Map _post) async {
    try {
      var response = await http.Client()
          .post(Uri.parse(kBaseUrl + "activateClient"), body: _post);
      if (response.statusCode == 200) {
        String result = response.body;
        if (result.contains("SUCCESS")) {
          return true;
        } else {
          print(result);
          return false;
        }
      } else {
        print('client: ' + response.body);
        return false;
      }
    } on Exception catch (e) {
      print('client: ' + e.toString());
      return false;
    }
  }
}
