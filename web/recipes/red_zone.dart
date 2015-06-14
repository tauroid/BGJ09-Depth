import 'package:vector_math/vector_math.dart';

import 'dart:html';

import '../camera.dart';
import '../collisionshapes.dart';
import '../eric.dart';
import '../level.dart';
import '../logic.dart';
import '../scenery.dart';
import '../drawables/customdrawable.dart';
import '../mobs/gloopoids.dart';
import '../scenery/movingplatform.dart';

import 'orange_zone.dart';

class RedZone {
    static AudioElement audio;
    static ImageElement bg_img;
    static Scenery background;
    static int index;
    static double zoom = 2.0;


    static void setup() {
        audio = new AudioElement("/assets/huemanatee/audio/TheDepthOfColour.mp3");
        audio.loop = true;
        audio.play();
        bg_img = new ImageElement(src: "/assets/huemanatee/maps/red/red_bg.png");
        background = new Scenery();
        background.position = new Vector3(0.0,0.0,1.3);
        index = background.getFreeIndex();
        background.images[index] = bg_img;
        background.used[index] = true;
    }

    static Level createLevel1(CanvasElement canvas, Eric eric) {
        if (index == null) setup();

        Level level1 = new Level();
        
        Scenery floors = new Scenery();
        index = floors.getFreeIndex();

        floors.zooms[index] = zoom;
        floors.images[index] = new ImageElement(src: "/assets/huemanatee/maps/red/red_1.png");
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
    
        level1.background = background;
        level1.background.position = new Vector3(-60.0,-135.0,0.0);
        level1.scenery.add(floors);
        level1.spawnPoint = new Vector2(130.0*zoom,64.0*zoom);

        eric.position = new Vector3(level1.spawnPoint.x,level1.spawnPoint.y,0.0);

        level1.camera = new Camera.withCanvas(canvas,new Vector2(584.0*zoom,428.0*zoom));
        level1.camera.following = eric;
        level1.mobs.add(eric);
        level1.logic.add(eric);
        level1.warps.add(new Warpzone(new Vector3(268.0*zoom,427.0*zoom,0.0),58*zoom,20*zoom,createLevel2));

        return level1;
    }

    static Level createLevel2(CanvasElement canvas, Eric eric) {
        Level level2 = new Level();

        Scenery floors = new Scenery();
        
        index = floors.getFreeIndex();
        floors.zooms[index] = zoom;
        floors.images[index] = new ImageElement(src: "/assets/huemanatee/maps/red/red_2_frame_comp.png");
        floors.used[index] = true;
        
        index = floors.getFreeIndex();
        floors.positions[index] = new Vector3(100.0*zoom,92.0*zoom,0.0);
        floors.collisionShapes[index] = new Box(120*zoom,336*zoom);
        floors.used[index] = true;

        index = floors.getFreeIndex();
        floors.positions[index] = new Vector3(220.0*zoom,404.0*zoom,0.0);
        floors.collisionShapes[index] = new Box(192*zoom,24*zoom);
        floors.used[index] = true;

        index = floors.getFreeIndex();
        floors.positions[index] = new Vector3(0.0,0.0,0.0);
        floors.collisionShapes[index] = new Box(100*zoom,428*zoom);
        floors.used[index] = true;

        index = floors.getFreeIndex();
        floors.positions[index] = new Vector3(291.0*zoom,92.0*zoom,0.0);
        floors.collisionShapes[index] = new Box(194*zoom,96*zoom);
        floors.used[index] = true;

        index = floors.getFreeIndex();
        floors.positions[index] = new Vector3(484.0*zoom,0.0*zoom,0.0);
        floors.collisionShapes[index] = new Box(100*zoom,428*zoom);
        floors.used[index] = true;

        index = floors.getFreeIndex();
        floors.positions[index] = new Vector3(388.0*zoom,332.0*zoom,0.0);
        floors.collisionShapes[index] = new Box(63*zoom,24*zoom);
        floors.used[index] = true;

        index = floors.getFreeIndex();
        floors.positions[index] = new Vector3(220.0*zoom,212.0*zoom,0.0);
        floors.collisionShapes[index] = new Box(168*zoom,24*zoom);
        floors.used[index] = true;

        index = floors.getFreeIndex();
        floors.positions[index] = new Vector3(460.0*zoom,188.0*zoom,0.0);
        floors.collisionShapes[index] = new Box(24*zoom,240*zoom);
        floors.used[index] = true;

        index = floors.getFreeIndex();
        floors.positions[index] = new Vector3(292.0*zoom,332.0*zoom,0.0);
        floors.collisionShapes[index] = new Box(169*zoom,24*zoom);
        floors.used[index] = true;

        Scenery spikes = new Scenery();
        spikes.kills = true;

        index = spikes.getFreeIndex();
        spikes.positions[index] = new Vector3(292.0*zoom,325.0*zoom,0.0);
        spikes.collisionShapes[index] = new Box(168*zoom,7*zoom);
        spikes.used[index] = true;

        index = spikes.getFreeIndex();
        spikes.positions[index] = new Vector3(220.0*zoom,204.0*zoom,0.0);
        spikes.collisionShapes[index] = new Box(10*zoom,8*zoom);
        spikes.used[index] = true;

        index = spikes.getFreeIndex();
        spikes.positions[index] = new Vector3(285.0*zoom,92.0*zoom,0.0);
        spikes.collisionShapes[index] = new Box(7*zoom,96*zoom);
        spikes.used[index] = true;

        MovingPlatform platform = new MovingPlatform(296.0*zoom,420.0*zoom,15.0,30.0*zoom,100.0);
        platform.position.y = 287.0*zoom;

        index = platform.getFreeIndex();
        platform.zooms[index] = zoom;
        platform.images[index] = new ImageElement(src: "/assets/huemanatee/maps/red/red_2_train.png");
        platform.collisionShapes[index] = new Box(38*zoom,14*zoom);
        platform.used[index] = true;

        level2.background = background;
        level2.background.position = new Vector3(-60.0,-135.0,0.0);
        level2.scenery.add(floors);
        level2.scenery.add(spikes);
        level2.scenery.add(platform);
        level2.spawnPoint = new Vector2(140.0*zoom,25.0*zoom);

        RedGloopoid gloop1 = new RedGloopoid();
        RedGloopoid gloop2 = new RedGloopoid();
        RedGloopoid gloop3 = new RedGloopoid();

        gloop1.anchor = new Vector2(48.0,72.0);
        gloop2.anchor = new Vector2(48.0,72.0);
        gloop3.anchor = new Vector2(48.0,72.0);

        gloop1.position = new Vector3(345.0*zoom,394.0*zoom,0.0);
        gloop2.position = new Vector3(362.0*zoom,397.0*zoom,0.0);
        gloop3.position = new Vector3(333.0*zoom,397.0*zoom,0.0);

        eric.position = new Vector3(level2.spawnPoint.x,level2.spawnPoint.y,0.0);

        level2.camera = new Camera.withCanvas(canvas,new Vector2(584.0*zoom,428.0*zoom));
        level2.camera.following = eric;
        level2.mobs.add(eric);
        level2.mobs.add(gloop1);
        level2.mobs.add(gloop2);
        level2.mobs.add(gloop3);
        level2.logic.add(eric);
        level2.logic.add(platform);
        level2.warps.add(new Warpzone(new Vector3(401.0*zoom,444.0*zoom,0.0),74*zoom,20*zoom,OrangeZone.createLevel1));

        return level2;
    }
}

class RedBGController extends Logic {
    void update(num delta) {
        
    }
}
