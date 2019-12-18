import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/utils/WayUtils.dart';

class TabBarNavigation extends StatefulWidget {
  Map<String, Object> params;

  TabBarNavigation({Key key, this.params}) : super(key: key);

  @override
  TabBarNavigationState createState() => TabBarNavigationState();
}

class TabBarNavigationState extends State<TabBarNavigation> {
  int tabIndex = 4;
  var currentPage;
  List<Widget> list = [];

  @override
  void initState() {
    super.initState();
    currentPage = list[tabIndex];

//
//    //监听行情页面的事件，直接切换到交易页面
//    MsgCenter.instance.eventBus.on<TradeEvent>().listen((TradeEvent evt) {
//      if (evt.type == TradeEvent.DATACHARTPAGE_CLICK_BUYSELL) {
//        if (evt.data["from"] == PAGE_QUOTES) {
//          setState(() {
//            tabIndex = 1;
//            currentPage = list[tabIndex];
//            print("tabIndex:" + tabIndex.toString());
//            if (tabIndex == 1) {
//              print("............ TradeEvent:" + evt.data["tradeSubType"]);
//              MsgCenter.instance.eventBus.fire(new TradeEvent(
//                  TradeEvent.Update_TradeHomePageBody,
//                  {"tradeSubType": "homePage", "tradeMainType": "homePage"}));
//              // currentPage.changeType(evt.data["tradeSubType"],
//              //     evt.data["tradeMainType"], evt.data["type"]);
//            }
//          });
//        }
//      }
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: getColors(tabBarNavigationSelectedItemColor),
        unselectedItemColor: getColors(tabBarNavigationUnSelectedItemColor),
        backgroundColor: getColors(tabBarNavigationColor),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: barIcon(Icons.home), title: Text('home')),
          BottomNavigationBarItem(
              icon: barIcon(Icons.add_circle),
              title: Text(
                '中间',
              )),
          BottomNavigationBarItem(
              icon: barIcon(Icons.account_circle),
              title: Text(
                '我的',
              )),
        ],
        type: BottomNavigationBarType.fixed,
        // 超过5个页面，需加上此行，不然会无法显示颜色
        onTap: (index) {
          setState(() {
            tabIndex = index;
            currentPage = list[tabIndex];
          });
        },
        currentIndex: tabIndex,
      ),
    );
  }

  Widget barIcon(IconData icons) {
    return Icon(
      icons,
      size: WayUtils.getWidth(24),
    );
  }
}
