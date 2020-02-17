import 'dart:async';

class MessageEvent {
  StreamController _streamController;

  StreamController get streamController => _streamController;

  MessageEvent({bool sync = false}) : _streamController = StreamController.broadcast(sync: sync);

  MessageEvent.customController(StreamController controller) : _streamController = controller;

  Stream<T> on<T>() {
    if (T == dynamic) {
      return streamController.stream;
    } else {
      return streamController.stream.where((event) => event is T).cast<T>();
    }
  }

  void send(event) {
    streamController.add(event);
  }

  void destroy() {
    _streamController.close();
  }
}

class MessageFactory {
  // 工厂模式
  factory MessageFactory() => _getInstance();

  static MessageFactory get instance => _getInstance();
  static MessageFactory _instance;

  MessageEvent messageEvent;

  MessageFactory._internal() {
    // 初始化
    this.messageEvent = new MessageEvent();
  }

  static MessageFactory _getInstance() {
    if (_instance == null) {
      _instance = new MessageFactory._internal();
    }
    return _instance;
  }
}

sendMessage(dynamic message) {
  MessageFactory.instance.messageEvent.send(message);
}

messageEventListen([Function listen]) {
  return MessageFactory.instance.messageEvent.on().listen(listen);
}
