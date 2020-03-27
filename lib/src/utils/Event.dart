import 'dart:async';

class Event<S> {
  // ignore: close_sinks
  StreamController streamController;

  Event({bool sync: false}) : streamController = StreamController.broadcast(sync: sync);

  void send(event) {
    streamController.add(event);
  }

  void close() {
    streamController.close();
  }

  void listen(listen) {
    streamController.stream.listen(listen);
  }

  void error(error) {
    streamController.addError(error);
  }

  void stream(Stream<S> stream) {
    streamController.addStream(stream);
  }
}


class EventFactory {
  // 工厂模式
  factory EventFactory() => _getInstance();

  static EventFactory get instance => _getInstance();

  static EventFactory _instance;

  Event event;

  EventFactory._internal() {
    // 初始化
    this.event = Event();
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

messageListen(listen) {
  EventFactory.instance.event.listen(listen);
}
