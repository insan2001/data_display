import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class MyHome extends StatefulWidget {
  final Map<String, dynamic> data;
  MyHome({super.key, required this.data});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final ScreenshotController ssControl = ScreenshotController();
  late final List<dynamic> data;

  @override
  void initState() {
    data = widget.data["data"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screenshot(
        controller: ssControl,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: MediaQuery.of(context).size.aspectRatio,
              children: List.generate(
                data.length,
                (index) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      data[index]["title"],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Colors.deepOrange),
                    ),
                    SizedBox(height: 10),
                    Stack(
                      children: [
                        Image.network(data[index]["img"]),
                        data[index]["price"] != ""
                            ? Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 9,
                                  height:
                                      MediaQuery.of(context).size.width / 18,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 233, 17, 17),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    data[index]["price"],
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(
                        data[index]["specs"].length,
                        (xIndex) => Text(
                          data[index]["specs"][xIndex],
                          style: TextStyle(
                              fontSize: 8, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Spacer(flex: 1),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ssControl.capture().then((capturedImage) async {
            List<int>? image = capturedImage;
            Directory? appDocDirectory = await getDownloadsDirectory();
            String fileName = DateTime.now().toString();
            await File("${appDocDirectory!.path}/$fileName")
                .writeAsBytes(image!);
            Share.shareXFiles([XFile("${appDocDirectory.path}/$fileName")]);
          });
        },
        child: Icon(Icons.share),
      ),
    );
  }
}
