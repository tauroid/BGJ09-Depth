import 'package:vector_math/vector_math.dart';

import 'animation.dart';

abstract class Mob {
    bool active = true, hidden = false;
    Animation animation;
    ImageElement image;
    CustomDrawable drawable;

    Vector3 position = new Vector3.zero();
    Vector2 anchor = new Vector2.zero();
    double rotation = 0;

    void update(num delta);
}
