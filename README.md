# flutter_waya

## [Example](example)

### 运行example 查看 例子
-  [extension](./lib/extension)
    - [context_extension](./lib/extension/src/context_extension.dart) context 扩展
     
    - [object_extension](./lib/extension/src/object_extension.dart)  基础数据类型 扩展
     
    - [widget_extension](./lib/extension/src/widget_extension.dart)  widget 扩展
    
    - [num_extension](./lib/extension/src/num_extension.dart)  num 扩展
    
    - [string_extension](./lib/extension/src/string_extension.dart)  string 扩展

## 工具类
- [utils](./lib/utils)

   - [dio](./lib/utils/src/dio.dart) dio 网络请求封装，统一error 返回[ResponseModel]
   - [event](./lib/utils/src/event.dart) event bus
   - [screen_fit](./lib/utils/src/screen_fit.dart) MediaQueryData

## 多个UI组件

   - [button](./lib/components/button)

      - [DropdownMenuButton](./lib/components/button/dropdown_button.dart) 仿官方 [DropdownButton] 不遮挡默认
      - [LiquidButton](./lib/components/button/liquid_button.dart) 流体按钮
      - [ElasticButton](./lib/components/button/elastic_button.dart) 弹性按钮

   - [carousel](./lib/components/carousel)
      - [indicator](./lib/components/carousel/indicator.dart) 指示器
      - [carousel](./lib/components/carousel/carousel.dart) 轮播图

   - [progress](./lib/components/progress)
      - [LiquidProgress](./lib/components/progress/liquid_progress.dart) 流体progress
      - [Progress](./lib/components/progress/progress.dart) 普通动画progress

   - [refresh](./lib/components/refresh)
      - [EasyRefreshed](./lib/components/refresh/easy_refresh.dart) 封装 flutter_easyrefresh

   - [root](./lib/widgets/root)
      - 根组件使用[ExtendedWidgetsApp](./lib/widgets/root/root.dart) 可直接使用[push()](./lib/widgets/root/root.dart) [pop()](./lib/widgets/root/root.dart) 等多个路由方法和[showDialogPopup()](./lib/widgets/root/root.dart),[showBottomPopup()](./lib/widgets/root/root.dart),[showBottomPagePopup()](./lib/widgets/root/root_part.dart),[showCupertinoBottomPagePopup()](./lib/widgets/root/root_part.dart),[dialogSureCancel()](./lib/widgets/root/root_part.dart),无需传 context ,随处打开,关闭 以上弹窗或页面 必须使用 [closePopup()](./lib/widgets/root/root_part.dart)或直接[pop()](./lib/widgets/root/root_part.dart),
    
      - [Scaffold] 使用 [ExtendedScaffold](./lib/widgets/root/root_part.dart) 可以任意处使用 [showOverlay()](./lib/widgets/root/root_part.dart), [showLoading()](./lib/widgets/root/root_part.dart), [showToast()](./lib/widgets/root/root_part.dart),关闭Overlay 必须使用 [closeOverlay()](./lib/widgets/root/root_part.dart) 或关闭全部 [closeAllOverlay()](./lib/widgets/root/root_part.dart), 

   - [widget](./lib/widgets) 简单封装原生组件

   - [list_wheel](./lib/widgets/list_wheel.dart) 实现 picker 功能的滚动组件

   - [scroll_view](./lib/widgets/scroll/scroll_view.dart)  [ScrollViewAuto] 实现 自适应高度的 [SliverAutoPersistentHeader](lib/widgets/scroll/scroll_view.dart) 和 [SliverAutoAppBar](lib/widgets/scroll/scroll_view.dart) [FlexibleSpaceAutoBar] 无需设置 expandedHeight

   - [ScrollList](./lib/widgets/scroll/scroll_view.dart)  合并[ListView] 和 [GridView] 并添加 下拉刷新 和 上拉加载 功能

   - [universal](./lib/widgets/universal.dart)  中合多个官方组件功能  减少嵌套

## 快捷打包命令 [builds](./builds)

-  sh android.sh  //即可打包命令 可拷贝builds至自己的项目目录 并修改

