import 'package:vector_math/vector_math.dart';

import 'mob.dart';
import 'scenery.dart';

class Collision {
    Mob collider;
    Mob collidee;
    Scenery scenecollidee;

    Vector3 distanceAlongNormal;
}
