import 'package:dota2_app/entity/modelFuc.dart';

class ItemsEntity with ModelFuc {
  int cost;
  int id;
  String cnName;
  String enName;
  String name;
  int recipe;
  int secretShop;
  String thumb;

  ItemsEntity(
      {this.cost,
      this.id,
      this.cnName,
      this.enName,
      this.name,
      this.recipe,
      this.secretShop,
      this.thumb});

  ItemsEntity.fromJson(Map<String, dynamic> json) {
    cost = json['cost'];
    id = json['id'];
    cnName = json['cnName'];
    enName = json['enName'];
    name = json['name'];
    recipe = json['recipe'];
    secretShop = json['secretShop'];
    // thumb = json['thumb'];
    thumb = getItemThumb(json['name']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cost'] = this.cost;
    data['id'] = this.id;
    data['cnName'] = this.cnName;
    data['enName'] = this.enName;
    data['name'] = this.name;
    data['recipe'] = this.recipe;
    data['secretShop'] = this.secretShop;
    data['thumb'] = this.thumb;
    return data;
  }
}
