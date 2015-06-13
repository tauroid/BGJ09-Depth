import 'dart:html';

import 'package:vector_math/vector_math.dart';

import '../camera.dart';
import '../collisionshapes.dart';

abstract class CustomDrawable {
    CanvasRenderingContext2D context;
    Vector3 basis;

    void draw();

    CustomDrawable(this.context,this.basis);
}

class BoxDrawable extends CustomDrawable {
    Box box;
    int r,g,b;
    double a;

    BoxDrawable(CanvasRenderingContext context, Vector3 basis, Box box, Vector3 colour)
        : super(context,basis),
          this.box = box,
          this.r = (colour.r*255).toInt(),
          this.g = (colour.g*255).toInt(),
          this.b = (colour.b*255).toInt(),
          this.a = colour.a;

    void draw(Camera camera) {
        context..beginPath()
               ..setFillColorRgb(r,g,b,a)
               ..rect(-basis.x,-basis.y,box.width,box.height)
               ..fill()
               ..closePath();
    }
}
