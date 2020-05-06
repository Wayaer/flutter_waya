import 'package:flutter/material.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/tools/Tools.dart';

class TabNavigationPage extends StatefulWidget {
  final Map<String, Object> arguments;
  final List<BottomNavigationBarItem> navigationBarItem;
  final List<Widget> pageList;
  final int defaultTabIndex;

  TabNavigationPage(
      {Key key, this.arguments, this.defaultTabIndex, this.pageList, this.navigationBarItem})
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: getColors(blue),
        unselectedItemColor: getColors(background),
        backgroundColor: getColors(white),
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
      size: Tools.getWidth(24),
    );
  }
}
