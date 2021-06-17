import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_easyloading/flutter_easyloading.dart';

// 提供五套可选主题色
const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class Global {
  // 可选的主题列表
  static List<MaterialColor> get themes => _themes;

  //背景颜色
  static Color get bgColor => Color.fromRGBO(240, 240, 240, 1);

  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  //物理分辨率
  static double get physicalWidth => window.physicalSize.width;

  static get dpr => window.devicePixelRatio;

  static get themeColor => Colors.black;

  static get apiHost => "http://192.168.23.8:8199/v1/";

  static get imageApiHost => "http://192.168.23.8:8700/";

  static get heroCdnHost =>
      "http://cdn.dota2.com/apps/dota2/images/heroes/%s_hphover.png";

  static get itemCdnHost =>
      "http://cdn.dota2.com/apps/dota2/images/items/%s_lg.png";

  // void init(){

  // }
}
