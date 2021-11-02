import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          padding: const EdgeInsets.only(left: 10),
          decoration: const BoxDecoration(
            color: Color(0xFFdedbed),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.search),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: TextField(
                    onChanged: (text) {
                    },
                    maxLines: 1,
                    decoration: const InputDecoration(
                      label: Text("Search..."),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
