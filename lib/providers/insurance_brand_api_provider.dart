import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:insugent/constants.dart';
import 'package:insugent/models/insurance_brands_model.dart';

class InsuranceBrandApiProvider {
  static Future<List<InsuranceBrand>> fetchInsuranceBrands(Map _post) async {
    try {
      var response = await http.Client()
          .post(kBaseUrl + "getInsuranceBrands", body: _post);
      if (response.statusCode == 200) {
        String result = response.body;
        if (result.contains("{")) {
          final parsed = json.decode(result).cast<Map<String, dynamic>>();
          return parsed
              .map<InsuranceBrand>((json) => InsuranceBrand.fromJson(json))
              .toList();
        } else {
          print(result);
          return null;
        }
      } else {
        print('insurance_brand: ' + response.body);
        return null;
      }
    } on Exception catch (e) {
      print('insurance_brand: ' + e.toString());
      return null;
    }
  }
}
