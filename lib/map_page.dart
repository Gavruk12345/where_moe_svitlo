import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карта відключень'),
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.grey[850], // Темно-сірий фон
      body: Stack(
        children: const [
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/Vinnic.png', //Вінниця
            x: 100.0, // Координата X
            y: 189.0, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/hmelnic.png', //Хмельницька
            x: 66.5, // Координата X
            y: 171.5, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/ivanofrank.png', //Івано франківськ
            x: 20.0, // Координата X
            y: 200.0, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/kievska.png', //київська область
            x: 139.5, // Координата X
            y: 146.0, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/kirovogr.png',
            x: 162.0, // Координата X
            y: 202.0, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/Kyiv.png',
            x: 136.0, // Координата X
            y: 143.3 // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/luganska.png',
            x: 305.0, // Координата X
            y: 188.3, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/mukoivs.png',
            x: 159, // Координата X
            y: 234.5, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/lvivska.png',
            x: 1.0, // Координата X
            y: 170.0, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/ternop.png',
            x: 37.0, // Координата X
            y: 175.5, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/poltavska.png',
            x: 200.7, // Координата X
            y: 167.5, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/volin.png',
            x: 23.0, // Координата X
            y: 122.0, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/zakarpats.png',
            x: -7.0, // Координата X
            y: 209.0, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/zaporiz.png',
            x: 239.5, // Координата X
            y: 240.0, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/sumska.png',
            x: 211.5, // Координата X
            y: 117.6, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/chersons.png',
            x: 194.3, // Координата X
            y: 255.3, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/Chernivec.png',
            x: 50.5, // Координата X
            y: 211.8, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/chernigivs.png',
            x: 165.0, // Координата X
            y: 114.0, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/cherkaska.png',
            x: 149.8, // Координата X
            y: 176.4, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/djitomu.png',
            x: 95.0, // Координата X
            y: 137.0, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/dnipro.png',
            x: 224.5, // Координата X
            y: 207.0, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/donbas.png',
            x: 280.8, // Координата X
            y: 215, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/odesca.png',
            x: 121.0, // Координата X
            y: 254.5, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/rivnencka.png',
            x: 53.7, // Координата X
            y: 126.7, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/charkivska.png',
            x: 254.3, // Координата X
            y: 172.1, // Координата Y
          ),
          PhotoWithCoordinates(
            filePath: 'assets/images/oblst/creame.png',
            x: 216.3, // Координата X
            y: 295.1, // Координата Y
          ),

        ],
      ),
    );
  }
}

class PhotoWithCoordinates extends StatelessWidget {
  final String filePath;
  final double x;
  final double y;

  const PhotoWithCoordinates({
    Key? key,
    required this.filePath,
    required this.x,
    required this.y,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(x, y), // Зміщення по X і Y
      child: Image.asset(
        filePath,
        width: 100, // Можна змінити розмір за потреби
        height: 100,
        fit: BoxFit.cover,
      ),
    );
  }
}
