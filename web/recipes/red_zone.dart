import 'package:vector_math/vector_math.dart';

import 'dart:html';

import '../camera.dart';
import '../collisionshapes.dart';
import '../eric.dart';
import '../level.dart';
import '../logic.dart';
import '../scenery.dart';
import '../drawables/customdrawable.dart';

class Level1 {
    static Level create(CanvasElement canvas) {
        Level level1 = new Level();

        Scenery background = new Scenery();
        int index = background.getFreeIndex();
        background.images[index] = new ImageElement(src: "/assets/huemanatee/maps/red_bg.png");
        background.used[index] = true;
        
        Scenery floors = new Scenery();
        index = floors.getFreeIndex();

        double zoom = 2.0;
        floors.zooms[index] = zoom;
        floors.images[index] = new ImageElement(src: "/assets/huemanatee/maps/red_1.png");
        floors.used[index] = true;
        
        index = floors.getFreeIndex();
        floors.collisionShapes[index] = new Box(100*zoom,428*zoom);
        floors.used[index] = true;
    
        index = floors.getFreeIndex();
        floors.positions[index] = new Vector3(100.0*zoom,92.0*zoom,0.0);
        floors.collisionShapes[index] = new Box(121*zoom,335*zoom);
        floors.used[index] = true;

        index = floors.getFreeIndex();
        floors.positions[index] = new Vector3(220.0*zoom,212.0*zoom,0.0);
        floors.collisionShapes[index] = new Box(120*zoom,144*zoom);
        floors.used[index] = true;

        index = floors.getFreeIndex();
        floors.positions[index] = new Vector3(484.0*zoom,0.0,0.0);
        floors.collisionShapes[index] = new Box(100*zoom,428*zoom);
        floors.used[index] = true;

        index = floors.getFreeIndex();
        floors.positions[index] = new Vector3(388.0*zoom,332.0*zoom,0.0);
        floors.collisionShapes[index] = new Box(63*zoom,24*zoom);
        floors.used[index] = true;

        index = floors.getFreeIndex();
        floors.positions[index] = new Vector3(326.0*zoom,404.0*zoom,0.0);
        floors.collisionShapes[index] = new Box(158*zoom,24*zoom);
        floors.used[index] = true;
    
        index = floors.getFreeIndex();
        floors.positions[index] = new Vector3(196.0*zoom,356.0*zoom,0.0);
        floors.collisionShapes[index] = new Box(72*zoom,72*zoom);
        floors.used[index] = true;
    
        level1.scenery.add(background);
        level1.scenery.add(floors);
        level1.spawnPoint = new Vector2(130.0*zoom,64.0*zoom);

        Eric eric = new Eric();
        eric.position = level1.spawnPoint;

        level1.camera = new Camera.withCanvas(canvas,new Vector2(584.0*zoom,428.0*zoom));
        level1.camera.following = eric;
        level1.mobs.add(eric);
        level1.logic.add(eric);

        return level1;
    }
}

class RedBGController extends Logic {
    void update(num delta) {
        
    }
}
