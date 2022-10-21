import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class myAppointListPage extends StatefulWidget {
  String UserPhone, type;
  myAppointListPage({super.key, required this.UserPhone, required this.type});

  @override
  State<myAppointListPage> createState() => _myAppointListPageState();
}

class _myAppointListPageState extends State<myAppointListPage> {
  Future getAppointList(String workerPhone, String type) async {
    http.Response response = await http.post(
        Uri.parse("http://192.168.31.82:8000/getAppointList"),
        body: {"workerPhone": workerPhone, "type": type});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error loading data");
    }
  }

  Future acceptAppoint(
      String workerPhone, String ownerPhone, String type) async {
    http.Response response = await http
        .post(Uri.parse("http://192.168.31.82:8000/acceptAppoint"), body: {
      "workerPhone": workerPhone,
      "ownerPhone": ownerPhone,
      "type": type
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error loading data");
    }
  }

  Future rejectAppoint(
      String workerPhone, String ownerPhone, String type) async {
    http.Response response = await http
        .post(Uri.parse("http://192.168.31.82:8000/rejectAppoint"), body: {
      "workerPhone": workerPhone,
      "ownerPhone": ownerPhone,
      "type": type
    });
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
        title: const Text("My Appointmentes"),
      ),
      body: FutureBuilder(
        future: getAppointList(widget.UserPhone, widget.type),
        builder: (BuildContext context, AsyncSnapshot sn) {
          if (sn.hasData) {
            List unis = sn.data;
            return ListView.builder(
              itemCount: unis.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  leading:
                      Image.memory(base64.decode(unis[index]["profilePic"])),
                  title: Text("${unis[index]["name"]}"),
                  subtitle: Text("${unis[index]["phone"]}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: ElevatedButton(
                          child: const Text("Accept"),
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Are you Sure?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        acceptAppoint(widget.UserPhone,
                                            unis[index]["phone"], widget.type);
                                      });

                                      Navigator.pop(context);
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // Background color
                          ),
                          child: const Text("Reject"),
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Are you Sure?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                      
                                        rejectAppoint(
                                          widget.UserPhone,
                                          unis[index]["phone"],
                                          widget.type
                                        );
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (sn.hasError) {
            return const Center(child: Text("Error Loading Data"));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
