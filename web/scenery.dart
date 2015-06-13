import 'dart:html';

import 'package:vector_math/vector_math.dart';

import 'animation.dart';
import 'collisionshapes.dart';

class Scenery {
    static const int MAX_ITEMS = 20;
    static final Vector3 DEFAULT_POSITION = new Vector3.zero();
    static const double DEFAULT_ROTATION = 0.0;
    static final Vector2 DEFAULT_ANCHOR = new Vector2.zero();

    Vector3 position = new Vector3.zero();
    double rotation = 0;
    Vector3 anchorPoint = new Vector3.zero();
    List<bool> used = new List.filled(MAX_ITEMS,false);
    List<bool> hidden = new List.filled(MAX_ITEMS,false);
    List<ImageElement> images = new List(MAX_ITEMS);
    List<Animation> animations = new List(MAX_ITEMS);
    List<CustomDrawable> customDrawables = new List(MAX_ITEMS);
    List<Vector3> positions = new List(MAX_ITEMS);
    List<double> rotations = new List(MAX_ITEMS);
    List<Vector2> anchors = new List(MAX_ITEMS);

    List<CollisionShape> collisionShapes = new List(MAX_ITEMS);

    int getFreeIndex() {
        for (int i = 0; i < used.length; ++i) {
            if (!used[i]) return i;
        }
        return -1;
    }
}
