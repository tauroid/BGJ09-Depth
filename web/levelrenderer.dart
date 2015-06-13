import 'dart:html';

import 'level.dart';
import 'scenery.dart';

class LevelRenderer {
    CanvasElement canvas;
    CanvasRenderingContext2D context;
    Level _level;

    LevelRenderer(CanvasElement canvas) : this.canvas = canvas,
                                          this.context = canvas.context2D;

    void set level(Level l) {
        _level = l;
    }

    void draw(double delta) {
        if (_level == null) return;
        context.clearRect(0,0,canvas.parent.client.width,canvas.parent.client.height);

        context..save()
               ..translate(-_level.camera.position.x,-_level.camera.position.y)
               ..rotate(-_level.camera.rotation)
               ..scale(_level.camera.zoom,_level.camera.zoom);

        drawScenery();
        drawMobs();

        context.restore();
    }

    void drawScenery() {
        Vector3 itemposition;
        double itemrotation;
        Vector2 itemanchor;

        _level.scenery.forEach((Scenery element) {
            context..save()
                   ..translate(element.position.x+element.anchorPoint.x,
                              element.position.y+element.anchorPoint.y)
                   ..rotate(element.rotation);

            for (int i = 0; i < Scenery.MAX_ITEMS; ++i) {
                itemposition = element.positions[i] ?
                                element.positions[i] : Scenery.DEFAULT_POSITION;
                itemrotation = element.rotations[i] ?
                                element.rotations[i] : Scenery.DEFAULT_ROTATION;
                itemanchor = element.anchors[i] ?
                                element.anchors[i] : Scenery.DEFAULT_ANCHOR;
            
                context..save()
                       ..translate(itemposition.x+itemanchor.x,
                                   itemposition.y+itemanchor.y)
                       ..rotate(itemrotation);

                if (element.customDrawables[i] != null) {
                    element.customDrawables[i].draw(_level.camera);
                } else if (element.animations[i] != null) {
                    drawAnimation(element.animations[i]);
                }
                
                context.restore();
            }
            
            context.restore();
        });
    }

    void drawMobs() {
        _level.mobs.forEach((Mob mob) {
            if (mob.hidden) return;

            context..save()
                   ..translate(mob.position.x+mob.anchor.x,
                               mob.position.y+mob.anchor.y)
                   ..rotate(mob.rotation);

            if (mob.animation != null) {
                drawAnimation(mob.animation);
            } else if (mob.drawable != null) {
                mob.drawable.draw(_level.camera);
            }

            context.restore();
        });
    }

    void drawAnimation(Animation animation) {
        int frame = animation.getFrame();

        context.drawImageScaledFromSource(animation.spritesheet,
                          (frame/animation.rows).floor()*animation.width,
                          (frame % animation.rows).floor()*animation.height,
                          animation.width, animation.height,
                          0.0, 0.0,
                          animation.width*animation.scaling,
                          animation.height*animation.scaling);
    }
}
