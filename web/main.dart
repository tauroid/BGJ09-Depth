import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:vector_math/vector_math.dart';

import 'collisiondetector.dart';
import 'events.dart';
import 'eric.dart';
import 'level.dart';
import 'levelrenderer.dart';
import 'logic.dart';
import 'physicsapplicator.dart';
import 'recipes/red_zone.dart';

void main() {
    new HuemanateeClient();
}

class HuemanateeClient extends Subscriber {
    Level level;
    CanvasElement canvas = querySelector('#delve');

    CollisionDetector collisiondetector = new CollisionDetector();
    LevelRenderer levelrenderer;
    PhysicsApplicator physicsapplicator = new PhysicsApplicator();

    Eric eric = new Eric();

    int starttime = new DateTime.now().millisecondsSinceEpoch;
    int lasttime = 0;

    bool newlevel = false;
    var newlevelcallback;

    HuemanateeClient() {
        canvas.context2D.imageSmoothingEnabled = false;
        canvas.context2D.translate(canvas.width/2.0,canvas.height/2.0);

        levelrenderer = new LevelRenderer(canvas);
        loadLevel(RedZone.createLevel1(canvas,eric));
        EventBus.subscribe(this);
        filters.add('warp');
        filters.add('dead');

        window.onKeyDown.listen((KeyboardEvent event) {
            EventBus.broadcastEvent(new GameEvent('keydown',event));
        });

        window.onKeyUp.listen((KeyboardEvent event) {
            EventBus.broadcastEvent(new GameEvent('keyup',event));
        });

        window.animationFrame.then(gameLoop);
    }

    void gameLoop(num delta) {
        if (newlevel) {
            loadLevel(newlevelcallback(canvas,eric));
            newlevel = false;
        }

        int time = new DateTime.now().millisecondsSinceEpoch - starttime;
        delta = time-lasttime;
        lasttime = time;

        level.logic.forEach((Logic logic) => logic.update(delta));
        level.camera.update(delta);
        physicsapplicator.update(delta);
        collisiondetector.detect();
        levelrenderer.draw(delta);
        
        window.animationFrame.then(gameLoop);
    }

    void onEvent(GameEvent e) {
        if (e.type == 'warp') {
            print('warping');
            newlevel = true;
            newlevelcallback = e.data;
        } else if (e.type == 'dead') {
            print('dead');
            new Timer(new Duration(milliseconds: Eric.DEATH_DELAY), () {
                e.data.position = new Vector3(level.spawnPoint.x,level.spawnPoint.y,0.0);
                e.data.resurrect();
            });
        }
    }

    void loadLevel(Level l) {
        level = l;
        levelrenderer.level = level;
        physicsapplicator.level = level;
        collisiondetector.level = level;
    }
}
