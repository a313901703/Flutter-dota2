import 'package:flutter/material.dart';
import "package:flutter_spinkit/flutter_spinkit.dart";

import '../global.dart';

class LoadingListView extends StatefulWidget {
  LoadingListView(
      {Key key,
      this.pageSize,
      this.page,
      this.count,
      @required this.data,
      @required this.isLoading,
      this.header,
      @required this.loadData,
      this.itemBuilder});
  final List data;
  final int pageSize;
  final int page;
  final int count;
  final bool isLoading;
  final Widget header;
  final loadData;
  final itemBuilder;

  LoadingListViewState createState() {
    return new LoadingListViewState();
  }
}

class LoadingListViewState extends State<LoadingListView> {
  ScrollController _controller = new ScrollController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        widget.loadData();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.loadData();
    });
  }

  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (widget.loadData != null) {
  //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //       widget.loadData();
  //     });
  //   }
  // }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext content) {
    return Container(
      decoration: BoxDecoration(color: Global.bgColor),
      child: Container(
        child: ListView.separated(
            controller: _controller,
            physics: new ClampingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0 && widget.header != null) {
                return _renderHeader();
              }
              if (index >= _getItemCount() - 1) {
                return _renderBottom();
              }
              var i = widget.header != null ? index - 1 : index;
              return Container(
                color: Colors.white,
                //height: 100,
                child: _renderItemBuilder(
                  context,
                  i,
                ),
              );
              //return new Match(index: index);
            },
            separatorBuilder: (BuildContext context, int index) {
              return new Divider(
                height: 0,
              );
            },
            itemCount: _getItemCount()),
      ),
    );
  }

  Widget _renderHeader() {
    if (widget.header != null) {
      return widget.header;
    }
    return Container();
  }

  Widget _renderBottom() {
    Widget _widget;
    if (widget.data.length >= widget.count) {
      _widget = Text("没有更多数据");
    } else if (widget.isLoading == false) {
      return Container();
    } else {
      _widget = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(""),
          ),
          SpinKitFadingCircle(color: Colors.black, size: 20.0),
          Text("   加载中"),
          Expanded(
            child: Text(""),
          ),
        ],
      );
    }

    return Container(
      height: 40,
      alignment: Alignment.center,
      child: _widget,
    );
  }

  Widget _renderItemBuilder(BuildContext context, int index) {
    if (widget.itemBuilder != null) {
      return widget.itemBuilder(context, widget.data[index], index);
    }
    return Container(
      color: Colors.white,
      height: 100,
      child: Text("index" + index.toString()),
    );
  }

  _getItemCount() {
    var count = widget.data.length + 1;
    if (widget.header != null) {
      count++;
    }
    return count;
  }
}
