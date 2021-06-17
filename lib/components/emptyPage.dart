import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  final String showEmpty;

  EmptyPage({Key key, this.showEmpty});

  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.white,
      padding: EdgeInsets.only(top: 60.0),
      child: Column(
        children: <Widget>[
          Image.asset(
            "images/empty.png",
            width: 50,
            height: 50,
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(this.showEmpty == null ? "没有数据" : this.showEmpty),
          )
        ],
      ),
    );
  }
}
