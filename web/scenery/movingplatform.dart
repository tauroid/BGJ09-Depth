import 'dart:math';

import 'package:vector_math/vector_math.dart';

import '../scenery.dart';

class MovingPlatform extends ActiveScenery {
    Vector3 velocity = new Vector3.zero();
    double min_x, max_x;
    double max_speed;
    double bufferzone;
    double push;
    int starttime;
    int lasttime;

    MovingPlatform(double min_x, double max_x, double max_speed,
                   double bufferzone, double push) {
        this.starttime = new DateTime.now().millisecondsSinceEpoch;
        this.lasttime = 0;
        this.min_x = min_x;
        this.max_x = max_x;
        this.max_speed = max_speed;
        this.bufferzone = bufferzone;
        this.push = push;
        this.position.x = this.min_x;
    }

    void update(num delta) {
        int time = new DateTime.now().millisecondsSinceEpoch
            - starttime;
        int dt = time - lasttime;
        lasttime = time;

        if (position.x-min_x < bufferzone) {
            velocity.x += push/(1.0+position.x-min_x)*dt/1000.0;
        } else if (max_x-position.x < bufferzone) {
            velocity.x -= push/(1.0+max_x-position.x)*dt/1000.0;
        }

        position.x += velocity.x*dt/1000.0;
    }
}
