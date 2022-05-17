import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';

class UniversalPage extends StatefulWidget {
  const UniversalPage({Key? key}) : super(key: key);

  @override
  State<UniversalPage> createState() => _UniversalPageState();
}

class _UniversalPageState extends State<UniversalPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    Color color = context.theme.primaryColor;
    List<Widget> children = <Widget>[
      Universal(
          width: 200,
          height: 50,
          color: color,
          margin: const EdgeInsets.all(10),
          isClipRRect: true,
          borderRadius: BorderRadius.circular(10),
          alignment: Alignment.center,
          child: const BText('ScrollUniversal', color: Colors.white),
          onTap: () => push(_ScrollUniversalPage())),
      Universal(width: 50, height: 50, color: color),
      const SizedBox(height: 10),
      Universal(width: 50, height: 50, color: color, size: const Size(60, 60)),
      const SizedBox(height: 10),
      Universal(
          color: color.withOpacity(0.2),
          isStack: true,
          size: const Size(100, 100),
          children: <Widget>[
            Universal(
                left: 10, top: 10, color: color, size: const Size(50, 50)),
          ]),
      const SizedBox(height: 10),
      Universal(
          size: const Size(300, 20),
          direction: Axis.horizontal,
          color: Colors.green.withOpacity(0.2),
          children: const <Widget>[
            Universal(flex: 1, color: Colors.red),
            Universal(flex: 2, color: Colors.greenAccent),
          ]),
      const SizedBox(height: 10),
      Universal(
        padding: const EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(10),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        addInkWell: true,
        radius: 100,
        margin: const EdgeInsets.all(10),
        splashColor: color,
        highlightColor: Colors.red,
        hoverColor: Colors.black,
        elevation: 5,
        child: const BText('InkWell'),
        onLongPress: () => showToast('InkWell onLongPress'),
        onDoubleTap: () => showToast('InkWell onDoubleTap'),
        onTap: () => showToast('InkWell onTap'),
      ),
      const SizedBox(height: 10),
      Universal(
          size: const Size(200, 50),
          shadowColor: Colors.red,
          borderRadius: BorderRadius.circular(10),
          color: Colors.green.withOpacity(0.3),
          elevation: 5,
          addCard: true,
          onDoubleTap: () => showToast('Card onDoubleTap')),
      const SizedBox(height: 10),
      Universal(
          decoration: const BoxDecoration(color: Colors.red),
          clipBehavior: Clip.antiAlias,
          color: color,
          opacity: 0.2,
          onTap: () {
            sendRefreshType(EasyRefreshType.refresh);
          },
          size: const Size(200, 50)),
      const SizedBox(height: 20),
      ValueBuilder<bool>(
          initialValue: false,
          builder: (_, bool? value, Function update) {
            return Checkbox(
                value: value,
                shape: const CircleBorder(),
                onChanged: (bool? v) => update(v));
          })
    ];
    children = children.builder((Widget item) => SizeTransition(
        sizeFactor: controller, axis: Axis.horizontal, child: item));
    return ExtendedScaffold(
      appBar: AppBarText('Universal Demo'),
      mainAxisAlignment: MainAxisAlignment.center,
      isScroll: true,
      refreshConfig: RefreshConfig(onRefresh: () async {
        await showToast('onRefresh');
        sendRefreshType(EasyRefreshType.refreshSuccess);
      }),
      children: children,
    );
  }
}

class _ScrollUniversalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExtendedScaffold(
        appBar: AppBarText('ScrollUniversal Demo'),
        mainAxisAlignment: MainAxisAlignment.center,
        body: scrollUniversal(context));
  }

  Widget scrollUniversal(BuildContext context) {
    Color color = context.theme.primaryColor;
    return Universal(
        isScroll: true,
        direction: Axis.horizontal,
        isWrap: true,
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: context.theme.backgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const <BoxShadow>[
              BoxShadow(color: Colors.red, blurRadius: 20),
              BoxShadow(color: Colors.greenAccent, blurRadius: 15),
              BoxShadow(color: Colors.indigo, blurRadius: 10),
              BoxShadow(color: Colors.yellowAccent, blurRadius: 5)
            ]),
        refreshConfig: RefreshConfig(onRefresh: () async {
          await showToast('onRefresh');
          sendRefreshType(EasyRefreshType.refreshSuccess);
        }),
        child: Container(
            margin: const EdgeInsets.all(10),
            width: 130,
            height: 130,
            color: Colors.greenAccent),
        builder: (BuildContext context, StateSetter setState) {
          return Container(
              margin: const EdgeInsets.all(10),
              width: 110,
              height: 110,
              color: Colors.red);
        },
        // isStack: true,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.all(10),
              width: 90,
              height: 90,
              color: color),
          Container(
              margin: const EdgeInsets.all(10),
              width: 70,
              height: 70,
              color: Colors.black),
          Container(
              margin: const EdgeInsets.all(10),
              width: 50,
              height: 50,
              color: Colors.amberAccent),
        ]);
  }
}
