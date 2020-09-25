import 'dart:async';

class EventBus<T> {
  EventBus({bool sync = false}) : _streamController = StreamController<T>.broadcast(sync: sync);

  // EventBus.customController(StreamController<T> controller) : _streamController = controller;

  StreamController<T> get streamController => _streamController;

  Stream<dynamic> on<T>() =>
      T == dynamic ? streamController.stream : streamController.stream.where((dynamic event) => event is T).cast<T>();

  final StreamController<T> _streamController;

  void send(T event) => _streamController.add(event);

  void close() => _streamController.close();

  void listen(void onData(dynamic event)) => _streamController.stream.listen(onData);

  void error(dynamic error) => _streamController.addError(error);

  void stream(Stream<T> stream) => _streamController.addStream(stream);
}

class EventFactory {
  factory EventFactory() => _getInstance();

  EventFactory._internal() {
    event = EventBus<dynamic>();
  }

  static EventFactory get instance => _getInstance();

  static EventFactory _instance;

  EventBus<dynamic> event;

  static EventFactory _getInstance() {
    _instance ??= EventFactory._internal();
    return _instance;
  }
}

void sendEvent(dynamic message) => EventFactory.instance.event.send(message);

void eventDestroy() => EventFactory.instance.event.close();

void eventListen(void onData(dynamic event)) => EventFactory.instance.event.listen(onData);
