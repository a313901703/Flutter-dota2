import 'package:flutter/material.dart';
import '../components/searchBar.dart';

class SearchPlayer extends StatefulWidget {
  SearchPlayerState createState() {
    return new SearchPlayerState();
  }
}

class SearchPlayerState extends State<SearchPlayer> {
  List<Map> data = [];

  Widget build(BuildContext build) {
    return Scaffold(
      appBar: AppBar(
        title: Text("search"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchBarDelegate());
            },
          )
        ],
      ),
      body: _getBodyWidget(),
    );
  }

  Widget _getBodyWidget() {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
              child: DataTable(columns: [
            DataColumn(label: Text("玩家")),
            DataColumn(label: Text("steamID")),
          ], rows: []))
        ],
      ),
    );
  }
}
