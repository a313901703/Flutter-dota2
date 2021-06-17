import './modelFuc.dart';

class Hero with ModelFuc {
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
    thumb = getHeroThumb(json["name"]);
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
