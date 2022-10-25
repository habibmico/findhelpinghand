import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class UpdateProfileWorker extends StatefulWidget {
  String address;
  String phone;
  String workingHour;
  UpdateProfileWorker(
      {super.key,
      required this.address,
      required this.phone,
      required this.workingHour});

  @override
  State<UpdateProfileWorker> createState() => _UpdateProfileWorkerState();
}

class _UpdateProfileWorkerState extends State<UpdateProfileWorker> {
  TextEditingController AddressController = TextEditingController();
  TextEditingController workingHourController = TextEditingController();
  @override
  void initState() {
    super.initState();
    AddressController.text = widget.address;
    workingHourController.text = widget.workingHour;
  }

  Future updateAddress(String address, String phone) async {
    http.Response response = await http.post(
        Uri.parse("http://192.168.0.104:8000/updateProfileInfoAddress"),
        body: {"address": address, "phone": phone});

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

  Future updateWorkingHour(String workingHour, String phone) async {
    http.Response response = await http.post(
        Uri.parse("http://192.168.0.104:8000/updateProfileInfoWorkingHour"),
        body: {"workingHour": workingHour, "phone": phone});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Update Address ',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: AddressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {
                  updateAddress(AddressController.text, widget.phone);
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Update Working Hour ',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: workingHourController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: ' ',
                ),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {
                  // login();
                  updateWorkingHour(workingHourController.text, widget.phone);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
