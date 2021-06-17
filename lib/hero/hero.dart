import 'package:flutter/material.dart';
import '../components/horizontalDataTable.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/hero.dart';
import '../entity/Hero.dart' as heroEntity;
//import 'package:horizontal_data_table/horizontal_data_table.dart';

class HeroPage extends StatefulWidget {
  State createState() {
    return new HeroPageState();
  }
}

class HeroPageState extends State<HeroPage> {
  bool isAscending = true;

  List lists = [];

  @override
  void initState() {
    //user.initData(100);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      this.setState(() {
        lists = Provider.of<HeroModel>(context, listen: false).lists;
      });
      Provider.of<HeroModel>(context, listen: false).loadData().then((res) {
        if (!res.isEmpty) {
          this.setState(() {
            lists = res;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("英雄列表"),
      ),
      body: _getBodyWidget(),
    );
  }

  Widget _getBodyWidget() {
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 200,
        rightHandSideColumnWidth: 400,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: lists.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 1.0,
          thickness: 0.0,
        ),
        leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
        rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
      ),
      height: MediaQuery.of(context).size.height,
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('英雄', 200),
      FlatButton(
        padding: const EdgeInsets.all(0),
        child: _getTitleItemWidget('场次 ' + (isAscending ? '↓' : '↑'), 100),
        onPressed: () {
          isAscending = !isAscending;
          user.sortCount(isAscending);
          setState(() {});
        },
      ),
      _getTitleItemWidget('胜率', 50),
      _getTitleItemWidget('KDA', 50),
      _getTitleItemWidget('场均击杀', 80),
      _getTitleItemWidget('场均死亡', 80),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    TextStyle style;
    if (label == "英雄" || label.contains("场次")) {
      style = TextStyle(fontWeight: FontWeight.bold);
    } else {
      style = TextStyle(color: Colors.grey);
    }
    return Container(
      child: Text(label, style: style),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: label == "英雄" ? Alignment.center : Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    var hero = heroEntity.Hero.fromJson(lists[index]);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/hero/info", arguments: {"item": hero});
      },
      child: Container(
        child: Row(
          children: <Widget>[
            CachedNetworkImage(
                imageUrl: hero.thumb, width: 75, height: 40, fit: BoxFit.fill),
            Text("  " + hero.cnName)
          ],
        ),
        width: 200,
        height: 52,
        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    var hero = heroEntity.Hero.fromJson(lists[index]);
    return Row(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[Text(500.toString())],
          ),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text("50%"),
          width: 50,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(3.5.toString()),
          width: 50,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(7.toString()),
          width: 80,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(4.toString()),
          width: 80,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}

User user = User();

class User {
  List<UserInfo> _userInfo = List<UserInfo>();

  void initData(int size) {
    for (int i = 0; i < size; i++) {
      _userInfo
          .add(UserInfo("敌法师", 'images/dota2.png', 100, 50, 4.5, 2.3, 3.3));
    }
  }

  List<UserInfo> get userInfo => _userInfo;

  set userInfo(List<UserInfo> value) {
    _userInfo = value;
  }

  ///
  /// sort with Status and Name as the 2nd Sort
  void sortCount(bool isAscending) {
    _userInfo.sort((a, b) {
      return (a.count - b.count) * (isAscending ? 1 : -1);
    });
  }
}

class UserInfo {
  String name;
  String img;
  int count;
  double win;
  double kda;
  double kill;
  double deadth;

  UserInfo(this.name, this.img, this.count, this.win, this.kda, this.kill,
      this.deadth);
}
