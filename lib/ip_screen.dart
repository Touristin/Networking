import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IPScreen extends StatefulWidget {
  @override
  _IPScreenState createState() => _IPScreenState();
}

class _IPScreenState extends State<IPScreen> {
  String ip = '';
  final RegExp ipRegex = RegExp(
    r'^([0-9]{1,3}\.){3}[0-9]{1,3}$',
    caseSensitive: false,
    multiLine: false,
  );

  Future<Map<String, dynamic>> fetchIPData(String ip) async {
    if (ip.isEmpty) {
      return {}; // Вернем пустую карту в случае пустого IP.
    }

    try {
      final response = await http.get(Uri.parse('http://ipwho.is/$ip'));
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        if (decodedData is Map<String, dynamic>) {
          return decodedData;
        } else {
          return {}; // Вернем пустую карту, если данные не являются Map<String, dynamic>.
        }
      } else {
        return {}; // Вернем пустую карту в случае ошибки.
      }
    } catch (e) {
      return {}; // Вернем пустую карту в случае исключения.
    }
  }

  Widget buildInputSection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Material(
        child: TextField(
          onChanged: (value) {
            setState(() {
              ip = value;
            });
          },
          decoration: InputDecoration(
            labelText: "Введите IP",
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget buildFetchButton() {
    return ElevatedButton(
      onPressed: () {
        if (ip.isNotEmpty) {
          setState(() {});
        }
      },
      child: Text('Получить информацию по IP', style: TextStyle(decoration: TextDecoration.none)),
    );
  }

  Widget buildInfoCard(Map<String, dynamic>? data) {
    if (data == null) return Container();

    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildInfoText('IP:', data['ip']),
            buildInfoText('Страна:', data['country']),
            buildInfoText('Город:', data['city']),
          ],
        ),
      ),
    );
  }

  Widget buildInfoText(String label, dynamic value) {
    if (value is String) {
      return Column(
        children: [
          Text(
            '$label $value',
            style: TextStyle(fontSize: 18, decoration: TextDecoration.none),
          ),
          SizedBox(height: 8),
        ],
      );
    } else {
      return Container(); // Вернем пустой контейнер, если значение не является строкой.
    }
  }

  Widget buildErrorText(String error) {
    return Text(
      error,
      style: TextStyle(fontSize: 18, color: Colors.red, decoration: TextDecoration.none),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IP Info'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildInputSection(),
          SizedBox(height: 16),
          buildFetchButton(),
          SizedBox(height: 16),
          FutureBuilder<Map<String, dynamic>>(
            future: fetchIPData(ip),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError || !snapshot.hasData) {
                return Container();
              } else {
                return buildInfoCard(snapshot.data);
              }
            },
          ),
        ],
      ),
    );
  }
}
