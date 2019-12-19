import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/utils/WayUtils.dart';

// ignore: must_be_immutable
class TabNavigationPage extends StatefulWidget {
  final Map<String, Object> arguments;
  final List<BottomNavigationBarItem> navigationBarItem;
  final List<Widget> pageList;
  final int defaultTabIndex;

  TabNavigationPage(
      {Key key,
      this.arguments,
      this.defaultTabIndex,
      this.pageList,
      this.navigationBarItem})
      : assert(navigationBarItem != null),
        super(key: key);

  @override
  TabNavigationPageState createState() => TabNavigationPageState();
}

class TabNavigationPageState extends State<TabNavigationPage> {
  int tabIndex = 0;
  var currentPage;
  List<Widget> pageList = [];

  @override
  void initState() {
    super.initState();
    pageList = widget.pageList;
    currentPage = widget.defaultTabIndex ?? pageList[tabIndex];
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
        items: widget.navigationBarItem ??
            <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: barIcon(Icons.home), title: Text('home')),
              BottomNavigationBarItem(
                  icon: barIcon(Icons.add_circle),
                  title: Text(
                    'center',
                  )),
              BottomNavigationBarItem(
                  icon: barIcon(Icons.account_circle),
                  title: Text(
                    'mine',
                  )),
            ],
        type: BottomNavigationBarType.fixed,
        // 超过5个页面，需加上此行，不然会无法显示颜色
        onTap: (index) {
          setState(() {
            tabIndex = index;
            currentPage = pageList[tabIndex];
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
