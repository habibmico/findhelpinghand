// ignore_for_file: prefer_const_constructors, must_be_immutable, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/createWorkPage.dart';
import 'package:myapp/myappointListPage.dart';
import 'package:myapp/myworkers.dart';
import 'package:myapp/searchPage.dart';
import 'package:myapp/showProfilePage.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/updateProfilePagehomeOwner.dart';
import 'package:myapp/updateProfilePageWorker.dart';

class HomePage extends StatefulWidget {
  String Username;
  String Usertype;
  String UserAddress;
  String UserIamge;
  String UserPhone;
  String UserWorkingHour;
  HomePage({
    Key? key,
    required this.Username,
    required this.Usertype,
    required this.UserAddress,
    required this.UserIamge,
    required this.UserPhone,
    required this.UserWorkingHour,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future getall(String userType, String userPhone) async {
    http.Response response = await http.post(
        Uri.parse("http://192.168.0.104:8000/getall"),
        body: {"userType": userType, "userPhone": userPhone});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error loading data");
    }
  }

  Future getProfileInfo(String nameOf, String typeOf) async {
    http.Response response = await http.post(
        Uri.parse("http://192.168.0.104:8000/getProfileInfo"),
        body: {"name": nameOf, "type": typeOf});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error loading data");
    }
  }

  Future deleteProfile(String nameOf, String Phone, String typeOf) async {
    http.Response response = await http.post(
        Uri.parse("http://192.168.0.104:8000/deleteProfile"),
        body: {"name": nameOf, "phone": Phone, "type": typeOf});

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Account Deleted",
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

  Future applyAppoint(
      String workerPhone, String ownerPhone, String type) async {
    http.Response response = await http
        .post(Uri.parse("http://192.168.0.104:8000/applyAppoint"), body: {
      "workerPhone": workerPhone,
      "ownerPhone": ownerPhone,
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
      // reviewController.text = "";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(Icons.account_circle_outlined)),
        automaticallyImplyLeading: false,
        title: Title(
            color: const Color.fromARGB(255, 89, 0, 255),
            child: Center(
                child: widget.Usertype == "HomeOwner"
                    ? const Text("Worker List ")
                    : const Text("HomeOwner List"))),
        actions: [
          // Navigate to the Search Screen
          IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => SearchPage(
                        name: widget.Username,
                        type: widget.Usertype,
                      ))),
              icon: const Icon(Icons.search))
        ],
      ),
      drawer: Drawer(
          child: ListView(
        children: [
          Column(
            children: [
              DrawerHeader(
                  child: Image.memory(base64.decode(widget.UserIamge))),
              ListTile(
                title: Center(child: Text(widget.Username)),
              ),
              ListTile(
                title: Center(child: Text(" Address : ${widget.UserAddress}")),
              ),
              ListTile(
                title: Center(child: Text(" Phone : ${widget.UserPhone}")),
              ),
              widget.Usertype == "HomeOwner"
                  ? Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: ElevatedButton(
                        child: const Text('Update Profile'),
                        onPressed: () {
                          // _openImagePicker();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateProfilePage(
                                address: widget.UserAddress,
                                phone: widget.UserPhone,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: ElevatedButton(
                        child: const Text('Update Profile'),
                        onPressed: () {
                          // _openImagePicker();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateProfileWorker(
                                address: widget.UserAddress,
                                phone: widget.UserPhone,
                                workingHour: widget.UserWorkingHour,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ElevatedButton(
                  child: const Text('Delete Profile'),
                  onPressed: () {
                    deleteProfile(
                        widget.Username, widget.UserPhone, widget.Usertype);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ElevatedButton(
                  child: const Text('Logout'),
                  onPressed: () {
                    // _openImagePicker();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      )),
      body: Column(
        children: [
          Expanded(
            flex: 0,
            child: Column(
              children: [
                widget.Usertype == 'HomeOwner'
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                            child: const Text('My Works'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateWorkPage(
                                    phone: widget.UserPhone,
                                    type: widget.Usertype,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Container(),
                widget.Usertype == 'HomeOwner'
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                            child: const Text('My Workers'),
                            onPressed: () {
                              //login();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => myWorkersPage(
                                    UserPhone: widget.UserPhone,
                                    type: widget.Usertype,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Container(),
                widget.Usertype == 'HomeOwner'
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                            child: const Text('Applicant List'),
                            onPressed: () {
                              //login();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => myAppointListPage(
                                    UserPhone: widget.UserPhone,
                                    type: widget.Usertype,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Container(),
                widget.Usertype == 'Worker'
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                            child: const Text('Appointment List'),
                            onPressed: () {
                              //login();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => myAppointListPage(
                                    UserPhone: widget.UserPhone,
                                    type: widget.Usertype,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Container(),
                widget.Usertype == 'Worker'
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ElevatedButton(
                            child: const Text('My Home Owners'),
                            onPressed: () {
                              //login();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => myWorkersPage(
                                    UserPhone: widget.UserPhone,
                                    type: widget.Usertype,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getall(widget.Usertype, widget.UserPhone),
              builder: (BuildContext context, AsyncSnapshot sn) {
                if (sn.hasData) {
                  List unis = sn.data;
                  return ListView.builder(
                    itemCount: unis.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => showProfilePage(
                              name: "${unis[index]["name"]}",
                              address: "${unis[index]["address"]}",
                              phone: "${unis[index]["phone"]}",
                              workingHour: "${unis[index]["workingHour"]}",
                              bytes: base64.decode(unis[index]["profilePic"]),
                              ownerPhone: widget.UserPhone,
                              type: widget.Usertype,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          leading: Image.memory(
                              base64.decode(unis[index]["profilePic"])),
                          title: Text("${unis[index]["name"]}"),
                          subtitle: Text("${unis[index]["phone"]}"),
                          trailing: widget.Usertype == "HomeOwner"
                              ? Container(
                                  height: 50,
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: ElevatedButton(
                                    child: Text("Appoint"),
                                    onPressed: () {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('Are you Sure?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  applyAppoint(
                                                      unis[index]["phone"],
                                                      widget.UserPhone,
                                                      widget.Usertype);
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
                                )
                              : Container(
                                  height: 50,
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: ElevatedButton(
                                    child: Text("Apply"),
                                    onPressed: () {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('Are you Sure?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    applyAppoint(
                                                        widget.UserPhone,
                                                        unis[index]["phone"],
                                                        widget.Usertype);
                                                  },
                                                );

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
                        ),
                      ),
                    ),
                  );
                }
                if (sn.hasError) {
                  return Center(child: Text("Error Loading Data"));
                }
                return Center(
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
