import 'package:flutter/material.dart';
import '../util/dioUtil.dart';

class ItemModel extends ChangeNotifier {
  static const ITEM_URI = "item";

  List lists = [];

  Future loadData() async {
    var dio = new DioUtil();
    try {
      var resp = await dio.get(ITEM_URI);
      var data = resp.data;
      if (!data.isEmpty) {
        lists = data;
      }
      return data;
    } catch (e) {
      print("_load Items Err");
      print(e);
    }
  }
}
