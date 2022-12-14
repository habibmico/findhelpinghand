// ignore_for_file: sort_child_properties_last

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationPageWorker extends StatefulWidget {
  const RegistrationPageWorker({Key? key}) : super(key: key);

  @override
  State<RegistrationPageWorker> createState() => _RegistrationPageWorkerState();
}

class _RegistrationPageWorkerState extends State<RegistrationPageWorker> {
  static const String _title = 'Helping Hand';
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController workingHour = TextEditingController();
  final _picker = ImagePicker();

  File? _image;
  String filepath = "";
  Future<void> _openImagePicker() async {
    try {
      var pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
          filepath = pickedImage.path;
        });
        // uploadImage(pickedImage.path);
      }
    } catch (e) {
      //print(e);
    }
  }

  Future<void> register(filePath) async {
    // your token if needed
    try {
      // your endpoint and request method
      var request = http.MultipartRequest(
          'POST', Uri.parse("http://192.168.0.104:8000/registrationWorker"));

      request.fields.addAll({
        'name': name.text,
        'password': password.text,
        'address': address.text,
        'phone': phone.text,
        'workingHour': workingHour.text,
      });
      request.files.add(await http.MultipartFile.fromPath('image', filePath));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Registration Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        name.text = "";
        address.text = "";
        phone.text = "";
        password.text = "";
        workingHour.text = "";

        Future.delayed(
          const Duration(seconds: 2),
          () {
            Fluttertoast.showToast(
                msg: "Redirecting to Login Page",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          },
        );
        Future.delayed(
          const Duration(seconds: 5),
          () {
            Navigator.pop(context);
          },
        );
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Find Helping Hand',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Please Worker Registration Form',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: address,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('Upload Profile Picture'),
                onPressed: () {
                  _openImagePicker();
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: workingHour,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Working Hour',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                obscureText: true,
                controller: password,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('Register as Worker'),
                onPressed: () {
                  if (filepath != "" &&
                      name.text != "" &&
                      address.text != "" &&
                      workingHour.text != "" &&
                      phone.text != "" &&
                      password.text != "") {
                    register(filepath);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Failed",
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
            Row(
              children: <Widget>[
                const Text('Already have account?'),
                TextButton(
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    //login screen
                    Navigator.pop(context);
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ),
      ),
    );
  }
}
