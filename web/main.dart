import 'dart:html';
import 'dart:math';

import 'collisiondetector.dart';
import 'events.dart';
import 'level.dart';
import 'levelrenderer.dart';
import 'physicsapplicator.dart';
import 'recipes/red_zone.dart';

void main() {
    new HuemanateeClient();
}

class HuemanateeClient {
    Level level;
    CanvasElement canvas = querySelector('#delve');

    CollisionDetector collisiondetector = new CollisionDetector();
    LevelRenderer levelrenderer;
    PhysicsApplicator physicsapplicator = new PhysicsApplicator();

    int starttime = new DateTime.now().millisecondsSinceEpoch;
    int lasttime = 0;

    HuemanateeClient() {
        canvas.context2D.imageSmoothingEnabled = false;
        canvas.context2D.translate(canvas.width/2.0,canvas.height/2.0);

        levelrenderer = new LevelRenderer(canvas);
        level = Level1.create(canvas);
        levelrenderer.level = level;
        physicsapplicator.level = level;
        collisiondetector.level = level;

        window.onKeyDown.listen((KeyboardEvent event) {
            EventBus.broadcastEvent(new GameEvent('keydown',event));
        });

        window.onKeyUp.listen((KeyboardEvent event) {
            EventBus.broadcastEvent(new GameEvent('keyup',event));
        });

        window.animationFrame.then(gameLoop);
    }

    void gameLoop(num delta) {
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
}
