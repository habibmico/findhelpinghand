import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

class CreateWorkPage extends StatefulWidget {
  String phone, type;

  CreateWorkPage({super.key, required this.phone, required this.type});

  @override
  State<CreateWorkPage> createState() => _CreateWorkPageState();
}

class _CreateWorkPageState extends State<CreateWorkPage> {
  TextEditingController WorkController = TextEditingController();
  TextEditingController AmountController = TextEditingController();
  Future createWorkOwner(
      String phone, String type, String workName, String workPrice) async {
    http.Response response = await http
        .post(Uri.parse("http://192.168.31.82:8000/createWorkOwner"), body: {
      "phone": phone,
      "workName": workName,
      "workPrice": workPrice,
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
      return jsonDecode(response.body);
    } else {
      throw Exception("Error loading data");
    }
  }

  Future getallworkList(String phone, String type) async {
    http.Response response = await http.post(
        Uri.parse("http://192.168.31.82:8000/getallworkList"),
        body: {"phone": phone, "type": type});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error loading data");
    }
  }

  Future removeWorkFromList(String phone, String workName, String type) async {
    http.Response response = await http.post(
        Uri.parse("http://192.168.31.82:8000/removeWorkFromList"),
        body: {"phone": phone, "type": type, "workName": workName});

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
        title: const Text("My Works"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Work Name',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: WorkController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Work Name',
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Amount ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: AmountController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Amount',
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: ElevatedButton(
                      child: const Text('Submit'),
                      onPressed: () {
                        //updateAddress(AdressController.text, widget.phone);
                        if (WorkController.text != "" &&
                            WorkController.text != "") {
                          setState(() {
                            createWorkOwner(widget.phone, widget.type,
                                WorkController.text, AmountController.text);
                            WorkController.text = "";
                            AmountController.text = "";
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
          Expanded(
            child: FutureBuilder(
              future: getallworkList(widget.phone, widget.type),
              builder: (BuildContext context, AsyncSnapshot sn) {
                if (sn.hasData) {
                  List unis = sn.data;
                  return ListView.builder(
                    itemCount: unis.length,
                    itemBuilder: (context, index) => Card(
                      child: ListTile(
                        title: Text("Work Name: ${unis[index]["workName"]}"),
                        subtitle: Text("Salary: ${unis[index]["price"]}"),
                        trailing: Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: ElevatedButton(
                            child: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                removeWorkFromList(widget.phone,
                                    unis[index]["workName"], widget.type);
                              });
                            },
                          ),
                        ),
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
    );
  }
}
