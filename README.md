# flutter_waya

## [Example](example)

### 运行example 查看 例子
-  [extension](https://github.com/Wayaer/flutter_waya/tree/main/lib/extension)
    - [context_extension](https://github.com/Wayaer/flutter_waya/tree/main/lib/extension/src/context_extension.dart) context 扩展
     
    - [object_extension](https://github.com/Wayaer/flutter_waya/tree/main/lib/extension/src/object_extension.dart)  基础数据类型 扩展
     
    - [widget_extension](https://github.com/Wayaer/flutter_waya/tree/main/lib/extension/src/widget_extension.dart)  widget 扩展
    
    - [num_extension](https://github.com/Wayaer/flutter_waya/tree/main/lib/extension/src/num_extension.dart)  num 扩展
    
    - [string_extension](https://github.com/Wayaer/flutter_waya/tree/main/lib/extension/src/string_extension.dart)  string 扩展

## 工具类
- [utils](https://github.com/Wayaer/flutter_waya/tree/main/lib/utils)

   - [dio](https://github.com/Wayaer/flutter_waya/tree/main/lib/utils/src/dio.dart) dio 网络请求封装，统一error 返回[ResponseModel]
   - [event](https://github.com/Wayaer/flutter_waya/tree/main/lib/utils/src/event.dart) event bus
   - [screen_fit](https://github.com/Wayaer/flutter_waya/tree/main/lib/utils/src/screen_fit.dart) MediaQueryData

## 多个UI组件

   - [button](https://github.com/Wayaer/flutter_waya/tree/main/lib/components/button)

      - [DropdownMenuButton](https://github.com/Wayaer/flutter_waya/tree/main/lib/components/button/dropdown_button.dart) 仿官方 [DropdownButton] 不遮挡默认
      - [LiquidButton](https://github.com/Wayaer/flutter_waya/tree/main/lib/components/button/liquid_button.dart) 流体按钮
      - [ElasticButton](https://github.com/Wayaer/flutter_waya/tree/main/lib/components/button/elastic_button.dart) 弹性按钮

   - [carousel](https://github.com/Wayaer/flutter_waya/tree/main/lib/components/carousel)
      - [indicator](https://github.com/Wayaer/flutter_waya/tree/main/lib/components/carousel/indicator.dart) 指示器
      - [carousel](https://github.com/Wayaer/flutter_waya/tree/main/lib/components/carousel/carousel.dart) 轮播图

   - [progress](https://github.com/Wayaer/flutter_waya/tree/main/lib/components/progress)
      - [LiquidProgress](https://github.com/Wayaer/flutter_waya/tree/main/lib/components/progress/liquid_progress.dart) 流体progress
      - [Progress](https://github.com/Wayaer/flutter_waya/tree/main/lib/components/progress/progress.dart) 普通动画progress

   - [refresh](https://github.com/Wayaer/flutter_waya/tree/main/lib/components/refresh)
      - [EasyRefreshed](https://github.com/Wayaer/flutter_waya/tree/main/lib/components/refresh/easy_refresh.dart) 封装 flutter_easyrefresh

   - [root](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/root)
      - 根组件使用[ExtendedWidgetsApp](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/root/root.dart) 可直接使用[push()](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/root/root.dart) [pop()](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/root/root.dart) 等多个路由方法和[showDialogPopup()](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/root/root.dart),[showBottomPopup()](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/root/root.dart),[showBottomPagePopup()](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/root/root_part.dart),[showCupertinoBottomPagePopup()](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/root/root_part.dart),[dialogSureCancel()](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/root/root_part.dart),无需传 context ,随处打开,关闭 以上弹窗或页面 必须使用 [closePopup()](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/root/root_part.dart)或直接[pop()](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/root/root_part.dart),
    
      - [Scaffold] 使用 [ExtendedScaffold](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/root/root_part.dart) 可以任意处使用 [showOverlay()](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/root/root_part.dart), [showLoading()](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/root/root_part.dart), [showToast()](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/root/root_part.dart),关闭Overlay 必须使用 [closeOverlay()](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/root/root_part.dart) 或关闭全部 [closeAllOverlay()](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/root/root_part.dart), 

   - [widget](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets) 简单封装原生组件

   - [list_wheel](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/list_wheel.dart) 实现 picker 功能的滚动组件

   - [scroll_view](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/scroll/scroll_view.dart)  [ExtendedScrollView] 实现 自适应高度的 [ExtendedSliverPersistentHeader](lib/widgets/scroll/scroll_view.dart) 和 [ExtendedSliverAppBar](lib/widgets/scroll/scroll_view.dart) [ExtendedFlexibleSpaceBar] 无需设置 expandedHeight

   - [ScrollList](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/scroll/scroll_view.dart)  合并[ListView] 和 [GridView] 并添加 下拉刷新 和 上拉加载 功能

   - [universal](https://github.com/Wayaer/flutter_waya/tree/main/lib/widgets/universal.dart)  中合多个官方组件功能  减少嵌套

## 快捷打包命令 [builds](https://github.com/Wayaer/flutter_waya/tree/main/builds)

-  sh android.sh  //即可打包命令 可拷贝builds至自己的项目目录 并修改

