import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert' as convert;

import '../util/dioUtil.dart';

class PlayerModel extends ChangeNotifier {
  static const PLAYER_INFO_URI = "players/%s";
  //String playerId = "155948900";
  var playerInfo;
  //比赛情况
  var count;
  //好友
  List friends = [];
  //近期比赛
  List recentMatches = [];
  //常用英雄
  List usedHeroes = [];

  //获取玩家ID
  int get playerID => (playerInfo != null && playerInfo['playerID'] != null)
      ? playerInfo['playerID']
      : 0;

  void loadPlayer(String playerID, [var callback]) async {
    var dio = new DioUtil();
    try {
      var resp = await dio.get(PLAYER_INFO_URI.replaceAll('%s', playerID));
      var data = resp.data;
      if (!data.isEmpty) {
        playerInfo = data["info"] ?? {};
        //count = data["count"] ?? {};
        friends = data["peers"] ?? [];
        recentMatches = data["recentMatches"] ?? [];
        usedHeroes = data["usedHero"] ?? [];
        notifyListeners();
        if (callback is Function) {
          callback();
        }
      }
    } catch (e) {
      print(e);
      return e;
    }
  }

  // void fetch() async {
  //   try {
  //     var playerInfo = fetchPlayerInfo();
  //     if (playerInfo.isEmpty) {

  //     }
  //   } catch (e) {}
  //   var data = _loadPlayerId(this.playerId);
  //   print('fetch');
  //   print(data);
  //   // var playerInfo = await this._loadByPreference();
  //   // if (playerInfo.isEmpty) {}
  // }

  // fetchPlayerInfo() async {
  //   final perfs = await SharedPreferences.getInstance();
  //   var playerInfo = perfs.getString("playerInfo") ?? '';
  //   if (playerInfo != '') {
  //     return convert.jsonDecode(playerInfo);
  //   }
  //   return {};
  // }

}
