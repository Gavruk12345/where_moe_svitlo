import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';



void main() {
  runApp(const MyApp());}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();}

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
  }}

class MyHomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkTheme;

  const MyHomePage({super.key, required this.toggleTheme, required this.isDarkTheme});

  @override
  State<MyHomePage> createState() => _MyHomePageState();}

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
  }}

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
  }}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();}

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
  }}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();}

class _SettingsPageState extends State<SettingsPage> {
  // Змінні для вибору значень з випадаючих меню
  String _selectedItem1 = 'Option 1';
  String _selectedItem2 = 'Option 1';
  
  // Змінна для керування станом світча
  bool isDarkMode = false;

  // Список опцій для випадаючого меню
  final List<String> _dropdownItems = ['Option 1', 'Option 2', 'Option 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.2)
                        : Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок
                  Text(
                    'Налаштування графіка відключень',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16), // Відступ перед рядками
                  
                  // Перший рядок з текстом і ширшим випадаючим меню
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Виберіть область:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Container(
                        width: 150, // Ширина випадаючого меню
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDarkMode ? Colors.white : Color.fromARGB(255, 161, 161, 161), // Чорна рамка в світлому режимі, біла в темному
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedItem1,
                          decoration: InputDecoration(
                            border: InputBorder.none, // Приховати стандартний бордер
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                          ),
                          dropdownColor:
                              isDarkMode ? Colors.grey[850] : Colors.white,
                          items: _dropdownItems.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedItem1 = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), 
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Виберіть графік:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Container(
                        width: 150, 
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDarkMode ? Colors.white : Color.fromARGB(255, 161, 161, 161), 
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedItem2,
                          decoration: InputDecoration(
                            border: InputBorder.none, 
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                          ),
                          dropdownColor:
                              isDarkMode ? Colors.grey[850] : Colors.white,
                          items: _dropdownItems.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedItem2 = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), 
                  /*Кнопка*/
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Дія при натисканні на кнопку
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white, // Менш чорний фон у темному режимі
                        foregroundColor: isDarkMode ? Colors.white : Colors.black, // Колір тексту кнопки
                        shadowColor: isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.5), // Колір тіні
                        elevation: 4, // Збільшена висота тіні
                        shape: const StadiumBorder(), // Овальна форма кнопки
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        'Підтвердити',
                        style: TextStyle(
                          fontWeight: FontWeight.w300, // Тонкий шрифт
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.2)
                        : Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Налаштування сповіщення',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // Відступ між заголовком і текстом
                  Column(
                    children: List.generate(5, (index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Текст рядка ${index + 1}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          Switch(
                            value: false, // Змінюйте значення за необхідності
                            onChanged: (value) {
                              // Логіка для обробки зміни значення світча
                            },
                            activeColor: Colors.white,
                            activeTrackColor: Colors.grey,
                            inactiveThumbColor: Colors.black,
                            inactiveTrackColor: Colors.grey[400],
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.all(16),
              height: 200,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.2)
                        : Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Container 3',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: isDarkMode ? Colors.white : Colors.black,
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
}
