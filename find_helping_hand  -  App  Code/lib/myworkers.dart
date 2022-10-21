// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class myWorkersPage extends StatefulWidget {
  String UserPhone, type;
  myWorkersPage({super.key, required this.UserPhone, required this.type});

  @override
  State<myWorkersPage> createState() => _myWorkersPageState();
}

class _myWorkersPageState extends State<myWorkersPage> {
  TextEditingController salaryController = TextEditingController();
  Future getAppointedWorkers(String userPhone, String type) async {
    http.Response response = await http.post(
        Uri.parse("http://192.168.31.82:8000/getAppointedWorkers"),
        body: {"userPhone": userPhone, "type": type});
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
        title: widget.type == "HomeOwner"
            ? Text("My Workers")
            : Text("My HomeOwners"),
      ),
      body: FutureBuilder(
        future: getAppointedWorkers(widget.UserPhone, widget.type),
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
                          child: const Text("Payment"),
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Payment'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: salaryController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Amount',
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      child: ElevatedButton(
                                        child: const Text('Pay HandCash'),
                                        onPressed: () {
                                          //login();
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Send'),
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
                          child: Icon(Icons.delete),
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
                                        rejectAppoint(unis[index]["phone"],
                                            widget.UserPhone, widget.type);
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
