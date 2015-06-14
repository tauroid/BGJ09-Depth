import 'package:vector_math/vector_math.dart';

import 'camera.dart';
import 'logic.dart';
import 'scenery.dart';
import 'mob.dart';

class Level {
    Camera camera = new Camera();
    Vector2 spawnPoint = new Vector2.zero();
    Mob cameraMob;
    List<Scenery> scenery = new List();
    List<Mob> mobs = new List();
    List<Logic> logic = new List();
}
