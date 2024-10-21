import 'package:flutter/material.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

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
            _buildSettingsContainer(
              context,
              title: 'Налаштування графіка відключень',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownRow('Виберіть область:', _selectedItem1, (newValue) {
                    setState(() {
                      _selectedItem1 = newValue!;
                    });
                  }),
                  const SizedBox(height: 16),
                  _buildDropdownRow('Виберіть графік:', _selectedItem2, (newValue) {
                    setState(() {
                      _selectedItem2 = newValue!;
                    });
                  }),
                  const SizedBox(height: 20),
                  Center(
                    child: _buildConfirmButton(),
                  ),
                ],
              ),
            ),
            _buildSettingsContainer(
              context,
              title: 'Налаштування сповіщення',
              child: Column(
                children: List.generate(5, (index) {
                  return _buildSwitchRow('Текст рядка ${index + 1}');
                }),
              ),
            ),
            _buildSettingsContainer(
              context,
              title: 'Container 3',
              height: 200,
              child: const SizedBox.shrink(), // Порожній контейнер, замінити при необхідності
            ),
          ],
        ),
      ),
    );
  }

  // Функція для створення контейнера з налаштуваннями
  Widget _buildSettingsContainer(BuildContext context, {required String title, required Widget child, double height = 0}) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      height: height == 0 ? null : height,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // Функція для створення ряду з випадаючим меню
  Widget _buildDropdownRow(String label, String selectedItem, ValueChanged<String?> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
        ),
        Container(
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(
              color: isDarkMode ? Colors.grey[850]! : Colors.white,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedItem,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            dropdownColor: isDarkMode ? Colors.grey[850] : Colors.white,
            items: _dropdownItems.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  // Функція для створення ряду зі світчем
  Widget _buildSwitchRow(String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: isDarkMode ? Colors.white : Colors.black),
        ),
        Switch(
          value: false, // Змінюйте значення за потреби
          onChanged: (value) {
            // Логіка зміни світча
          },
          activeColor: Colors.white,
          activeTrackColor: Colors.grey,
          inactiveThumbColor: Colors.black,
          inactiveTrackColor: Colors.grey[400],
        ),
      ],
    );
  }

  // Функція для створення кнопки підтвердження
  Widget _buildConfirmButton() {
    return ElevatedButton(
      onPressed: () {
        // Логіка дії при натисканні
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        shadowColor: isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.5),
        elevation: 4,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      child: const Text('Підтвердити', style: TextStyle(fontWeight: FontWeight.w300)),
    );
  }
}
