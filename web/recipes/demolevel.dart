import 'package:vector_math/vector_math.dart';

import '../collisionshapes.dart';
import '../eric.dart';
import '../level.dart';
import '../scenery.dart';
import '../drawables/customdrawable.dart';

class DemoLevel {
    static Level create(CanvasElement canvas) {
        Level demolevel = new Level();
        Scenery floor = new Scenery();
        floor.position = new Vector3(0.0,200.0,0.0);
        
        int index = floor.getFreeIndex();
        floor.used[index] = true;
        Box floorCollider = new Box(300.0,100.0);
        floor.collisionShapes[index] = floorCollider;

        index = floor.getFreeIndex();
        floor.used[index] = true;
        floor.customDrawables[index] = new BoxDrawable(canvas.context2D,new Vector2.zero(),floorCollider,new Vector4(0.2,0.3,0.4,1.0));

        demolevel.scenery.add(floor);
        Eric eric = new Eric();
        eric.position = new Vector3(50.0,50.0,0.0);
        demolevel.mobs.add(eric);

        return demolevel;
    }
}
