import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:scraped/screens/home.dart';

class SelectFileScreen extends StatelessWidget {
  const SelectFileScreen({super.key});

  Future<Map<String, dynamic>> readJson(String path) async {
    var who = json.decode(await File(path).readAsString());
    return who;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            await FilePicker.platform.pickFiles().then((result) {
              if (result != null) {
                readJson(result.files.single.path!).then(
                  (data) => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MyHome(
                        data: data,
                      ),
                    ),
                  ),
                );
              }
            });
          },
          child: Text("Choose File"),
        ),
      ),
    );
  }
}
