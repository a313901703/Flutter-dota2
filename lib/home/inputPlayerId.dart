import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '../model/player.dart';

class InputPlayerId extends StatefulWidget {
  InputPlayerIdState createState() {
    return new InputPlayerIdState();
  }
}

class InputPlayerIdState extends State<InputPlayerId> {
  final controller = TextEditingController();

  String playerID;

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("添加记录"),
        ),
        body: FlutterEasyLoading(
            child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "进入DOTA2,开启\"公开比赛数据\"",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text("    1.打开dota2游戏客户端")),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text("    2.点击左上角的设置按钮")),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text("    3.浏览到游戏标签的\"综合\"栏目")),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text("    3.启用\"公开比赛数据\"")),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    "输入玩家ID",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              Container(
                  child: Row(
                children: <Widget>[
                  Container(
                    width: 200,
                    child: _textField(controller),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15, top: 3),
                    child: MaterialButton(
                      //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      onPressed: () {
                        //155948900
                        EasyLoading.showProgress(0.3, status: 'loading...');
                        Provider.of<PlayerModel>(context, listen: false)
                            .loadPlayer(this.playerID, () {
                          Navigator.of(context)..pop()..pop();
                        });
                      },
                      child: Text("提交"),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                  )
                ],
              )),
            ],
          ),
        )));
  }

  Widget _textField(TextEditingController controller) {
    return TextField(
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(width: 0.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(width: 0.5))),
      controller: controller,
      //maxLength: 20,
      maxLines: 1,
      onChanged: (text) {
        this.setState(() {
          this.playerID = text;
        });
      },
      onSubmitted: (text) {},
    );
  }
}
