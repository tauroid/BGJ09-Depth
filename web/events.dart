import 'dart:collection';

class GameEvent {
    String type;
    dynamic data;
}

abstract class Subscriber {
    bool subscriber_active = true;
    List<String> filters = new List();
    void onEvent(GameEvent e);
}

class EventBus {
    List<Subscriber> subscribers;

    void broadcastEvent(GameEvent event) {
        subscribers.forEach((Subscriber subscriber) {
            if (!subscriber.subscriber_active) return;

            for (String filter in subscriber.filters) {
                if (filter == event.type || filter == "all") {
                    subscriber.onEvent(event);
                    break;
                }
            }
        });
    }

    void subscribe(Subscriber subscriber) {
        subscribers.add(subscriber);
    }
}
