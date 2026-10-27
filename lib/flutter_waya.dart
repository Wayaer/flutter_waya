/// flutter_waya 组件库统一导出入口。
library;

/// 基础能力：事件、屏幕适配、系统 UI、保活
export 'src/core/event.dart';
export 'src/core/keep_alive_wrapper.dart';
export 'src/core/screen_adaptation.dart';
export 'src/core/system_ui_overlay_style.dart';

/// 动画与交互：计数器、折叠、气泡、弹性、展开、翻转、菜单、旋转、波浪
export 'src/animation/animation_counter.dart';
export 'src/animation/auto_collapsing.dart';
export 'src/animation/bubble_button.dart';
export 'src/animation/elastic_builder.dart';
export 'src/animation/expansion_tiles.dart';
export 'src/animation/flip_card.dart';
export 'src/animation/popup_menu.dart';
export 'src/animation/toggle_rotate.dart';
export 'src/animation/wave.dart';

/// 反馈与加载：线性进度、微光骨架
export 'src/feedback/progress.dart';
export 'src/feedback/shimmery.dart';

/// 分页与指示器
export 'src/paging/indicator.dart';
export 'src/paging/page_view.dart';
export 'src/paging/transform.dart';

/// 输入与选择：文本框、装饰器、PIN、评分、开关
export 'src/input/editable_text/decorator_box.dart';
export 'src/input/editable_text/pin_text_field.dart';
export 'src/input/editable_text/text_field.dart';
export 'src/input/rating_stars.dart';
export 'src/input/x_switch.dart';

/// 展示与布局：虚线、尖角容器
export 'src/display/dotted_line.dart';
export 'src/display/wrapper.dart';

/// 计时与验证码
export 'src/timing/counter.dart';
