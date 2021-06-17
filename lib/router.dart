import './hero/hero.dart';
import './hero/heroInfo.dart';
import './item/main.dart';
import './item/itemInfo.dart';

var routers = {
  //英雄
  "/heroes": (context) => new HeroPage(),
  "/hero/info": (context) => new HeroInfo(),
  //物品
  "/items": (context) => ItemPage(),
  "/item/info": (context) => ItemInfo(),
};

class Routers {
  static Map get routers => {
        //英雄
        "/heroes": (context) => new HeroPage(),
        "/hero/info": (context) => new HeroInfo(),
        //物品
        "/items": (context) => ItemPage(),
        "/item/info": (context) => ItemInfo(),
      };
}
