import 'package:vector_math/vector_math.dart';

import 'events.dart';
import 'collision.dart';
import 'level.dart';
import 'mob.dart';

class PhysicsApplicator extends Subscriber {
    Level _level;

    Vector3 gravity = new Vector3(0.0,600.0,0.0);

    PhysicsApplicator() {
        EventBus.subscribe(this);
        filters.add('collision');
    }

    void set level(Level l) {
        _level = l;
    }
    
    void onEvent(GameEvent event) {
        if (event.type == 'collision') {
            handleCollision(event.data);
        }
    }

    void handleCollision(Collision collision) {
        if (collision.scenecollidee != null) {
            collision.collider.position = collision.collider.position
                + collision.distanceAlongNormal;
            collision.collider.velocity -= collision.distanceAlongNormal.normalized()*
                collision.collider.velocity.dot(collision.distanceAlongNormal.normalized());
        }
    }

    void update(num delta) {
        _level.mobs.forEach((Mob mob) {
            if (!mob.active) return;

            mob.position += mob.velocity*delta/1000.0;
            if (!mob.flying) mob.velocity += gravity*delta/1000.0;
        });
    }
}
