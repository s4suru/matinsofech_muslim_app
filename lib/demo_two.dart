// import 'package:flutter/material.dart';
// import 'package:tasbih/api_services/surah_api.dart';
// import 'models/surah_translation.dart';
//
// class DemoTwo extends StatefulWidget {
//   const DemoTwo({Key? key}) : super(key: key);
//
//   @override
//   State<DemoTwo> createState() => _DemoTwoState();
// }
//
// class _DemoTwoState extends State<DemoTwo> {
//   SurahApiService surahApiService = SurahApiService();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: surahApiService.getTranslation(1),
//         builder: (BuildContext context, AsyncSnapshot<SurahTranslationList> snapshot){
//           if(snapshot.connectionState == ConnectionState.waiting){
//             return const Center(child: CircularProgressIndicator(),);
//           }
//           else if (snapshot.hasData){
//             return ListView.builder(
//               itemCount: snapshot.data!.translationList.length,
//                 itemBuilder: (context, index){
//                   return ListTile(
//                     title: Text(snapshot.data!.translationList[index].translation!),
//                   );
//                 }
//             );
//           }
//           else {
//             return const Center(child: Text('Translation Not Found'),);
//           }
//         },
//       ),
//     );
//   }
// }
