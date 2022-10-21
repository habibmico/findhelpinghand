// Search Page
// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/showProfilePage.dart';

class SearchPageResults extends StatefulWidget {
  String searchItem;
  String name;
  String type;
  SearchPageResults(
      {Key? key,
      required this.searchItem,
      required this.name,
      required this.type})
      : super(key: key);

  @override
  State<SearchPageResults> createState() => _SearchPageResultsState();
}

class _SearchPageResultsState extends State<SearchPageResults> {
  TextEditingController searchController = TextEditingController();
  Future getProfileInfo(String nameOf, String typeOf) async {
    http.Response response = await http.post(
        Uri.parse("http://192.168.31.82:8000/getProfileInfo"),
        body: {"name": nameOf, "type": typeOf});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error loading data");
    }
  }

  Future getall(String searchItem) async {
    http.Response response = await http.post(
        Uri.parse("http://192.168.31.82:8000/get_search_results"),
        body: {"search_item": searchItem});

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
        // The search area here
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.text = "";
                    },
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none),
            ),
          ),
        ),
        actions: [
          // Navigate to the Search Screen
          IconButton(
              onPressed: (() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchPageResults(
                            searchItem: searchController.text,
                            name: widget.name,
                            type: widget.type,
                          )),
                );
              }),
              icon: const Icon(Icons.search))
        ],
      ),
      body: FutureBuilder(
        future: getall(widget.searchItem),
        builder: (BuildContext context, AsyncSnapshot sn) {
          if (sn.hasData) {
            List unis = sn.data;
            return ListView.builder(
              itemCount: unis.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () async {
                  Future<dynamic> my = getProfileInfo(widget.name, widget.type);
                  List message = await my as List;
                  String m = message[0]["phone"];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => showProfilePage(
                        name: "${unis[index]["name"]}",
                        address: "${unis[index]["address"]}",
                        phone: "${unis[index]["phone"]}",
                        workingHour: "${unis[index]["workingHour"]}",
                        bytes: base64.decode(unis[index]["profilePic"]),
                        ownerPhone: m,
                        type: widget.type,
                      ),
                    ),
                  );
                },
                child: Card(
                  child: ListTile(
                    leading:
                        Image.memory(base64.decode(unis[index]["profilePic"])),
                    title: Text("${unis[index]["name"]}"),
                    subtitle: Text("${unis[index]["phone"]}"),
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
