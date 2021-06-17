import '../global.dart';
import 'package:sprintf/sprintf.dart';

mixin ModelFuc {
  String getStartTimeString(int start) {
    var now = new DateTime.now();
    var timestamp = now.millisecondsSinceEpoch ~/ 1000;
    var d = timestamp - start;
    String ret;
    num m;
    if (d < 60) {
      ret = "进行中";
    } else if (d < 60 * 60) {
      m = d ~/ 60;
      ret = m.toString() + "分钟前";
    } else if (d < 3600 * 24) {
      m = d ~/ 3600;
      ret = m.toString() + "小时前";
    } else if (d < 3600 * 24 * 365) {
      m = d ~/ (3600 * 24);
      ret = m.toString() + "天前";
    } else {
      m = d ~/ (3600 * 24 * 365);
      ret = m.toString() + "年前";
    }
    return ret;
  }

  String durationStr(int duration) {
    return ((duration ~/ 60).toString()) + "分钟";
  }

  static const Map gameModes = {
    1: "全英雄选择",
    2: "队长模式",
    3: "随机征召",
    4: "单一征召",
    5: "全英雄随机",
    8: "反队长模式",
    10: "教学模式",
    16: "队长征召",
    18: "技能征召",
    20: "全英雄随机死亡竞赛",
    21: "中路solo",
    22: "天梯全英雄选择",
    23: "加速模式",
  };
  String gameModeStr(int mode) {
    return gameModes[mode] ?? "";
  }

  String getHeroThumb(String name) {
    return sprintf(Global.heroCdnHost, [name]);
  }

  String getItemThumb(String name) {
    return sprintf(Global.itemCdnHost, [name]);
  }
}
