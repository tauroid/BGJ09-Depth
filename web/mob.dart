import 'package:vector_math/vector_math.dart';

import 'animation.dart';
import 'logic.dart';

abstract class Mob extends Logic {
    bool active = true, hidden = false, flying = false;
    Animation animation;
    ImageElement image;
    CustomDrawable drawable;
    CollisionShape collisionShape;

    Vector3 position = new Vector3.zero();
    Vector3 velocity = new Vector3.zero();
    Vector2 anchor = new Vector2.zero();
    double rotation = 0;

    void update(num delta);
}
