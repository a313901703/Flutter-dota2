import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../components/subhead.dart';
import '../home/games.dart';
import '../hero/heroGame.dart';
import '../global.dart';
import '../util/dioUtil.dart';

class PlayerInfo extends StatefulWidget {
  PlayerInfoState createState() {
    return new PlayerInfoState();
  }
}

class PlayerInfoState extends State<PlayerInfo> {
  //Map item;
  Map wl;
  Map count;
  List usedHero = [];
  List recentMatch = [];
  List friends = [];

  @override
  void initState() {
    super.initState();
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.fadingCircle;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final Map args = ModalRoute.of(context).settings.arguments;
      final item = args["item"];
      _loadData(item['playerID']);
    });
  }

  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    final item = args["item"];
    return Scaffold(
      body: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: FlutterEasyLoading(
              child: Container(
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                _header(context, item),
                Subhead(label: "概要"),
                _outline(),
                Subhead(
                  label: "近期比赛",
                  operate: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/matches",
                          arguments: {"playerID": item['playerID']});
                    },
                    child: Icon(
                      Icons.chevron_right,
                      semanticLabel: "more",
                    ),
                  ),
                ),
                Games(
                  games: recentMatch.length > 5
                      ? recentMatch.sublist(0, 5)
                      : recentMatch,
                ),
                Subhead(
                  label: "常用英雄",
                  // operate: InkWell(
                  //   onTap: () {},
                  //   child: Icon(
                  //     Icons.chevron_right,
                  //     semanticLabel: "more",
                  //   ),
                  // )
                ),
                HeroGame(
                  games:
                      usedHero.length > 0 ? usedHero.sublist(0, 5) : usedHero,
                ),
                Container(
                  height: 20,
                )
              ],
            ),
          ))),
    );
  }

  Widget _back(BuildContext context) {
    return Positioned(
      top: 0,
      left: 10,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.chevron_left,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  Widget _header(BuildContext context, Map item) {
    return Container(
        padding: EdgeInsets.only(top: 30, bottom: 10),
        color: Global.themeColor,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(item["avatar"]),
                  backgroundColor: Global.themeColor,
                  radius: 25,
                ),
                Container(
                  child: Text(
                    item["personaname"],
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Container(
                  child: Text("steamID: " + item["playerID"].toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      )),
                ),
              ],
            ),
            _back(context)
          ],
        ));
  }

  Widget _outline() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(10.0),
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: <Widget>[
            _outlineItem("总场数",
                this.wl == null ? "0" : (wl['win'] + wl['lose']).toString()),
            _outlineItem("KDA", _getKda()),
            _outlineItem(
                "场均击杀", _getOutLineItemValue("kills").toStringAsFixed(2)),
            _outlineItem(
                "场均死亡", _getOutLineItemValue("deaths").toStringAsFixed(2)),
            _outlineItem(
                "场均助攻", _getOutLineItemValue("assists").toStringAsFixed(2)),
            _outlineItem("场均GPM",
                _getOutLineItemValue("gold_per_min").toStringAsFixed(2)),
            _outlineItem(
                "场均XPM", _getOutLineItemValue("xp_per_min").toStringAsFixed(2)),
            _outlineItem(
                "场均正补", _getOutLineItemValue("last_hits").toStringAsFixed(2)),
            _outlineItem(
                "场均反补", _getOutLineItemValue("denies").toStringAsFixed(2)),
            _outlineItem(
                "场均伤害", _getOutLineItemValue("hero_damage").toStringAsFixed(2)),
            _outlineItem("场均治疗",
                _getOutLineItemValue("hero_healing").toStringAsFixed(2)),
            _outlineItem("场均建筑伤害",
                _getOutLineItemValue("tower_damage").toStringAsFixed(2)),
          ],
        ));
  }

  Widget _outlineItem(String label, String value) {
    var itemWidth = (Global.physicalWidth / Global.dpr - 60) / 4;
    var itemHeight = itemWidth * 0.7;

    return Container(
      width: itemWidth,
      height: itemHeight,
      decoration: BoxDecoration(
          color: Color.fromRGBO(240, 240, 240, 0.2),
          border:
              Border.all(color: Color.fromRGBO(210, 210, 210, 1), width: 0.5)),
      margin: const EdgeInsets.only(top: 5),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(value),
          ),
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 13, color: Color.fromRGBO(100, 100, 100, 0.9)),
          )
        ],
      ),
    );
  }

  _loadData(int playerID) async {
    EasyLoading.show(status: "加载中");
    var dio = new DioUtil();
    try {
      var resp = await dio.get("players/" + playerID.toString());
      var data = resp.data;
      //print(data);
      if (!data.isEmpty) {
        this.setState(() {
          this.wl = data["wl"] ?? {};
          this.usedHero = data["usedHero"] ?? [];
          this.recentMatch = data["recentMatches"] ?? [];
          this.friends = data["peers"] ?? [];
          this.count = data['count'] ?? {};
          //print("down");
        });
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      return e;
    }
  }

  _getOutLineItemValue(String key) {
    if (this.wl == null || this.count == null) {
      return 0;
    }
    int v = count[key] ?? 0;
    int sum = wl['win'] + wl['lose'];
    return sum == 0 ? 0 : v / sum;
  }

  String _getKda() {
    if (this.count == null) {
      return "0";
    }
    int kills = count['kills'];
    int assists = count['assists'];
    int deaths = count['deaths'];
    deaths = deaths > 0 ? deaths : 1;
    return ((kills + assists) / deaths).toStringAsFixed(2);
  }
}

// class PlayerInfoArgs {
//   final Map item;

//   PlayerInfoArgs(this.item);
// }
