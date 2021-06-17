import 'package:flutter/material.dart';
import '../util/dioUtil.dart';

class LeagueModel extends ChangeNotifier {
  static const LEAGUES_URI = "leagues";

  List lists = [];
  int count = 0;

  Future loadData([int page = 1, int pageSize = 10]) async {
    //lists = [];
    var dio = new DioUtil();
    try {
      //params
      var resp =
          await dio.get(LEAGUES_URI, {"page": page, "pageSize": pageSize});
      var data = resp.data;
      //print(data);
      var items = data['data'];
      var pagination = data['pagination'];
      if (!items.isEmpty && items != null) {
        lists.addAll(items);
        count = pagination['count'];
      }
      return;
    } catch (e) {
      print("_loadLeaguesDataerr");
      print(e);
    }
  }
}
