import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> data = {};

  Future<void> getData() async {
    var response = await http.get(
      Uri.parse("http://192.168.0.148:4000/data"), // Replace with your Flask server URL
    );

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Plant Disease Information"),
        ),
        body: Container(
          child: Center(
            child: data.isEmpty
                ? const CircularProgressIndicator()
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      String diseaseName = data.keys.toList()[index];
                      Map<String, dynamic> treatmentInfo = data[diseaseName];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              diseaseName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text("Type: ${treatmentInfo['Type']}"),
                          ),
                          ListTile(
                            title: Text(
                                "Treatment 1: ${treatmentInfo['Treatment1']}"),
                          ),
                          ListTile(
                            title: Text(
                                "Treatment 2: ${treatmentInfo['Treatment2']}"),
                          ),
                          ListTile(
                            title: Text(
                                "Treatment 3: ${treatmentInfo['Treatment3']}"),
                          ),
                          SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
