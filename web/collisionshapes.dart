import 'package:vector_math/vector_math.dart';

import 'level.dart';

abstract class CollisionShape {}

class Box extends CollisionShape {
    double width, height;

    Box(this.width,this.height);
}

class Circle extends CollisionShape {
    double hradius, vradius;

    Circle(this.hradius,this.vradius);
}

class Warpzone extends Box {
    Vector3 position;
    var construct;

    Warpzone(Vector3 position, double width, double height, Level construct(CanvasElement, Eric)) 
        : super(width,height),
          this.position = position,
          this.construct = construct;
}
