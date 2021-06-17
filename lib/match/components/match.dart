import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../entity/matches.dart' as MatchEntity;

class MatchComponent extends StatelessWidget {
  MatchComponent({Key key, this.item});
  final MatchEntity.Matches item;

  Widget build(BuildContext context) {
    //print(item.hero == null ? item.hero : '');
    if (item.hero == null) {
      return Container();
    }
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
                imageUrl: item.hero.getThumb(),
                placeholder: (context, url) => CircularProgressIndicator(),
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundImage: imageProvider,
                  radius: 17.5,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
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
