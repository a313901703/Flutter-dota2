import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
import 'package:provider/provider.dart';
import '../model/player.dart';
import 'package:dio/dio.dart';

class SearchBarDelegate extends SearchDelegate<String> {
  SearchBarDelegate();
  // 搜索条右侧的按钮执行方法，我们在这里方法里放入一个clear图标。 当点击图片时，清空搜索的内容。
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          // 清空搜索内容
          query = "";
        },
      )
    ];
  }

  // 搜索栏左侧的图标和功能，点击时关闭整个搜索页面
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, "");
      },
    );
  }

  void showResults(BuildContext context) {
    // _focusNode?.unfocus();
    // _currentBody = _SearchBody.results;
  }

  // 搜索到内容了
  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text("搜索的结果：$query"),
      ),
    );
  }

  // 输入时的推荐及搜索结果
  @override
  Widget buildSuggestions(BuildContext context) {
    return new SearchContent(query);
    // final suggestionList = query.isEmpty
    //     ? recentList
    //     : searchList.where((input) => input.startsWith(query)).toList();
    // return ListView.builder(
    //   itemCount: suggestionList.length,
    //   itemBuilder: (context, index) {
    //     // 创建一个富文本，匹配的内容特别显示
    //     return ListTile(
    //       title: RichText(
    //           text: TextSpan(
    //         text: suggestionList[index].substring(0, query.length),
    //         style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    //         children: [
    //           TextSpan(
    //               text: suggestionList[index].substring(query.length),
    //               style: TextStyle(color: Colors.grey))
    //         ],
    //       )),
    //       onTap: () {
    //         query = suggestionList[index];
    //         Scaffold.of(context).showSnackBar(SnackBar(content: Text(query)));
    //       },
    //     );
    //   },
    // );
  }

  //statefulwidget search bar
  //_fetch
}

class SearchContent extends StatefulWidget {
  SearchContent(this.query);
  String query;

  _SearchContentState createState() {
    return new _SearchContentState();
  }
}

class _SearchContentState extends State<SearchContent> {
  List suggestionList = [];

  void didUpdateWidget(StatefulWidget old) {
    super.didUpdateWidget(old);
    _loadPlayers(widget.query);
  }

  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              _playerHeader(),
              ListView.builder(
                shrinkWrap: true,
                itemCount: suggestionList.length,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  // if (index == 0) {
                  //   return _playerHeader();
                  // }
                  // 创建一个富文本，匹配的内容特别显示
                  return ListTile(
                    leading: ClipOval(
                      child: Image.network(
                        suggestionList[index]['avatarfull'],
                        width: 30,
                        height: 30,
                        fit: BoxFit.fill,
                      ),
                    ),
                    title: RichText(
                        text: _blodText(suggestionList[index]['personaname'],
                            widget.query, suggestionList[index])),
                    onTap: () {
                      print(suggestionList[index]);
                      if (suggestionList[index] != null) {
                        Provider.of<PlayerModel>(context, listen: false)
                            .loadPlayer(
                                suggestionList[index]["account_id"].toString(),
                                () {
                          Navigator.of(context).pop();
                        });
                      }
                    },
                  );
                },
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _playerHeader() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      color: Color(0xFFEEEEEE),
      //height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "玩家信息",
            style: TextStyle(fontSize: 13),
          ),
          InkWell(
            onTap: () {
              // playerInfo  inputPlayerId
              Navigator.pushNamed(context, "/inputPlayerId");
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "+ 添加记录",
                style: TextStyle(fontSize: 12),
              ),
            ),
          )
        ],
      ),
    );
  }

  TextSpan _blodText(String text, String query, Map item) {
    var length = min(text.length, query.length);
    return TextSpan(
      text: text.substring(0, length),
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      children: [
        TextSpan(
            text: text.substring(length) + "(  ID: ${item['account_id']})",
            style: TextStyle(color: Colors.grey))
      ],
    );
  }

  static BaseOptions options = BaseOptions(
      baseUrl: "http://192.168.23.143:8199/v1/",
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: {
        'Accept': 'application/json, text/plain, */*',
        //'Authorization': '124',
        'Content-Type': 'application/json;charset=UTF-8'
      });

  var dio = Dio(options);

  void _loadPlayers(String query) async {
    if (query == '') {
      return;
    }
    try {
      var resp =
          await dio.get("https://api.opendota.com/api/search?q=" + query);
      this.setState(() {
        this.suggestionList = resp.data.length > 0
            ? (resp.data.length > 20 ? resp.data.sublist(0, 20) : resp.data)
            : [];
      });
    } catch (e) {
      print(e);
    }
  }
}
