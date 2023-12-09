import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyScreen extends StatefulWidget {
  @override
  _CurrencyScreenState createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  Future<Map<String, dynamic>> fetchCurrencyData() async {
    final response = await http.get(Uri.parse('https://www.cbr-xml-daily.ru/daily_json.js'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load currency data. Status code: ${response.statusCode}');
    }
  }

  Widget buildCurrencyContainer(String currencyCode, String label, Map<String, dynamic>? data) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: getColorForCurrency(currencyCode),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$label: ${data?['Valute'][currencyCode]?['Value'] ?? 'N/A'}',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          decoration: TextDecoration.none, // Убираем подчеркивание
        ),
      ),
    );
  }

  Color getColorForCurrency(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
        return Colors.purple;
      case 'EUR':
        return Colors.blue;
      case 'KZT':
        return Colors.orange; // Тенге
      case 'GBP':
        return Colors.red; // Фунты стерлингов
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchCurrencyData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildCurrencyContainer('USD', 'Обменный курс USD по ЦБ РФ на сегодня', snapshot.data),
              SizedBox(height: 10),
              buildCurrencyContainer('EUR', 'Обменный курс EUR по ЦБ РФ на сегодня', snapshot.data),
              SizedBox(height: 10),
              buildCurrencyContainer('KZT', 'Обменный курс KZT по ЦБ РФ на сегодня', snapshot.data),
              SizedBox(height: 10),
              buildCurrencyContainer('GBP', 'Обменный курс GBP по ЦБ РФ на сегодня', snapshot.data),
            ],
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}
