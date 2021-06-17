import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/team.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../entity/Hero.dart' as HeroEntity;

import '../components/subhead.dart';

class TeamInfoPage extends StatefulWidget {
  TeamInfoState createState() {
    return new TeamInfoState();
  }
}

class TeamInfoState extends State<TeamInfoPage> {
  Map teamInfo;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final Map args = ModalRoute.of(context).settings.arguments;
      if (args["item"] != null) {
        var id = args["item"]["team_id"];
        var teamInfos =
            Provider.of<TeamModel>(context, listen: false).teamInfos;
        if (teamInfos[id] != null) {
          this.setState(() {
            teamInfo = teamInfos[id];
          });
        } else {
          EasyLoading.show();
        }
        Provider.of<TeamModel>(context, listen: false).loadInfo(id).then((res) {
          //print(res);
          if (res != null) {
            this.setState(() {
              teamInfo = res;
            });
            EasyLoading.dismiss();
          }
        }).catchError((e) {
          EasyLoading.dismiss();
        });
      }
    });
  }

  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    var item = args["item"];

    List<Widget> widgets = [Subhead(label: "概览"), _header(item)];
    if (teamInfo == null) {
      widgets.add(_nodata());
    } else {
      widgets.addAll([
        Subhead(label: "成员"),
        _members(),
        Subhead(label: "常用英雄"),
        _heroes()
      ]);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(item["name"]),
        ),
        body: FlutterEasyLoading(
            child: ListView(
          physics: ClampingScrollPhysics(),
          children: widgets,
        )));
  }

  Widget _header(Map item) {
    return Row(
      children: <Widget>[
        _headerItem("场次", (item['wins'] + item["losses"]).toString()),
        _headerItem(
            "胜率",
            (item["wins"] * 100 / (item['wins'] + item["losses"]))
                    .toStringAsFixed(2) +
                "%"),
        _headerItem("胜场", item['wins'].toString()),
        _headerItem("rating", item['rating'].toString()),
      ],
    );
  }

  Widget _headerItem(String label, String value) {
    return Expanded(
        child: Container(
      // alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey, width: 0.5)),
        color: Colors.white,
      ),
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 5.0),
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    ));
  }

  Widget _nodata() {
    return Container();
  }

  Widget _members() {
    var members = this.teamInfo["players"];
    List<DataRow> rows = [];
    members.forEach((v) {
      if (v["is_current_team_member"] == true) {
        rows.add(DataRow(cells: [
          DataCell(Text(v["name"])),
          DataCell(Text(
              (v["wins"] * 100 / v["games_played"]).toStringAsFixed(2) + "%")),
          DataCell(Text(v["games_played"].toString())),
        ]));
      }
    });

    return Container(
      color: Colors.white,
      child: DataTable(columns: [
        DataColumn(label: Text("成员")),
        DataColumn(label: Text("胜率")),
        DataColumn(label: Text("场次")),
      ], rows: rows),
    );
  }

  Widget _heroes() {
    var heroes = this.teamInfo["heroes"];

    List<DataRow> rows = [];

    heroes.forEach((v) {
      var hero = HeroEntity.Hero.fromJson(v["hero"]);
      rows.add(DataRow(cells: [
        DataCell(Row(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 5.0),
                child: CachedNetworkImage(
                  imageUrl: hero.thumb,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundImage: imageProvider,
                    radius: 17.5,
                  ),
                )),
            Text(hero.cnName),
          ],
        )),
        DataCell(Text(
            (v["wins"] * 100 / v["games_played"]).toStringAsFixed(2) + "%")),
        DataCell(Text(v["games_played"].toString())),
      ]));
    });

    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 20),
      child: DataTable(columns: [
        DataColumn(label: Text("英雄")),
        DataColumn(label: Text("胜率")),
        DataColumn(label: Text("场次")),
      ], rows: rows),
    );
  }
}
