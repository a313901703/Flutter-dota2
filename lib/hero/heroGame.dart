import "package:flutter/material.dart";
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../components/emptyPage.dart';
import '../entity/usedHero.dart';

class HeroGame extends StatelessWidget {
  List games;
  HeroGame({Key key, this.games});

  Widget build(BuildContext context) {
    if (this.games.length <= 0) {
      return EmptyPage(
        showEmpty: "暂无比赛数据",
      );
    }
    List<Widget> _items = [];
    _items.add(_header());
    _items.add(Divider(
      height: 0,
    ));
    games.forEach((v) {
      // UsedHero match = UsedHero.fromJson(v);
      _items.add(
        HeroGameItem(
          item: v,
        ),
      );
      _items.add(Divider(
        height: 0,
      ));
    });

    return Container(
      color: Colors.white,
      child: Column(
        children: _items,
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          _headerItem("英雄", 35),
          _headerItem("胜率"),
          _headerItem("场次", 50),
          _headerItem("最后使用", 80),
        ],
      ),
    );
  }

  Widget _headerItem(String label, [double width]) {
    if (width == null || width < 0) {
      return Expanded(
          child: Container(
        alignment: label == "英雄" ? Alignment.centerLeft : Alignment.center,
        child: Text(
          label,
          style: TextStyle(color: Colors.grey),
        ),
      ));
    }
    return Container(
      alignment: Alignment.center,
      width: width,
      child: Text(
        label,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}

class HeroGameItem extends StatelessWidget {
  final item;
  HeroGameItem({Key key, this.item});

  Widget build(BuildContext context) {
    UsedHero match = UsedHero.fromJson(item);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/matchInfo");
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                width: 35,
                margin: const EdgeInsets.only(right: 10.0),
                child: CachedNetworkImage(
                  imageUrl: match.hero.thumb,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundImage: imageProvider,
                    radius: 17.5,
                  ),
                )),
            //margin: const EdgeInsets.only(right: 10.0),
            // child: CircleAvatar(
            //   radius: 17.5,
            //   backgroundImage: NetworkImage(match.hero.thumb),
            //   backgroundColor: Colors.white,
            // )),
            Expanded(
                child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 10),
                  width: double.infinity,
                  child: Text(
                    (100 * match.win / match.games).toStringAsFixed(2),
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                Container(
                    child: LinearPercentIndicator(
                  lineHeight: 7,
                  backgroundColor: Colors.black12,
                  progressColor: Color(0XFF000033),
                  percent: match.win / match.games,
                )),
              ],
            )),
            Container(
                alignment: Alignment.center,
                width: 50,
                child: Text(match.games.toString())),
            Container(
                alignment: Alignment.center,
                width: 80,
                child: Text(match.getStartTimeString(match.lastPlayed))),
          ],
        ),
      ),
    );
  }
}
