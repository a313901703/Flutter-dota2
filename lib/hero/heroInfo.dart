import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../components/subhead.dart';
import '../global.dart';
import '../model/hero.dart';
import '../entity/Hero.dart' as heroEntity;

class HeroInfo extends StatefulWidget {
  State createState() {
    return new HeroInfoState();
  }
}

class HeroInfoState extends State<HeroInfo> {
  double value = 1;
  double scrollWidth = Global.physicalWidth / Global.dpr;

  int abilitySelected = 0;

  heroEntity.Hero entity;
  var heroInfo;

  @override
  void initState() {
    super.initState();
    //EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.fadingCircle;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final Map args = ModalRoute.of(context).settings.arguments;
      if (args["item"] != null) {
        this.setState(() {
          entity = args["item"];
        });
        var id = args["item"].id;
        var heroInfos =
            Provider.of<HeroModel>(context, listen: false).heroInfos;
        if (heroInfos[id] != null) {
          this.setState(() {
            heroInfo = heroInfos[id];
          });
        } else {
          EasyLoading.show();
        }
        Provider.of<HeroModel>(context, listen: false).loadInfo(id).then((res) {
          if (res != null) {
            this.setState(() {
              heroInfo = res;
            });
            EasyLoading.dismiss();
          }
        }).catchError((e) {
          EasyLoading.dismiss();
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map args = ModalRoute.of(context).settings.arguments;
    if (args["item"] != null) {
      this.setState(() {
        entity = args["item"];
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.entity.cnName),
        ),
        body: FlutterEasyLoading(
          child: Container(
              child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              _header(),
              this.heroInfo == null ? _loadingBody() : _body()
            ],
          )),
        ));
  }

  Widget _header() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/timg.jpeg"), fit: BoxFit.fill),
      ),
    );
  }

  Widget _loadingBody() {
    return Container();
  }

  Widget _body() {
    return Container(
      child: Column(
        children: <Widget>[
          new Subhead(label: "属性", icon: Icons.person),
          _attribute(),
          new Subhead(label: "天赋", icon: Icons.person),
          _gift(),
          new Subhead(label: "技能", icon: Icons.person),
          _ability()
        ],
      ),
    );
  }

  Widget _attribute() {
    var primaryAttr = this.entity.primaryAttr;
    num gin,
        minAttack = heroInfo['stat']['baseAttackMin'],
        maxAttack = heroInfo['stat']['baseAttackMax'],
        health = heroInfo['stat']['baseHealth'],
        mana = heroInfo['stat']['baseMana'];
    if (primaryAttr == "str") {
      gin = heroInfo['stat']['strGain'];
      minAttack += heroInfo['stat']['baseStr'] + gin * (value - 1);
      maxAttack += heroInfo['stat']['baseStr'] + gin * (value - 1);
    } else if (primaryAttr == "int") {
      gin = heroInfo['stat']['intGain'];
      minAttack += heroInfo['stat']['baseInt'] + gin * (value - 1);
      maxAttack += heroInfo['stat']['baseInt'] + gin * (value - 1);
    } else {
      gin = heroInfo['stat']['agiGain'];
      minAttack += heroInfo['stat']['baseAgi'] + gin * (value - 1);
      maxAttack += heroInfo['stat']['baseAgi'] + gin * (value - 1);
    }
    //护甲
    //var baseArmor = heroInfo['stat']['baseArmor'];
    var armor = heroInfo['stat']['baseArmor'] +
        ((value - 1) * heroInfo['stat']['agiGain'] +
                heroInfo['stat']['baseAgi']) *
            0.2;
    health += (heroInfo['stat']['baseStr'] +
            heroInfo['stat']['strGain'] * (value - 1)) *
        18;
    mana += (heroInfo['stat']['baseInt'] +
            heroInfo['stat']['intGain'] * (value - 1)) *
        12;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    if (this.value > 1) {
                      this.setState(() {
                        this.value -= 1;
                      });
                    }
                  },
                  child: Icon(
                    Icons.remove_circle_outline,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                    child: CupertinoSlider(
                        value: this.value,
                        min: 1,
                        max: 30,
                        activeColor: Colors.grey,
                        onChanged: (double v) {
                          setState(() {
                            this.value = v;
                          });
                        })),
                Text(' ' + this.value.toInt().toString() + '级 '),
                InkWell(
                  onTap: () {
                    if (this.value < 30) {
                      this.setState(() {
                        this.value += 1;
                      });
                    }
                  },
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _attributeItem(
                    "攻击",
                    minAttack.toStringAsFixed(0) +
                        "-" +
                        maxAttack.toStringAsFixed(0)),
                _attributeItem("护甲", armor.toStringAsFixed(2)),
                _attributeItem(
                    "移动速度", heroInfo['stat']['moveSpeed'].toString()),
                _attributeItem(
                    "攻击速率", heroInfo['stat']['attackRate'].toString()),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _attributeItem("生命", health.toStringAsFixed(0)),
                _attributeItem("魔法", mana.toStringAsFixed(0)),
                _attributeItem("转身速率", heroInfo['stat']['turnRate'].toString()),
                _attributeItem(
                    "攻击距离", heroInfo['stat']['attackRange'].toString()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _attributeItem(String label, String value) {
    var itemWidth = (Global.physicalWidth / Global.dpr - 60) / 4;
    var itemHeight = itemWidth * 0.7;

    return Container(
      width: itemWidth,
      height: itemHeight,
      decoration: BoxDecoration(
          color: Color.fromRGBO(240, 240, 240, 0.5),
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
            style: TextStyle(
                fontSize: 13, color: Color.fromRGBO(100, 100, 100, 0.9)),
          )
        ],
      ),
    );
  }

  Widget _gift() {
    var talents = jsonDecode(this.heroInfo["info"]["talents"]);
    var talents10 = talents["10"].split(","),
        talents15 = talents["15"].split(","),
        talents20 = talents["20"].split(","),
        talents25 = talents["25"].split(",");
    return Container(
      padding: const EdgeInsets.all(10.0),
      color: Colors.white,
      child: Container(
          height: 300,
          //padding: const EdgeInsets.all(10.0),
          //color: Colors.white,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("images/t-tree.png"))),
          child: Stack(
            children: <Widget>[
              _gitfItem(10, false, talents10[0]),
              _gitfItem(10, true, talents10[1]),
              _gitfItem(90, false, talents15[0]),
              _gitfItem(90, true, talents15[1]),
              _gitfItem(180, false, talents20[0]),
              _gitfItem(180, true, talents20[1]),
              _gitfItem(270, false, talents25[0]),
              _gitfItem(270, true, talents25[1])
            ],
          )),
    );
  }

  Widget _gitfItem(double top, bool isRight, String text) {
    if (isRight) {
      return Positioned(
          top: top,
          right: 0,
          width: (scrollWidth - 70) / 2,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ));
    }
    return Positioned(
        top: top,
        left: 0,
        width: (scrollWidth - 70) / 2,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ));
  }

  Widget _ability() {
    var ability = jsonDecode(this.heroInfo["info"]["ability"]);
    List<Widget> ablititWidgets = [], contentWidgets = [];
    for (var i = 0; i < ability.length; i++) {
      ablititWidgets.add(_abilityItem(i, ability[i]));
      contentWidgets.add(_abilityContent(i, ability[i]));
    }
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          Row(
            children: ablititWidgets,
          ),
          Column(children: contentWidgets)
        ],
      ),
    );
  }

  Widget _abilityItem(int index, item) {
    return InkWell(
      onTap: () {
        if (index != this.abilitySelected) {
          this.setState(() {
            this.abilitySelected = index;
          });
        }
      },
      child: Container(
        width: 50,
        height: 50,
        padding: const EdgeInsets.all(5.0),
        margin: const EdgeInsets.only(right: 10.0),
        decoration: BoxDecoration(
          border: Border.all(
              color:
                  index == this.abilitySelected ? Colors.black : Colors.white,
              width: 0.5),
        ),
        child: CachedNetworkImage(imageUrl: "https:" + item["img"]),
      ),
    );
  }

  Widget _abilityContent(int i, Map item) {
    List<Widget> widgets = [], coolDownWidgets = [];
    widgets.add(Text(item['name'],
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)));
    widgets.add(Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(item["desc"]),
    ));
    item["abilitieInfos"].forEach((v) {
      if (v['label'] == "mana" || v['label'] == "cooldown") {
        if (v['value'] != "") {
          coolDownWidgets.add(_abilityRichText(v["label"], v["value"]));
        }
      } else {
        widgets.add(_abilityRichText(v["label"], v["value"]));
      }
    });
    widgets.addAll(coolDownWidgets);
    if (i == this.abilitySelected) {
      return Row(
        children: <Widget>[
          Expanded(
              child: Container(
            constraints: BoxConstraints(minHeight: 400),
            margin: const EdgeInsets.only(top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgets,
            ),
          ))
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _abilityRichText(String label, String value) {
    if (label == "mana") {
      label = "魔法消耗";
    }
    if (label == "cooldown") {
      label = "冷却";
    }
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: label + " : ",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
      TextSpan(text: value, style: TextStyle(color: Colors.grey)),
    ]));
  }
}
