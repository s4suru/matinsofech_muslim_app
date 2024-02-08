import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/hadith_model.dart';

class ApiService {
  Future<List<HadithApiModel>> fetchHadithList() async {
    final response = await http.get(Uri.parse('https://alquranbd.com/api/hadith/muslim/1'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return List<HadithApiModel>.from(jsonData.map((data) => HadithApiModel.fromJson(data)));
    } else {
      throw Exception('Failed to fetch hadith');
    }
  }
}
