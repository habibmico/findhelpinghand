// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class showProfilePage extends StatefulWidget {
  String name;
  String address;
  String phone;
  String workingHour;
  Uint8List bytes;
  String ownerPhone;
  String type;
  showProfilePage(
      {Key? key,
      required this.name,
      required this.address,
      required this.phone,
      required this.workingHour,
      required this.bytes,
      required this.ownerPhone,
      required this.type})
      : super(key: key);

  @override
  State<showProfilePage> createState() => _showProfilePageState();
}

class _showProfilePageState extends State<showProfilePage> {
  TextEditingController reviewController = TextEditingController();
  Future sendReview(
      String workerPhone, String ownerPhone, String review, String type) async {
    http.Response response = await http
        .post(Uri.parse("http://192.168.0.104:8000/writeReview"), body: {
      "workerPhone": workerPhone,
      "ownerPhone": ownerPhone,
      "review": review,
      "type": type
    });

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Update Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      reviewController.text = "";
      return jsonDecode(response.body);
    } else {
      Fluttertoast.showToast(
          msg: "Update UnSuccessful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future getReview(String workerPhone, String type) async {
    http.Response response = await http.post(
        Uri.parse("http://192.168.0.104:8000/getReview"),
        body: {"workerPhone": workerPhone, "type": type});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error loading data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
            color: const Color.fromARGB(255, 89, 0, 255),
            child: const Text("Profile")),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 600,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Image.memory(width: 200, height: 200, widget.bytes),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Name: ${widget.name}',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Address: ${widget.address}',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Phone: ${widget.phone}',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                        ),
                        widget.type == "HomeOwner"
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Working Hour: ${widget.workingHour}',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              )
                            : Container(),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: reviewController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Write Review',
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: ElevatedButton(
                            child: const Text('Submit'),
                            onPressed: () {
                              if (reviewController.text != "") {
                                setState(() {
                                  sendReview(widget.phone, widget.ownerPhone,
                                      reviewController.text, widget.type);
                                });
                              } else {
                                Fluttertoast.showToast(
                                    msg: "UnSuccessful",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 300,
              child: FutureBuilder(
                future: getReview(widget.phone, widget.type),
                builder: (BuildContext context, AsyncSnapshot sn) {
                  if (sn.hasData) {
                    List unis = sn.data;
                    return ListView.builder(
                      itemCount: unis.length,
                      itemBuilder: (context, index) => Card(
                        child: ListTile(
                          title: Text("${unis[index]["R"]}"),
                        ),
                      ),
                    );
                  }
                  if (sn.hasError) {
                    return const Center(child: Text("No Data"));
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
