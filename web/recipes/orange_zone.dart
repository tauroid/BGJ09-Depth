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

class OrangeZone {
    static AudioElement audio;
    static ImageElement bg_img;
    static Scenery background;
    static int index;
    static double zoom = 2.0;

    static void setup() {
        audio = new AudioElement("/assets/huemanatee/audio/Depth_Theme_test1.mp3");
        audio.loop = true;
        audio.autoplay = true;
        bg_img = new ImageElement(src: "/assets/huemanatee/maps/red/orange_bg.png");
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
        floors.images[index] = new ImageElement(src: "/assets/huemanatee/maps/orange/orange_1_frame.png");
        floors.used[index] = true;

        return level1;
    }
} 
