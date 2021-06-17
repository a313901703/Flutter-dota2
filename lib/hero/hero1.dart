import 'package:flutter/material.dart';

class HeroPage extends StatefulWidget {
  State createState() {
    return new HeroPageState();
  }
}

class HeroPageState extends State<HeroPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("英雄列表"),
      ),
      body: Container(
          child: Row(
        //children: <Widget>[_leftTable(), Expanded(child: _rightTable())],
        children: <Widget>[_leftTable(), Expanded(child: _rightTable())],
      )),
    );
  }

  Widget _leftTable() {
    List<DataRow> dataRows = [];
    for (var i = 0; i < 10; i++) {
      dataRows.add(DataRow(
        cells: [
          DataCell(Container(
            width: 200,
            //color: Colors.black,
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Image.asset(
                  'images/dota2.png',
                  height: 40,
                  width: 60,
                  fit: BoxFit.fill,
                ),
                Text("  敌法师"),
              ],
            ),
          ))
        ],
      ));
    }
    return DataTable(
      columns: [
        DataColumn(
            label: Container(
          alignment: Alignment.center,
          width: 200,
          child: Text("英雄"),
        )),
      ],
      rows: dataRows,
    );
  }

  Widget _rightTable() {
    List<DataRow> dataRows = [];
    for (var i = 0; i < 10; i++) {
      dataRows.add(DataRow(
        cells: [
          DataCell(Text("0")),
          DataCell(Text("0")),
          DataCell(Text("0")),
          DataCell(Text("0")),
          DataCell(Text("0")),
          DataCell(Text("0")),
        ],
      ));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: ClampingScrollPhysics(),
      child: DataTable(
        columns: [
          DataColumn(label: Text("场次")),
          DataColumn(label: Text("胜率")),
          DataColumn(label: Text("KDA")),
          DataColumn(label: Text("场均击杀")),
          DataColumn(label: Text("场均助攻")),
          DataColumn(label: Text("场均死亡")),
        ],
        rows: dataRows,
      ),
    );
  }
}
