import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import '../components/subhead.dart';

class ItemInfo extends StatelessWidget {
  static const String pageLayout = '''
<!DOCTYPE html><html>
<head><title>Navigation Delegate Example</title></head>
<body>
<p>
The navigation delegate is set to block navigation to the youtube website.
</p>
<ul>
<ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
<ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
</ul>
</body>
</html>
''';
  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    var item = args["item"];
    return Scaffold(
      appBar: AppBar(
        title: Text(item["cnName"]),
      ),
      body: FlutterEasyLoading(
        child: Container(
          height: 500,
          child: WebView(
            initialUrl: _renderHtml(item["desc"]),
            onWebViewCreated: (controller) {
              //print("12312313");
            },
            onPageStarted: (String url) {
              EasyLoading.show();
            },
            onPageFinished: (String url) {
              EasyLoading.dismiss();
            },
          ),
        ),
      ),
    );
  }

  Widget _getBodyWidget(Map item) {
    return ListView(
      children: <Widget>[
        Subhead(label: "概况", icon: Icons.person),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    CachedNetworkImage(imageUrl: item['thumb']),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 15),
                      // color: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: Text(item["cost"].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                )),
                          ),
                          Text(item["cnName"])
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                height: 500,
                child: WebView(
                  initialUrl: _renderHtml(item["desc"]),
                  onWebViewCreated: (controller) {
                    print("12312313");
                  },
                ),
              )
            ],
          ),
        )
      ],
      //padding: const EdgeInsets.all(10.0),
      //color: Colors.white,
    );
  }

  _renderHtml(html) {
    String _html = '''
      <!DOCTYPE html><html>
      <head>
        <title></title>
        <meta charset="utf-8" >
        <META HTTP-EQUIV="Pragma"   CONTENT="no-cache">
        <meta http-equiv="content-type" content="text/html" >
        <meta name="viewport" content="initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no,width=device-width" />
        <meta name="format-detection" content="telephone=no" />  
        <meta name="app-mobile-web-app-capable"  content="yes" /> 
        <meta name="app-mobile-web-app-status-bar-style" content="black-translucent" />
      </head>
      <style>
      body{
        //width:100%;
        //min-height:300;
        background:#fff;
        padding:10px;
      }
      .iconTooltip_constr .img-shadow{
        width:60px;
        height:40px;
        margin-right:5px;
      }
      </style>
      <body >
      ${html}
      </body>
      </html>
  ''';
    String s =
        'data:text/html;chartset=utf-8;base64,${base64Encode(const Utf8Encoder().convert(_html))}';
    return s;
  }
}
