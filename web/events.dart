import 'dart:collection';

class GameEvent {
    String type;
    dynamic data;

    GameEvent(this.type,this.data);
}

abstract class Subscriber {
    bool subscriber_active = true;
    List<String> filters = new List();
    void onEvent(GameEvent e);
}

class EventBus {
    static List<Subscriber> subscribers = new List();

    static void broadcastEvent(GameEvent event) {
        subscribers.forEach((Subscriber subscriber) {
            if (!subscriber.subscriber_active) return;

            for (String filter in subscriber.filters) {
                if (filter == event.type || filter == "all") {
                    print(event.type);
                    subscriber.onEvent(event);
                    break;
                }
            }
        });
    }

    static void subscribe(Subscriber subscriber) {
        subscribers.add(subscriber);
    }
}
