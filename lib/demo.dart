/*
import 'package:flutter/material.dart';

import 'api_services/surah_api.dart';
import 'models/surah_model.dart';

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  SurahApiService surahApiService = SurahApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: surahApiService.getSurah(),
        builder: (BuildContext context, AsyncSnapshot<List<SurahModel>> snapshot){
          if(snapshot.hasData){
            List<SurahModel>? surah = snapshot.data;
            return ListView.builder(
              itemCount: surah!.length,
                itemBuilder: (context, index){
                  return ListTile(
                    title: InkWell(
                      onTap: (){

                      },
                        child: Text(surah[index].englishName!)
                    ),
                  );
                }
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
*/

/*import 'package:flutter/material.dart';

class MyScaffold extends StatefulWidget {
  const MyScaffold({Key? key}) : super(key: key);

  @override
  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  bool _isContainerVisible = false;

  void _toggleContainerVisibility() {
    setState(() {
      _isContainerVisible = true;
    });
  }

  void _toggleContainerVisibilityNot() {
    setState(() {
      _isContainerVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Scaffold'),
      ),
      body: Center(
        child: Stack(
          children: [
            ElevatedButton(
              onPressed: _toggleContainerVisibility,
              child: Text('Show Container'),
            ),
            if (_isContainerVisible)
              Container(
                width: 200,
                height: 200,
                color: Colors.blue,
                child: Center(
                  child: InkWell(
                    onTap: (){
                      _toggleContainerVisibilityNot();
                    },
                    child: Text(
                      'This is my container!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}*/


import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  late Stopwatch _stopwatch;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_stopwatch.isRunning) {
        setState(() {});
      }
    });
    _stopwatch.start();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Duration duration = _stopwatch.elapsed;
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
      ),
      body: Center(
        child: Text(
          '${hours > 0 ? hours.toString() + ':' : ''}${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 48.0),
        ),
      ),
    );
  }
}
