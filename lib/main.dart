import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkTheme = false;

  void toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(toggleTheme: toggleTheme, isDarkTheme: isDarkTheme),
        '/map': (context) => const MapPage(),
        '/schedule': (context) => const SchedulePage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkTheme;

  const MyHomePage({super.key, required this.toggleTheme, required this.isDarkTheme});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String buttonText = 'ON';

  void _toggleButtonText() {
    setState(() {
      buttonText = buttonText == 'ON' ? 'OFF' : 'ON';
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isOn = buttonText == 'ON';
    final Color buttonColor = isOn ? Colors.white : Color.fromARGB(255, 0, 0, 0);
    final Color textColor = isOn ? Colors.black : Colors.white;
    final Color shadowColor = widget.isDarkTheme ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(widget.isDarkTheme ? Icons.dark_mode : Icons.light_mode),
          onPressed: widget.toggleTheme,
        ),
        title: Text(
          'Where My Light?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
        ),
        centerTitle: true,
        actions: [
          Icon(Icons.wifi),
          SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _toggleButtonText,
              child: Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                  color: buttonColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      spreadRadius: 6,
                      blurRadius: 13,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 125),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSquareButton('assets/images/map.png', "Карта відключень", '/map'),
                SizedBox(width: 25),
                _buildSquareButton('assets/images/schedule.png', "Графік відключень", '/schedule'),
                SizedBox(width: 25),
                _buildSquareButton('assets/images/wheel.png', "Налаштування", '/settings'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareButton(String imagePath, String text, String route) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, route);
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(75, 75),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 8,
          ),
          child: Image.asset(
            imagePath,
            width: 40,
            height: 40,
            color: widget.isDarkTheme ? Colors.white : null,
          ),
        ),
        SizedBox(height: 8),
        Container(
        width: 75, // Визначте ширину контейнера
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 10),
         ),
        ),
      ],
    );
  }
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Карта відключень'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(48.3794, 31.1656),
          zoom: 6.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          PolygonLayer(
            polygons: [
              Polygon(
                points: [
                  LatLng(49.5000, 23.5000),
                  LatLng(49.5000, 24.0000),
                  LatLng(49.0000, 24.0000),
                  LatLng(49.0000, 23.5000),
                ],
                color: Colors.blue.withOpacity(0.5),
                borderStrokeWidth: 2.0,
                borderColor: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  // Поточний вибраний день тижня
  int selectedDayIndex = 0;

  // Дні тижня
  final List<String> daysOfWeek = [
    'Понеділок',
    'Вівторок',
    'Середа',
    'Четвер',
    'П\'ятниця',
    'Субота',
    'Неділя',
  ];

  // Функція для побудови списку годин
  Widget buildHourlySchedule(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      itemCount: 24, // Кількість контейнерів (24 години)
      itemBuilder: (context, index) {
        // Форматування часу для кожного контейнера
        final startHour = index;
        final endHour = (index + 1) % 24; // Для 23:00-00:00
        final startTime = '${startHour.toString().padLeft(2, '0')}:00'; // Формат 00:00
        final endTime = '${endHour.toString().padLeft(2, '0')}:00';     // Формат 01:00

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Відступи між контейнерами
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white, // Чорний для темної теми
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), 
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$startTime - $endTime', 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black, 
                ),
              ),
              Text(
                'Немає відключень',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black, 
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Графік відключень'),
      ),
      body: Column(
        children: [
          // Горизонтальний список днів тижня
          SizedBox(
            height: 80, // Висота для списку днів
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: daysOfWeek.length,
              onPageChanged: (index) {
                setState(() {
                  selectedDayIndex = index; // Оновлення вибраного дня
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: selectedDayIndex == index
                        ? (isDarkMode ? Colors.blueGrey : const Color.fromARGB(255, 141, 219, 255))
                        : (isDarkMode ? Colors.black : Colors.white), // Виділення вибраного дня
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // зміщення тіні
                      ),
                    ],
                  ),
                  child: Text(
                    daysOfWeek[index], // Назва дня тижня
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: selectedDayIndex == index
                          ? Colors.white
                          : (isDarkMode ? Colors.white : Colors.black), // Колір тексту для активного дня
                    ),
                  ),
                );
              },
            ),
          ),
          // Вертикальний список годин для вибраного дня
          Expanded(
            child: buildHourlySchedule(context), // Побудова списку годин
          ),
        ],
      ),
    );
  }
}



class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Налаштування'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Налаштування графіку відключень',
              style: TextStyle(
                fontWeight: FontWeight.w300, // Тонкий шрифт
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Виберіть ваше розташування',
              style: TextStyle(
                fontWeight: FontWeight.w300, // Тонкий шрифт
                fontSize: 16.0,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), // Подовгуваста кнопка
                    backgroundColor: Colors.white, // Фон кнопки білий
                  ),
                  child: Text(
                    'Вибрати',
                    style: TextStyle(
                      color: Colors.black, // Текст чорний
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}