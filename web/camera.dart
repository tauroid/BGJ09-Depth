import 'dart:math';

import 'package:vector_math/vector_math.dart';

class Camera {
    CanvasElement canvas;
    Vector2 position = new Vector2.zero();
    double rotation = 0;
    double zoom = 1;
    double trackwidth, trackheight;
    Vector2 range = new Vector2.zero();

    Mob following;

    Camera();
    Camera.withCanvas(CanvasElement canvas, Vector2 range) : this.canvas = canvas,
                                                             this.range = range {
        trackwidth = canvas.width/3.0;
        trackheight = canvas.height/3.0;
    }

    void update(num delta) {
        if (following != null && canvas != null) {
            if (following.position.x - position.x > trackwidth/2.0/zoom)
                position.x = following.position.x - trackwidth/2.0/zoom;
            else if (following.position.x - position.x < -trackwidth/2.0/zoom)
                position.x = following.position.x + trackwidth/2.0/zoom;
            if (following.position.y - position.y > trackheight/2.0/zoom)
                position.y = following.position.y - trackheight/2.0/zoom;
            else if (following.position.y - position.y < -trackheight/2.0/zoom)
                position.y = following.position.y + trackheight/2.0/zoom;

            position.x = min(max(canvas.width/2.0/zoom,position.x),range.x-canvas.width/2.0/zoom);
            position.y = min(max(canvas.height/2.0/zoom,position.y),range.y-canvas.height/2.0/zoom);
        }
    }
}
