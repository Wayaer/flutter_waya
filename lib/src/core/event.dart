import 'dart:async';

/// 基于 StreamController 的泛型事件流，可发送、监听并按类型过滤事件。
class FlEvent<T> {
  /// [sync] 为 true 时同步派发事件，默认异步。
  FlEvent({bool sync = false}) : _streamController = StreamController<T>.broadcast(sync: sync);

  /// 底层事件流控制器，可自行 add 或 close。
  StreamController<T> get streamController => _streamController;

  /// 只监听类型为 E 的事件。
  Stream<E> on<E>() => streamController.stream.where((dynamic event) => event is E).cast<E>();

  final StreamController<T> _streamController;

  /// 发送一个事件。
  void send(T event) => _streamController.add(event);

  /// 关闭事件流，关闭后不能再发送事件。
  void close() => _streamController.close();

  /// 监听事件并返回订阅句柄，需自行 cancel。
  StreamSubscription<T> listen(void Function(dynamic event) onData) => _streamController.stream.listen(onData);

  /// 向事件流推送一个错误。
  void error(Object error) => _streamController.addError(error);

  /// 将另一个事件流并入当前事件流。
  void stream(Stream<T> stream) => _streamController.addStream(stream);
}

/// 全局事件工厂，持有 App 级共享的 `FlEvent<dynamic>` 单例。
class FlEventFactory {
  factory FlEventFactory() => _instance;

  FlEventFactory._() {
    event = FlEvent<dynamic>();
  }

  /// 获取单例。
  static FlEventFactory get instance => _instance;

  static final FlEventFactory _instance = FlEventFactory._();

  /// 全局事件流，销毁后会替换为新实例。
  late FlEvent<dynamic> event;
}

/// 向全局事件流发送事件。
void flSendEvent(dynamic message) => FlEventFactory.instance.event.send(message);

/// 销毁全局事件流并重建，旧订阅随之失效。
void flEventDestroy() {
  final FlEventFactory factory = FlEventFactory.instance;
  factory.event.close();
  factory.event = FlEvent<dynamic>();
}

/// 监听全局事件流并返回订阅句柄，需自行 cancel。
StreamSubscription<dynamic> flEventListen(void Function(dynamic event) onData) =>
    FlEventFactory.instance.event.listen(onData);

/// 订阅者回调签名
typedef FlEventCallback = void Function(dynamic data);

/// 以事件名为键的全局发布/订阅总线（单例）。
class FlEventBus {
  factory FlEventBus() => _instance;

  FlEventBus._();

  static final FlEventBus _instance = FlEventBus._();

  /// 获取单例。
  static FlEventBus get instance => _instance;

  /// 保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  final Map<dynamic, List<FlEventCallback>?> _map = <dynamic, List<FlEventCallback>>{};

  /// 添加订阅者
  void add(String eventName, FlEventCallback eventCallback) {
    _map[eventName] ??= <FlEventCallback>[];
    _map[eventName]!.add(eventCallback);
  }

  /// 移除订阅者
  void remove(String eventName, [FlEventCallback? eventCallback]) {
    final List<FlEventCallback>? list = _map[eventName];
    if (list == null) return;
    if (eventCallback == null) {
      _map.remove(eventName);
    } else {
      list.remove(eventCallback);
    }
  }

  /// 触发事件，事件触发后该事件所有订阅者会被调用
  void emit(String eventName, [dynamic data]) {
    final List<FlEventCallback>? list = _map[eventName];
    if (list == null) return;
    final List<FlEventCallback> callbacks = List<FlEventCallback>.of(list);

    /// 复制后按订阅顺序遍历，避免回调中增删订阅者导致下标错位
    for (int i = 0; i < callbacks.length; ++i) {
      callbacks[i](data);
    }
  }
}
