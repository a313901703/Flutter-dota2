import 'package:flutter/material.dart';
import '../util/dioUtil.dart';

class NewsModel extends ChangeNotifier {
  static const NEWS_URI = "news";

  List lists = [];
  int count = 0;

  Future loadData([int page = 1, int pageSize = 10]) async {
    //lists = [];
    var dio = new DioUtil();
    try {
      //params
      var resp = await dio.get(NEWS_URI, {"page": page, "pageSize": pageSize});
      var data = resp.data;
      var items = data['data'];
      var pagination = data['pagination'];
      if (!items.isEmpty && items != null) {
        lists.addAll(items);
        count = pagination['count'];
      }
      return;
    } catch (e) {
      print("_loadNewsDataErr");
      print(e);
    }
  }
}
