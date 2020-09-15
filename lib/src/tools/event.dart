import 'dart:async';

class EventBus<S> {
  StreamController _streamController;

  StreamController get streamController => _streamController;

  EventBus({bool sync = false}) : _streamController = StreamController.broadcast(sync: sync);

  EventBus.customController(StreamController controller) : _streamController = controller;

  Stream<T> on<T>() {
    if (T == dynamic) {
      return streamController.stream;
    } else {
      return streamController.stream.where((event) => event is T).cast<T>();
    }
  }

  void send(event) {
    _streamController.add(event);
  }

  void close() {
    _streamController.close();
  }

  void listen<T>(void onData(T event)) {
    _streamController.stream.listen(onData);
  }

  void error(error) {
    _streamController.addError(error);
  }

  void stream(Stream<S> stream) {
    _streamController.addStream(stream);
  }
}

class EventFactory {
  /// 工厂模式
  factory EventFactory() => _getInstance();

  static EventFactory get instance => _getInstance();

  static EventFactory _instance;

  EventBus event;

  EventFactory._internal() {
    /// 初始化
    this.event = EventBus();
  }

  static EventFactory _getInstance() {
    if (_instance == null) {
      _instance = EventFactory._internal();
    }
    return _instance;
  }
}

sendMessage(dynamic message) {
  EventFactory.instance.event.send(message);
}

messageDestroy() {
  EventFactory.instance.event.close();
}

messageListen<T>(void onData(T event)) {
  EventFactory.instance.event.listen(onData);
}
