import 'dart:async';

class EventBus {
  EventBus({bool sync = false}) : _streamController = StreamController<dynamic>.broadcast(sync: sync);

  EventBus.customController(StreamController<dynamic> controller) : _streamController = controller;

  StreamController<dynamic> get streamController => _streamController;

  Stream<dynamic> on<T>() =>
      T == dynamic ? streamController.stream : streamController.stream.where((dynamic event) => event is T).cast<T>();
  final StreamController<dynamic> _streamController;

  void send(dynamic event) => _streamController.add(event);

  void close() => _streamController.close();

  void listen(void onData(dynamic event)) => _streamController.stream.listen(onData);

  void error(dynamic error) => _streamController.addError(error);

  void stream(Stream<dynamic> stream) => _streamController.addStream(stream);
}

class EventFactory {
  factory EventFactory() => _getInstance();

  EventFactory._internal() {
    event = EventBus();
  }

  static EventFactory get instance => _getInstance();

  static EventFactory _instance;

  EventBus event;

  static EventFactory _getInstance() {
    _instance ??= EventFactory._internal();
    return _instance;
  }
}

void sendMessage(dynamic message) => EventFactory.instance.event.send(message);

void messageDestroy() => EventFactory.instance.event.close();

void messageListen(void onData(dynamic event)) => EventFactory.instance.event.listen(onData);
