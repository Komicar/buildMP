import 'package:flutter/material.dart';
import 'scan_screen.dart';
import 'database_helper.dart';

void main() {
  runApp(MyApp());
  _initializeDatabase();
}

void _initializeDatabase() async {
  final dbHelper = DatabaseHelper();
  await dbHelper.insertClassroom('1', '107 аудитория, компьютерный класс, с 11:30 до 13:00 семинар у 77 группы');
  // Добавьте больше данных по мере необходимости
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classroom Info App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classroom Info App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScanScreen()),
            );
          },
          child: Text('Start Scanning'),
        ),
      ),
    );
  }
}
