import 'package:flutter/material.dart';
import 'scan_screen.dart';
import 'database_helper.dart';

void main() {
  runApp(MyApp());
  _initializeDatabase();
}

void _initializeDatabase() async {
  final dbHelper = DatabaseHelper();
  await dbHelper.insertClassroom('1', 'Кухня');
  await dbHelper.insertClassroom('2', 'Балкон');
  await dbHelper.insertClassroom('3', 'Комната отдыха');
  await dbHelper.insertClassroom('WC', 'Туалет');
  // Здесь будут добавляться данные по университету
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
