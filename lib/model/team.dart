import 'package:flutter/material.dart';
import '../util/dioUtil.dart';

class TeamModel extends ChangeNotifier {
  static const TEAM_URI = "teams";
  static const ITEM_INFO_URL = "teams/%s";

  List lists = [];
  int count = 0;

  Map<int, dynamic> teamInfos = {};

  Future loadData(int page, int pageSize) async {
    var dio = new DioUtil();
    try {
      var resp = await dio.get(TEAM_URI, {"page": page, "pageSize": pageSize});
      var data = resp.data;
      var teams = data["data"];
      var pagination = data["pagination"];
      if (!teams.isEmpty) {
        lists.addAll(teams);
        count = pagination['count'];
      }
      return data;
    } catch (e) {
      print("_load Heros Err");
      print(e);
    }
  }

  Future loadInfo(int id) async {
    var dio = new DioUtil();
    try {
      var resp = await dio.get(ITEM_INFO_URL.replaceAll('%s', id.toString()));
      var data = resp.data;
      if (!data.isEmpty) {
        teamInfos[id] = data;
      }
      return data;
    } catch (e) {
      print("_load Heros Info Err");
      print(e);
    }
  }
}
