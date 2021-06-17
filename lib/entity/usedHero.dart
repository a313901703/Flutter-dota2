import 'package:dota2_app/entity/modelFuc.dart';
import 'package:sprintf/sprintf.dart';
import '../global.dart';

class UsedHero with ModelFuc {
  int games;
  int heroId;
  Hero hero;
  int win;
  int lastPlayed;

  UsedHero({this.games, this.heroId, this.hero, this.win, this.lastPlayed});

  UsedHero.fromJson(Map<String, dynamic> json) {
    games = json['games'];
    heroId = json['heroId'];
    hero = json['hero'] != null ? new Hero.fromJson(json['hero']) : null;
    win = json['win'];
    lastPlayed = json['lastPlayed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['games'] = this.games;
    data['heroId'] = this.heroId;
    if (this.hero != null) {
      data['hero'] = this.hero.toJson();
    }
    data['win'] = this.win;
    data['lastPlayed'] = this.lastPlayed;
    return data;
  }
}

class Hero {
  int id;
  int legs;
  String cnName;
  String enName;
  String name;
  String attackType;
  String primaryAttr;
  List<String> roles;
  String thumb;

  Hero(
      {this.id,
      this.legs,
      this.cnName,
      this.enName,
      this.name,
      this.attackType,
      this.primaryAttr,
      this.roles,
      this.thumb});

  Hero.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    legs = json['legs'];
    cnName = json['cnName'];
    enName = json['enName'];
    name = json['name'];
    attackType = json['attackType'];
    primaryAttr = json['primaryAttr'];
    roles = json['roles'].cast<String>();
    thumb = sprintf(Global.heroCdnHost, [json['name']]);
    //thumb = Global.imageApiHost + "heroes/" + json['name'] + ".png";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['legs'] = this.legs;
    data['cnName'] = this.cnName;
    data['enName'] = this.enName;
    data['name'] = this.name;
    data['attackType'] = this.attackType;
    data['primaryAttr'] = this.primaryAttr;
    data['roles'] = this.roles;
    data['thumb'] = this.thumb;
    return data;
  }
}
