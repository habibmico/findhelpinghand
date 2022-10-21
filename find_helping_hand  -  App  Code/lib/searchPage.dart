// Search Page

import 'package:flutter/material.dart';

import 'package:myapp/searchPageResults.dart';

class SearchPage extends StatefulWidget {
  String name;
  String type;
  SearchPage({Key? key, required this.name, required this.type})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

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
                            searchItem: searchController.text,name: widget.name,type: widget.type,
                          )),
                );
              }),
              icon: const Icon(Icons.search))
        ],
      ),
    );
  }
}
