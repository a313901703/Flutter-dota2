import 'package:flutter/material.dart';
import '../util/dioUtil.dart';

class HeroModel extends ChangeNotifier {
  static const HERO_URI = "hero";
  static const HERO_INFO_URL = "hero/%s";

  List lists = [];

  Map<int, dynamic> heroInfos = {};

  Future loadData() async {
    var dio = new DioUtil();
    try {
      var resp = await dio.get(HERO_URI);
      var data = resp.data;
      if (!data.isEmpty) {
        lists = data;
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
      var resp = await dio.get(HERO_INFO_URL.replaceAll('%s', id.toString()));
      var data = resp.data;
      if (!data.isEmpty) {
        heroInfos[id] = data;
      }
      return data;
    } catch (e) {
      print("_load Heros Info Err");
      print(e);
    }
  }
}
