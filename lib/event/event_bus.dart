import 'dart:async';

class EventBus {
  static final EventBus _instance = EventBus._internal();

  StreamController _streamController;

  factory EventBus() {
    return _instance;
  }

  EventBus._internal() {
    _streamController = new StreamController.broadcast();
  }

  StreamController get streamController => _streamController;

  Stream<T> register<T>() {
    if (T == dynamic) {
      return streamController.stream;
    } else {
      return streamController.stream.where((event) => event is T).cast<T>();
    }
  }

  void post(event) {
    streamController.add(event);
  }

  void destroy() {
    streamController.close();
  }
}

//void main() {
//  EventManager eventManager = EventManager();
//  print("test init 1");
//  EventManager eventManager2 = EventManager();
//  print("test init 2");
//  if (eventManager == null) {
//    print("eventmanager  is null");
//  }
//  if (eventManager2 == null) {
//    print("eventmanager2  is null");
//  }
//  if (eventManager == eventManager2) {
//    print("=====");
//  } else {
//    print("----------");
//  }
//  print("test");
//}
