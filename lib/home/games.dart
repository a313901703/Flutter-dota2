import 'package:flutter/material.dart';
import '../entity/matches.dart';
import '../components/emptyPage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Games extends StatelessWidget {
  final games;

  Games({Key key, this.games});

  @override
  Widget build(BuildContext context) {
    List<Widget> items = new List();
    var _games;
    var _game;
    if (this.games != null) {
      // if (this.games.length > 10) {
      //   _games = this.games.sublist(0, 10);
      // } else {
      _games = this.games;
      // }
      if (_games.length <= 0) {
        return EmptyPage(
          showEmpty: "暂无比赛数据",
        );
      }
      _games.forEach((v) {
        _game = new Matches.fromJson(v);
        if (_game.gameMode != 19) {
          items.add(_readerItem(context, _game));
          items.add(Divider(
            height: 0,
          ));
        }
      });
    }

    return Container(
        color: Colors.white,
        child: Column(
          children: items,
        ));
  }

  Widget _readerItem(BuildContext context, Matches item) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {
              //英雄详情
              //Navigator.pushNamed(context, "/matchInfo");
            },
            child: Container(
              // width: 35.0,
              // height: 35.0,
              margin: const EdgeInsets.only(right: 10.0),
              child: CachedNetworkImage(
                imageUrl: item.hero.thumb,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundImage: imageProvider,
                  radius: 17.5,
                ),
              ),
              // child: CircleAvatar(
              //   radius: 17.5,
              //   backgroundColor: Colors.white,
              //   backgroundImage: NetworkImage(item.hero.thumb
              //       //fit: BoxFit.fitWidth,
              //       ),
              // ),
            ),
          ),
          Expanded(
              child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/matchInfo",
                  arguments: {"matchID": item.matchID});
            },
            child: Container(
              alignment: Alignment(-1, 0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(item.hero.cnName),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        item.win ? "胜利" : "失败",
                        style: TextStyle(
                            fontSize: 13,
                            color: item.win ? Colors.green : Colors.redAccent),
                      ),
                      Text("    "),
                      Text(
                        item.getStartTimeString(item.startTime),
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/matchInfo",
                  arguments: {"matchID": item.matchID});
            },
            child: Container(
              child: Column(
                children: <Widget>[
                  Text(item.getKda()),
                  Text(
                    "${item.kills.toString()}/${item.deaths.toString()}/${item.assists.toString()}",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
