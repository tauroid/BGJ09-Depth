import 'dart:html';
import 'dart:math';

import 'level.dart';
import 'levelrenderer.dart';
import 'recipes/demolevel.dart';

void main() {
    new HuemanateeClient();
}

class HuemanateeClient {
    Level level;
    CanvasElement canvas = querySelector('#delve');
    LevelRenderer levelrenderer;

    int starttime = new DateTime.now().millisecondsSinceEpoch;

    HuemanateeClient() {
        canvas.context2D.imageSmoothingEnabled = false;

        levelrenderer = new LevelRenderer(canvas);
        level = DemoLevel.create(canvas);
        levelrenderer.level = level;

        window.animationFrame.then(gameLoop);
    }

    void gameLoop(num delta) {
        levelrenderer.draw(delta);
        int time = new DateTime.now().millisecondsSinceEpoch - starttime;
        
        window.animationFrame.then(gameLoop);
    }
}
