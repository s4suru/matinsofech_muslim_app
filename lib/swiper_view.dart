import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

class SwiperView extends StatefulWidget {
  const SwiperView({Key? key}) : super(key: key);

  @override
  State<SwiperView> createState() => _SwiperViewState();
}

int num = 0;

class _SwiperViewState extends State<SwiperView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 100,),
          Text('$num'),
          SizedBox(height: 100,),
          Center(
            child: Swiper(
              itemHeight: 220,
              itemWidth: 400,
              loop: true,
              duration: 600,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index){
                return Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/secondary_background.png')
                    )
                  ),
                );
              },
              onIndexChanged: (int demo){
                setState(() {
                  num++;
                  print(num);
                });
              },
              itemCount: 100,
              layout: SwiperLayout.STACK,
            ),
          ),
          SizedBox(height: 100,),
          InkWell(
            onTap: (){
              setState(() {
                num = 0;
              });
            },
              child: Text('hjgjh')
          )
        ],
      ),
    );
  }
}
