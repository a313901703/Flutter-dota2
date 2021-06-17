import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../entity/matchInfo.dart';
import '../global.dart';
import '../model/matchInfo.dart';

import '../components/collapse/collapse.dart';

class MatchInfo extends StatefulWidget {
  MatchInfoState createState() {
    return new MatchInfoState();
  }
}

class MatchInfoState extends State<MatchInfo> {
  int collapSelect = 0;

  MatchInfoEntity entity;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final Map args = ModalRoute.of(context).settings.arguments;
      Provider.of<MatchInfoModel>(context, listen: false)
          .getMatchInfo(args['matchID'])
          .then((res) {
        if (res != null) {
          this.setState(() {
            this.entity = MatchInfoEntity.fromJson(res);
          });
        }
      });
    });
  }

  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("比赛 " + (args['matchID']).toString()),
      ),
      body: ListView(
        children: <Widget>[_getBodyWidget()],
      ),
    );
  }

  Widget _getBodyWidget() {
    //final Map args = ModalRoute.of(context).settings.arguments;
    //var matchInfo = (model.matchesInfo)[args['matchID']];
    if (this.entity == null) {
      //model.loadMatchInfo(args['matchID']);
      return Column(
        children: <Widget>[_skeleton(true), _skeleton(false)],
      );
    }
    // this.entity = MatchInfoEntity.fromJson(matchInfo);
    return Container(
      padding: EdgeInsets.only(bottom: 30),
      child: Column(
        children: <Widget>[_header(), _gameInfo(), _gameInfo(1)],
      ),
    );
  }

  Widget _header() {
    return Container(
      color: Global.themeColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _headerItem("持续时长", entity.durationStr(entity.duration)),
          _headerItem("开始时间", entity.getStartTimeString(entity.startTime)),
          _headerItem("比赛类型", entity.gameModeStr(entity.gameMode)),
          //_headerItem("持续时长")
        ],
      ),
    );
  }

  Widget _headerItem(String label, value) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: <Widget>[_headerSubText(label), _headerText(value)],
      ),
    );
  }

  Widget _headerText(text) {
    return Container(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ));
  }

  Widget _headerSubText(text) {
    return Container(
        child: Text(
      text,
      style: TextStyle(color: Colors.grey, fontSize: 12),
    ));
  }

  List<Map> camp = [
    {"name": "天辉", "backimg": "images/Radiant.png"},
    {"name": "夜魇", "backimg": "images/Dire.png"},
  ];

  Widget _skeleton(bool isRadiant) {
    var _camp = isRadiant ? camp[0] : camp[1];
    List<Widget> _widgets = [];
    _widgets.add(Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 10),
      height: 30,
      width: Global.physicalWidth / Global.dpr,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(_camp["backimg"]), fit: BoxFit.fill),
      ),
      child: Text(
        _camp["name"],
        style: TextStyle(color: Colors.white),
      ),
    ));
    for (var i = 0; i < 5; i++) {
      _widgets.add(_skeletonItem());
      _widgets.add(Divider(
        height: 0,
      ));
    }

    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: _widgets,
      ),
    );
  }

  Widget _skeletonItem() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Container(
            width: 70,
            height: 40,
            color: Color.fromRGBO(220, 220, 220, 0.8),
          ),
          Expanded(
              child: Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 10,
                  color: Color.fromRGBO(220, 220, 220, 0.8),
                ),
                Container(
                  height: 10,
                  color: Color.fromRGBO(220, 220, 220, 0.8),
                ),
                Container(
                  height: 10,
                  color: Color.fromRGBO(220, 220, 220, 0.8),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget _gameInfo([int isRadiant = 0]) {
    var gameRet = "失败";
    if ((isRadiant == 0 && entity.radiantWin) ||
        (isRadiant == 1 && !entity.radiantWin)) {
      gameRet = "胜利";
    }
    var _camp = camp[isRadiant];
    //计算总击杀  经验  经济
    var players = isRadiant == 0
        ? entity.players.sublist(0, 5)
        : entity.players.sublist(5, 10);

    var kills = 0, xp = 0, glod = 0, assists = 0, damages = 0;

    List<Widget> widgets = [];

    players.forEach((v) {
      glod += v.totalGold;
      xp += v.totalXp;
      kills += v.kills;
      assists += v.assists;
      damages += v.heroDamage;
    });

    players.forEach((v) {
      widgets.add(_heroItem(v, kills, assists, damages));
      widgets.add(Divider(
        height: 0,
      ));
    });

    widgets.insert(
        0,
        Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10),
              height: 30,
              width: Global.physicalWidth / Global.dpr,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(_camp["backimg"]), fit: BoxFit.fill),
              ),
              child: Text(
                _camp["name"] + '  ' + gameRet,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Positioned(
                top: 8,
                right: 10,
                child: Row(
                  children: <Widget>[
                    Text(
                      "击杀 " + kills.toString(),
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    Text(
                      "  经验 " + (xp * 60 / entity.duration).toStringAsFixed(0),
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    Text(
                      "  金钱 " +
                          (glod * 60 / entity.duration).toStringAsFixed(0),
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ))
          ],
        ));
    //entity.players
    return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          children: widgets,
        ));
  }

  Widget _heroItem(Players item, int kills, int assists, int damages) {
    var smallText = TextStyle(fontSize: 10, color: Colors.grey);
    var normalText = TextStyle(fontSize: 13);
    //print(item.personaname ?? "kong");
    var fullWidth = Global.physicalWidth / Global.dpr;
    var abilityImgWidth = (fullWidth - 48) / 7;
    return Collapse(
        title: Container(
            child: Row(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: item.hero.thumb,
              fit: BoxFit.fill,
              width: 70,
              height: 40,
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(left: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.personaname == "" ? "匿名玩家" : item.personaname,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: item.isRadiant
                            ? Color.fromRGBO(60, 144, 41, 1)
                            : Color.fromRGBO(155, 55, 38, 1)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "参战率：" +
                        (100 * (item.kills + item.assists) / kills)
                            .toStringAsFixed(2) +
                        '%',
                    style: smallText,
                  ),
                  Text(
                    "伤害：" +
                        (100 * item.heroDamage / damages).toStringAsFixed(2) +
                        '%',
                    style: smallText,
                  ),
                ],
              ),
            )),
            Container(
              padding: EdgeInsets.only(right: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("空", style: TextStyle(color: Colors.white)),
                  Text(
                    item.kills.toString() +
                        " / " +
                        item.deaths.toString() +
                        ' / ' +
                        item.assists.toString(),
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  Text(
                    "KDA: " + item.kda.toString(),
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              width: 83,
              //padding: EdgeInsets.only(right: 6),
              child: Wrap(
                spacing: 3,
                runSpacing: 3,
                children: item.items.map((e) {
                  if (e.thumb != null) {
                    return Image.network(e.thumb,
                        width: 25, height: 19, fit: BoxFit.fill);
                  }
                  return Container(
                    width: 25,
                    height: 19,
                    color: Color.fromRGBO(240, 240, 240, 0.8),
                  );
                }).toList(),
              ),
            ),
          ],
        )),
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "英雄伤害: " + item.heroDamage.toString(),
                style: normalText,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      "每分钟经验: " + item.xpPerMin.toString(),
                      style: normalText,
                    )),
                    Container(
                        width: 120,
                        child: Text(
                          "建筑伤害: " + item.towerDamage.toString(),
                          style: normalText,
                        )),
                    Container(
                        width: 70,
                        child: Text(
                          "正补: " + item.lastHits.toString(),
                          style: normalText,
                        )),
                  ],
                )),
            Container(
                margin: EdgeInsets.only(top: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "每分钟金钱: " + item.goldPerMin.toString(),
                        style: normalText,
                      ),
                    ),
                    Container(
                        width: 120,
                        child: Text(
                          "治疗: " + item.heroHealing.toString(),
                          style: normalText,
                        )),
                    Container(
                        width: 70,
                        child: Text(
                          "反补: " + item.denies.toString(),
                          style: normalText,
                        )),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Wrap(
                    spacing: 3,
                    runSpacing: 3,
                    runAlignment: WrapAlignment.start,
                    children: item.abilities.map((e) {
                      if (e != null && e["img"] != null) {
                        //print(e["img"]);
                        return CachedNetworkImage(
                            imageUrl: e["img"],
                            width: abilityImgWidth,
                            height: abilityImgWidth,
                            fit: BoxFit.fill);
                        // return Image.network(e.img,
                        //     width: 30, height: 30, fit: BoxFit.fill);
                      } else if (e != null && e["dname"] != null) {
                        return Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("images/gifttree.png"),
                                  fit: BoxFit.fill)),
                          alignment: Alignment.center,
                          width: abilityImgWidth,
                          height: abilityImgWidth,
                          child: Text(
                            e["dname"],
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        );
                      }
                      return Container();
                    }).toList(),
                  ))
                ],
              ),
            )
          ],
        ),
        value: item.heroID == this.collapSelect,
        showBorder: false,
        onChange: (value) {
          if (item.heroID == this.collapSelect) {
            this.setState(() {
              this.collapSelect = 0;
            });
          } else {
            this.setState(() {
              this.collapSelect = item.heroID;
            });
          }
        });
  }
}
