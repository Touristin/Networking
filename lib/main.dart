import 'package:flutter/material.dart';
import 'currency_screen.dart';
import 'weather_screen.dart';
import 'ip_screen.dart';

void main() {
  runApp(MaterialApp(
    home: NetApp(),
  ));
}

class NetApp extends StatelessWidget {
  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    primary: Colors.blue,
    textStyle: TextStyle(fontSize: 18),
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Networking'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CurrencyScreen()),
                );
              },
              child: Text('Currency Info'),
              style: elevatedButtonStyle,
            ),
            SizedBox(height: 20), // Вертикальный отступ между кнопками
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeatherScreen()),
                );
              },
              child: Text('Weather Info'),
              style: elevatedButtonStyle,
            ),
            SizedBox(height: 20), // Вертикальный отступ между кнопками
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IPScreen()),
                );
              },
              child: Text('IP Info'),
              style: elevatedButtonStyle,
            ),
          ],
        ),
      ),
    );
  }
}
