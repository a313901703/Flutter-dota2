import 'package:flutter/material.dart';

class My extends StatefulWidget {
  final playerInfo;
  final usedHeroes;

  My({Key key, this.playerInfo, this.usedHeroes});

  MyState createState() {
    return new MyState();
  }
}

class MyState extends State<My> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _header(widget.playerInfo, context),
          _myHero(widget.usedHeroes)
        ],
      ),
    );
  }
}

Widget _header(Map info, BuildContext context) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Row(
          children: <Widget>[
            ClipOval(child: Image.network(info["avatar"])),
            Text("  "),
            Text(
              info["personaname"],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/matches",
              arguments: {"playerID": info["playerID"]});
        },
        child: Text("查看战绩"),
      ),
      Icon(Icons.chevron_right)
    ],
  );
}

Widget _myHero(List heroes) {
  if (heroes.length <= 0) {
    return Container();
  }
  var hero = heroes[0];
  return Container(
    padding: const EdgeInsets.only(top: 10),
    child: Container(
        height: 120,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/timg.jpeg"), fit: BoxFit.fill),
            borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: <Widget>[
            _myHeroTitle(hero["hero"]["cnName"]),
            _myHeroInfo(hero),
            _rank(36)
          ],
        )),
  );
}

//hero title
Widget _myHeroTitle(String name) {
  return Container(
    padding: const EdgeInsets.only(top: 10, left: 10),
    child: Row(children: <Widget>[
      Text(
        name,
        style: TextStyle(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
      ),
    ]),
  );
}

//场次  胜率  kda
Widget _myHeroInfo(Map hero) {
  return Container(
    child: Row(
      children: <Widget>[
        _myHeroInfoItem("场次", hero['games'].toString()),
        _myHeroInfoItem(
            "胜率", (hero['win'] * 100 / hero['games']).toStringAsFixed(2) + "%"),
        //_myHeroInfoItem("KDA", "6.2"),
        _myHeroInfoItem("MMR", "3320"),
      ],
    ),
  );
}

Widget _myHeroInfoItem(String label, String value) {
  //var _value = value.toString() + "%";
  return Container(
    padding: const EdgeInsets.only(top: 8),
    width: 60,
    child: Column(
      children: <Widget>[
        Container(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(value,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold))),
        Text(label, style: TextStyle(color: Colors.white))
      ],
    ),
  );
}

Widget _rank(double rank) {
  var v = rank.toString() + "%";
  return Container(
    alignment: Alignment.bottomLeft,
    padding: const EdgeInsets.only(top: 10, left: 10),
    child: Text("国服排名: " + v, style: TextStyle(color: Colors.white)),
  );
}
