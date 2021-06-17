import '../global.dart';
import './modelFuc.dart';
import 'package:sprintf/sprintf.dart';

class Matches with ModelFuc {
  int heroId;
  Hero hero;
  bool win;
  int kills;
  int deaths;
  int assists;
  int lastHits;
  int duration;
  int gameMode;
  int goldPerMin;
  int xpPerMin;
  int heroDamage;
  int heroHealing;
  int towerDamage;
  int lobbyType;
  int matchID;
  int playerSlot;
  int startTime;
  bool radiantWin;

  Matches(
      {this.heroId,
      this.hero,
      this.win,
      this.kills,
      this.deaths,
      this.assists,
      this.lastHits,
      this.duration,
      this.gameMode,
      this.goldPerMin,
      this.xpPerMin,
      this.heroDamage,
      this.heroHealing,
      this.towerDamage,
      this.lobbyType,
      this.matchID,
      this.playerSlot,
      this.startTime,
      this.radiantWin});

  Matches.fromJson(Map<String, dynamic> json) {
    heroId = json['heroId'];
    hero = json['hero'] != null ? new Hero.fromJson(json['hero']) : null;
    win = json['win'];
    kills = json['kills'];
    deaths = json['deaths'];
    assists = json['assists'];
    lastHits = json['lastHits'];
    duration = json['duration'];
    gameMode = json['gameMode'];
    goldPerMin = json['goldPerMin'];
    xpPerMin = json['xpPerMin'];
    heroDamage = json['heroDamage'];
    heroHealing = json['HeroHealing'];
    towerDamage = json['towerDamage'];
    lobbyType = json['lobbyType'];
    matchID = json['matchID'];
    playerSlot = json['playerSlot'];
    startTime = json['startTime'];
    radiantWin = json['radiantWin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['heroId'] = this.heroId;
    if (this.hero != null) {
      data['hero'] = this.hero.toJson();
    }
    data['win'] = this.win;
    data['kills'] = this.kills;
    data['deaths'] = this.deaths;
    data['assists'] = this.assists;
    data['lastHits'] = this.lastHits;
    data['duration'] = this.duration;
    data['gameMode'] = this.gameMode;
    data['goldPerMin'] = this.goldPerMin;
    data['xpPerMin'] = this.xpPerMin;
    data['heroDamage'] = this.heroDamage;
    data['HeroHealing'] = this.heroHealing;
    data['towerDamage'] = this.towerDamage;
    data['lobbyType'] = this.lobbyType;
    data['matchID'] = this.matchID;
    data['playerSlot'] = this.playerSlot;
    data['startTime'] = this.startTime;
    data['radiantWin'] = this.radiantWin;
    return data;
  }

  String getKda() {
    var deaths = this.deaths > 0 ? this.deaths : 1;
    var kda = (this.kills + this.assists) / deaths;
    return kda.toStringAsFixed(2);
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
    //thumb = Global.heroCdnHost + "heroes/" + json['name'] + ".png";
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

  String getThumb() {
    return this.thumb == null ? "images/dota2.png" : this.thumb;
  }
}
