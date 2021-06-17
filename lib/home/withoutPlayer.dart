import 'package:flutter/material.dart';
import '../components/searchBar.dart';

class WithoutPlayer extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      child: new Center(
        child: Container(
          width: 200,
          height: 100,
          child: Column(
            children: <Widget>[
              Container(
                height: 25,
                child: Text("您还没有绑定的游戏信息"),
              ),
              FlatButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchBarDelegate());
                },
                child: Text(
                  "点击绑定",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
