import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';

class AutoScrollItem extends StatefulWidget {
  final Key key;

  ///这是text的具体内容
  final String text;


  ///文字的大小
  final double textSize;

  ///如果没有文字，也可以自定义内容
  final Widget child;

  ///这个是为了监听值变化来刷新页面的，否则页面的state只会初始化一遍
  ///必须指定，否则不会执行动画，或者动画只执行一次
  final ValueNotifier<bool> modeListener;

  ///按钮事件
  final VoidCallback onPress;

  ///动画的方向
  final AutoScrollAnimation autoScrollAnimation;

  ///移动的距离
  double animateDistance;

  ///文字的颜色
  Color textColor;

  /// 跑马灯的切换时长 默认是500毫秒
  final int itemDuration;

  ///是否单行显示，默认是多行的
  final bool singleLine;

  bool get mode => this.modeListener.value;


  set mode(bool mode) => this.modeListener.value = mode;

  set setAnimateDistance(double distance) => animateDistance = distance;

  set setTextColor(Color color) => textColor = color;

  AutoScrollItem({
    Key key, //必须传key，否则动画只会走一次
    this.text,
    Color textColor,
    double textSize,
    ValueNotifier<bool> modeListener,
    AutoScrollAnimation autoScrollAnimation,
    this.onPress,
    this.animateDistance,
    int itemDuration,
    this.child,
    bool singleLine,
  })
      : this.modeListener = modeListener ?? ValueNotifier(false),
        this.textColor = textColor ?? getColors(black),
        this.textSize = textSize ?? 14.0,
        this.autoScrollAnimation = autoScrollAnimation ??
            AutoScrollAnimation.b2t,
        this.itemDuration = itemDuration ?? 500,
        this.key = key ?? GlobalKey(),
        this.singleLine = !singleLine ?? true,
        super(key: key);

  @override
  AutoScrollItemState createState() {
    return AutoScrollItemState();
  }
}

class AutoScrollItemState extends State<AutoScrollItem>
    with SingleTickerProviderStateMixin {
  Animation animation;
  Animation transformAnimation;
  AnimationController animationController;

  Function _updateListener;
  Tween inTween;
  Tween outTween;

  ///是否是x轴移动
  bool isXAnimation = false;

  @override
  void initState() {
    super.initState();
    switch (widget.autoScrollAnimation) {
      case AutoScrollAnimation.t2b:
        inTween = Tween(begin: -widget.animateDistance, end: 0.0);
        outTween = Tween(begin: 0.0, end: widget.animateDistance);
        isXAnimation = false;
        break;
      case AutoScrollAnimation.b2t:
        inTween = Tween(begin: widget.animateDistance, end: 0.0);
        outTween = Tween(begin: 0.0, end: -widget.animateDistance);
        isXAnimation = false;
        break;
      case AutoScrollAnimation.l2r:
        inTween = Tween(begin: -widget.animateDistance, end: 0.0);
        outTween = Tween(begin: 0.0, end: widget.animateDistance);
        isXAnimation = true;
        break;

      case AutoScrollAnimation.r2l:
        inTween = Tween(begin: widget.animateDistance, end: 0.0);
        outTween = Tween(begin: 0.0, end: -widget.animateDistance);
        isXAnimation = true;
        break;
      default:
        inTween = Tween(begin: widget.animateDistance, end: 0.0);
        outTween = Tween(begin: 0.0, end: -widget.animateDistance);
        isXAnimation = false;
        break;
    }
    _updateListener = () {
      setState(() {
        if (widget.modeListener.value) {
          transformAnimation = outTween.animate(CurvedAnimation(
              parent: animationController, curve: Curves.easeInOut));

          animationController.reset();
          animationController.forward();
        }
      });
    };
    widget.modeListener.addListener(_updateListener);

    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.itemDuration))
      ..addListener(() {});

    transformAnimation = inTween.animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut))
      ..addListener(() => setState(() {}));

    animationController.forward();
  }

  @override
  void dispose() {
    widget.modeListener.removeListener(_updateListener);
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget current;
    Matrix4 transform = isXAnimation
        ? new Matrix4.translationValues(transformAnimation.value, 0, 0)
        : new Matrix4.translationValues(0, transformAnimation.value, 0);

    // ..scale(Vector3(
    //     animation.value, animation.value, animation.value)),
    ///也可以用下面的矩阵的用法，可以参考我的文章：
    /// https://www.jianshu.com/p/cc2f9a088fc9
    /// https://juejin.im/post/5be2fd9e6fb9a04a0e2cace0
    //  Matrix4(animation.value, 0, 0, 0, 0, animation.value, 0,
    //     0, 0, 0, 1, 0, 0, transformAnimation.value, 0, 1)
    if (widget.child != null) {
      if (widget.onPress != null) {
        current = GestureDetector(onTap: widget.onPress,
            child: Container(child: widget.child, transform: transform));
      } else {
        current = Container(child: widget.child, transform: transform);
      }
    } else {
      current = GestureDetector(
          onTap: widget.onPress,
          child: Container(
            child: Text(
              widget.text,
              softWrap: widget.singleLine,
              style: TextStyle(
                  fontSize: widget.textSize, color: widget.textColor),
            ),
            transform: transform,
          ));
    }
    return current;
  }
}
