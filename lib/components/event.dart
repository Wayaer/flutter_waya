import 'dart:async';

class Event<T> {
  Event({bool sync = false})
      : _streamController = StreamController<T>.broadcast(sync: sync);

  /// EventBus.customController(StreamController<T> controller) : _streamController = controller;

  StreamController<T> get streamController => _streamController;

  Stream<dynamic> on<E>() => T == dynamic
      ? streamController.stream
      : streamController.stream.where((dynamic event) => event is T).cast<T>();

  final StreamController<T> _streamController;

  void send(T event) => _streamController.add(event);

  void close() => _streamController.close();

  void listen(void Function(dynamic event) onData) =>
      _streamController.stream.listen(onData);

  void error(Object error) => _streamController.addError(error);

  void stream(Stream<T> stream) => _streamController.addStream(stream);
}

class EventFactory {
  factory EventFactory() => _getInstance();

  EventFactory._internal() {
    event = Event<dynamic>();
  }

  static EventFactory? get instance => _getInstance();

  static EventFactory? _instance;

  late Event<dynamic> event;

  static EventFactory _getInstance() => _instance ??= EventFactory._internal();
}

void sendEvent(dynamic message) => EventFactory.instance!.event.send(message);

void eventDestroy() => EventFactory.instance!.event.close();

void eventListen(void Function(dynamic event) onData) =>
    EventFactory.instance!.event.listen(onData);

/// 订阅者回调签名
typedef EventCallback = void Function(dynamic data);

class EventBus {
  factory EventBus() => _singleton ??= EventBus._();

  EventBus._();

  static EventBus? _singleton;

  /// 保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  final Map<dynamic, List<EventCallback>?> _map =
      <dynamic, List<EventCallback>>{};

  /// 添加订阅者
  void add(String eventName, EventCallback eventCallback) {
    _map[eventName] ??= <EventCallback>[];
    _map[eventName]!.add(eventCallback);
  }

  /// 移除订阅者
  void remove(String eventName, [EventCallback? eventCallback]) {
    final List<EventCallback>? list = _map[eventName];
    if (list == null) return;
    if (eventCallback == null) {
      _map.remove(eventName);
    } else {
      list.remove(eventCallback);
    }
  }

  /// 触发事件，事件触发后该事件所有订阅者会被调用
  void emit(String eventName, [dynamic data]) {
    final List<EventCallback>? list = _map[eventName];
    if (list == null) return;
    final int len = list.length - 1;

    /// 反向遍历，防止订阅者在回调中移除自身带来的下标错位
    for (int i = len; i > -1; --i) {
      list[i](data);
    }
  }
}
