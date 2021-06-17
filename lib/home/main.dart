import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//components
import '../components/subhead.dart';
import './my.dart';
import './friends.dart';
import './games.dart';
import './withoutPlayer.dart';
//model
import '../model/player.dart';
//全局变量
import '../global.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new HomeBody();
  }
}

class HomeBody extends StatelessWidget {
  var _playerModel;
  // void initState() {
  //   var playerModel = Provider.of<PlayerModel>(context);
  //   var playerID = playerModel.playerID;
  // }

  @override
  Widget build(BuildContext context) {
    _playerModel = Provider.of<PlayerModel>(context);
    var playerID = _playerModel.playerID;
    if (playerID == 0) {
      return WithoutPlayer();
    }
    //playerModel.loadPlayer(playerID.toString());
    return Container(
        decoration: BoxDecoration(color: Global.bgColor),
        child: RefreshIndicator(
            child: ListView(
              //physics: const ClampingScrollPhysics(),
              children: [
                new Subhead(label: "我的账号", icon: Icons.person),
                new My(
                  playerInfo: _playerModel.playerInfo,
                  usedHeroes: _playerModel.usedHeroes,
                ),
                new Subhead(label: "好友", icon: Icons.people),
                new Friends(
                  friends: _playerModel.friends,
                ),
                new Subhead(label: "战绩", icon: Icons.view_list),
                new Games(
                  games: _playerModel.recentMatches,
                ),
                Container(
                  height: 10,
                )
              ],
            ),
            onRefresh: _refresh));
  }

  Future _refresh() async {
    try {
      await this._playerModel.loadPlayer(this._playerModel.playerID.toString());
    } catch (e) {
      print("refresh error");
      print(e);
    }
  }
}
