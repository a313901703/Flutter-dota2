import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class Match extends StatelessWidget {
  Match({Key key, this.index, this.item}) : super(key: key);
  final index;
  final item;
  @override
  Widget build(BuildContext context) {
    //print(item);
    return Container(
      padding: const EdgeInsets.all(10.0),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          _itemLeft(),
          Expanded(child: _itemMiddle()),
          //_itemRight()
        ],
      ),
    );
  }

  Widget _itemLeft() {
    return Container(
      width: 120,
      height: 75,
      child: CachedNetworkImage(
        imageUrl: this.item["thumb"],
        fit: BoxFit.fill,
      ),
      // child: Image.network(
      //   "http://cdn.dota2.com/apps/dota2/images/leagues/12139/images/image_8.png",
      //   fit: BoxFit.fill,
      // ),
    );
  }

  Widget _itemMiddle() {
    var start = this.item['startTime'];
    var now = new DateTime.fromMillisecondsSinceEpoch(start * 1000);
    var formatter = new DateFormat("yyyy-MM-dd");
    String formattedStart = formatter.format(now);
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 10),
      child: Column(
        children: <Widget>[
          Container(
            height: 25,
            alignment: Alignment.topLeft,
            child: Text(this.item["leagueName"],
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
          Container(
            height: 25,
            alignment: Alignment.centerLeft,
            child: Text(
                this.item["prizePoll"] +
                    '\$   ' +
                    this.item['integral'].toString() +
                    '积分',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
          ),
          Container(
            height: 25,
            alignment: Alignment.bottomLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(formattedStart,
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                Row(
                  children: <Widget>[
                    //Text("", style: TextStyle(fontSize: 13)),
                    Text(
                        this.item['leagueType'] == 0
                            ? ""
                            : (this.item['leagueType'] == 1
                                ? "major"
                                : "minor"),
                        style:
                            TextStyle(fontSize: 13, color: Colors.redAccent)),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
