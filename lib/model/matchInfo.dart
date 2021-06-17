import 'package:flutter/material.dart';
import '../util/dioUtil.dart';

class MatchInfoModel extends ChangeNotifier {
  Map<int, Map> matchesInfo = {};

  static const MATCHES_INFO_URI = "match/%s";

  loadMatchInfo(int matchID) async {
    var dio = new DioUtil();
    try {
      var resp =
          await dio.get(MATCHES_INFO_URI.replaceAll('%s', matchID.toString()));
      var data = resp.data;
      if (!data.isEmpty) {
        //var m = new Map<String, dynamic>.from(data);
        matchesInfo[matchID] = data;
        return data;
        //notifyListeners();
      }
    } catch (e) {}
  }

  Future getMatchInfo(int matchID) async {
    var matchInfo = matchesInfo[matchID];
    try {
      if (matchInfo == null) {
        matchInfo = await loadMatchInfo(matchID);
      }
    } catch (e) {}
    return matchInfo;
  }
}
