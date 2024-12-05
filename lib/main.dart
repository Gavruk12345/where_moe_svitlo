import 'package:flutter/material.dart';
import 'package:where_moe_svitlo/map_page.dart';
import 'package:where_moe_svitlo/schedule_page.dart';
import 'package:where_moe_svitlo/settings_page.dart';

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(widget.isDarkTheme ? Icons.dark_mode : Icons.light_mode),
          onPressed: widget.toggleTheme,
        ),
        title: Text('Where My Light?'),
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
                  color: widget.isDarkTheme
                      ? (buttonText == 'ON' ? Colors.black : Colors.white) // Темна тема: "ON" темний фон, "OFF" білий фон
                      : (buttonText == 'ON' ? Colors.white : Colors.black), // Світла тема: "ON" білий фон, "OFF" темний фон
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isDarkTheme ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5),
                      spreadRadius: 6,
                      blurRadius: 13,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: widget.isDarkTheme
                          ? (buttonText == 'ON' ? Colors.white : Colors.black) // Темна тема: "ON" білий текст, "OFF" чорний текст
                          : (buttonText == 'ON' ? Colors.black : Colors.white), // Світла тема: "ON" чорний текст, "OFF" білий текст
                    ),
                  ),
                ),
              ),
            ),


            const SizedBox(height: 125),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSquareButton('assets/images/map.png', 'Карта відключень', '/map'),
                const SizedBox(width: 25),
                _buildSquareButton('assets/images/schedule.png', 'Графік відключень', '/schedule'),
                const SizedBox(width: 25),
                _buildSquareButton('assets/images/wheel.png', 'Налаштування', '/settings'),
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
            minimumSize: const Size(75, 75),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            elevation: 8,
          ),
          child: Image.asset(
            imagePath,
            width: 40,
            height: 40,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 75,
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}
