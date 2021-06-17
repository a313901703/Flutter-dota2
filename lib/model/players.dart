import 'package:flutter/material.dart';

import '../util/dioUtil.dart';

class PlayersModel extends ChangeNotifier {
  static const PLAYER_INFO_URI = "players/%s";

  Map players;

  void loadPlayer(String playerID, [var callback]) async {
    var dio = new DioUtil();
    try {
      var resp = await dio.get(PLAYER_INFO_URI.replaceAll('%s', playerID));
      var data = resp.data;
      if (!data.isEmpty) {
        players[playerID] = data;
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
}
