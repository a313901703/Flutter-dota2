import 'package:dota2_app/entity/modelFuc.dart';
import './items.dart';
import './Hero.dart';

class MatchInfoEntity with ModelFuc {
  int duration;
  int startTime;
  int firstBloodTime;
  int gameMode;
  int matchID;
  int matchSeqNum;
  bool radiantWin;
  List<Players> players;

  MatchInfoEntity(
      {this.duration,
      this.startTime,
      this.firstBloodTime,
      this.gameMode,
      this.matchID,
      this.matchSeqNum,
      this.radiantWin,
      this.players});

  MatchInfoEntity.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    startTime = json['startTime'];
    firstBloodTime = json['firstBloodTime'];
    gameMode = json['gameMode'];
    matchID = json['matchID'];
    matchSeqNum = json['matchSeqNum'];
    radiantWin = json['radiantWin'];
    if (json['players'] != null) {
      players = new List<Players>();
      json['players'].forEach((v) {
        players.add(new Players.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duration'] = this.duration;
    data['startTime'] = this.startTime;
    data['firstBloodTime'] = this.firstBloodTime;
    data['gameMode'] = this.gameMode;
    data['matchID'] = this.matchID;
    data['matchSeqNum'] = this.matchSeqNum;
    data['radiantWin'] = this.radiantWin;
    if (this.players != null) {
      data['players'] = this.players.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Players {
  int accountID;
  String personaname;
  bool isRadiant;
  int heroID;
  Hero hero;
  List<int> abilityUpgradesArr;
  List abilities;
  int kills;
  int deaths;
  int assists;
  int lastHits;
  int denies;
  int kda;
  int goldPerMin;
  int totalGold;
  int xpPerMin;
  int totalXp;
  int heroDamage;
  int towerDamage;
  int heroHealing;
  int level;
  int backpack0;
  int backpack1;
  int backpack2;
  int backpack3;
  List<ItemsEntity> backpacks;
  int item0;
  int item1;
  int item2;
  int item3;
  int item4;
  int item5;
  List<ItemsEntity> items;

  Players(
      {this.accountID,
      this.personaname,
      this.isRadiant,
      this.heroID,
      this.hero,
      this.abilityUpgradesArr,
      this.abilities,
      this.kills,
      this.deaths,
      this.assists,
      this.lastHits,
      this.denies,
      this.kda,
      this.goldPerMin,
      this.totalGold,
      this.xpPerMin,
      this.totalXp,
      this.heroDamage,
      this.towerDamage,
      this.heroHealing,
      this.level,
      this.backpack0,
      this.backpack1,
      this.backpack2,
      this.backpack3,
      this.backpacks,
      this.item0,
      this.item1,
      this.item2,
      this.item3,
      this.item4,
      this.item5,
      this.items});

  Players.fromJson(Map<String, dynamic> json) {
    accountID = json['accountID'];
    personaname = json['personaname'];
    isRadiant = json['isRadiant'];
    heroID = json['heroID'];
    hero = json['hero'] != null ? new Hero.fromJson(json['hero']) : null;
    abilityUpgradesArr = json['abilityUpgradesArr'].cast<int>();
    abilities = json['abilities'].cast();
    kills = json['kills'];
    deaths = json['deaths'];
    assists = json['assists'];
    lastHits = json['lastHits'];
    denies = json['denies'];
    kda = json['kda'];
    goldPerMin = json['goldPerMin'];
    totalGold = json['totalGold'];
    xpPerMin = json['xpPerMin'];
    totalXp = json['totalXp'];
    heroDamage = json['heroDamage'];
    towerDamage = json['towerDamage'];
    heroHealing = json['heroHealing'];
    level = json['level'];
    backpack0 = json['backpack0'];
    backpack1 = json['backpack1'];
    backpack2 = json['backpack2'];
    backpack3 = json['backpack3'];
    if (json['backpacks'] != null) {
      backpacks = new List<ItemsEntity>();
      json['backpacks'].forEach((v) {
        if (v != null) {
          backpacks.add(new ItemsEntity.fromJson(v));
        } else {
          backpacks.add(new ItemsEntity());
        }
      });
    }
    item0 = json['item0'];
    item1 = json['item1'];
    item2 = json['item2'];
    item3 = json['item3'];
    item4 = json['item4'];
    item5 = json['item5'];
    if (json['items'] != null) {
      items = new List<ItemsEntity>();
      json['items'].forEach((v) {
        if (v != null) {
          items.add(new ItemsEntity.fromJson(v));
        } else {
          items.add(new ItemsEntity());
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountID'] = this.accountID;
    data['personaname'] = this.personaname;
    data['isRadiant'] = this.isRadiant;
    data['heroID'] = this.heroID;
    if (this.hero != null) {
      data['hero'] = this.hero.toJson();
    }
    data['abilityUpgradesArr'] = this.abilityUpgradesArr;
    data['abilities'] = this.abilities;
    data['kills'] = this.kills;
    data['deaths'] = this.deaths;
    data['assists'] = this.assists;
    data['lastHits'] = this.lastHits;
    data['denies'] = this.denies;
    data['kda'] = this.kda;
    data['goldPerMin'] = this.goldPerMin;
    data['totalGold'] = this.totalGold;
    data['xpPerMin'] = this.xpPerMin;
    data['totalXp'] = this.totalXp;
    data['heroDamage'] = this.heroDamage;
    data['towerDamage'] = this.towerDamage;
    data['heroHealing'] = this.heroHealing;
    data['level'] = this.level;
    data['backpack0'] = this.backpack0;
    data['backpack1'] = this.backpack1;
    data['backpack2'] = this.backpack2;
    data['backpack3'] = this.backpack3;
    if (this.backpacks != null) {
      data['backpacks'] = this.backpacks.map((v) => v.toJson()).toList();
    }
    data['item0'] = this.item0;
    data['item1'] = this.item1;
    data['item2'] = this.item2;
    data['item3'] = this.item3;
    data['item4'] = this.item4;
    data['item5'] = this.item5;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
