// import 'dart:convert';
//
// import 'package:http/http.dart';
//
// import '../models/surah_model.dart';
// import 'package:http/http.dart' as http;
//
// import '../models/surah_translation.dart';
//
// class SurahApiService{
//   final endPointUrl = 'http://api.alquran.cloud/v1/surah';
//   List<SurahModel> list = [];
//
//   Future<List<SurahModel>> getSurah() async{
//     Response res = await http.get(Uri.parse(endPointUrl));
//     if(res.statusCode == 200) {
//       Map<String, dynamic> json = jsonDecode(res.body);
//       json['data'].forEach((element){
//         if(list.length<114){
//           list.add(SurahModel.fromJson(element));
//         }
//       });
//       print(list.length);
//       return list;
//     }else{
//       throw ("Can't get the Surah");
//     }
//   }
//
//   Future<SurahTranslationList> getTranslation(int index) async{
//     final url = 'https://quranenc.com/api/v1/translation/sura/english_saheeh/$index';
//     var res = await http.get(Uri.parse(url));
//
//     return SurahTranslationList.fromJson(json.decode(res.body));
//   }
//
//
// }