import 'dart:html';
import 'dart:math';

import 'package:vector_math/vector_math.dart';

import 'animation.dart';
import 'level.dart';
import 'mob.dart';
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
               ..translate(-_level.camera.position.x/1.8,
                           -_level.camera.position.y/1.8)
               ..rotate(-_level.camera.rotation)
               ..scale(_level.camera.zoom,_level.camera.zoom);

        drawScenery(_level.background);

        context.restore();

        context..save()
               ..translate(-_level.camera.position.x,-_level.camera.position.y)
               ..rotate(-_level.camera.rotation)
               ..scale(_level.camera.zoom,_level.camera.zoom);

        drawLevel();
        drawMobs();

        context.restore();
    }

    void drawLevel() {
        _level.scenery.forEach(drawScenery);
    }

    void drawMobs() {
        _level.mobs.forEach((Mob mob) {
            if (mob.hidden) return;

            context..save()
                   ..translate(mob.position.x-mob.anchor.x,
                               mob.position.y-mob.anchor.y)
                   ..rotate(mob.rotation);

            if (mob.animation != null) {
                drawAnimation(mob.animation);
            } else if (mob.drawable != null) {
                mob.drawable.draw();
            }

            context.restore();
        });
    }

    void drawScenery(Scenery scenery) {
        Vector3 itemposition;
        double itemrotation;
        Vector2 itemanchor;
        double itemzoom;

        context..save()
               ..translate(scenery.position.x+scenery.anchorPoint.x,
                           scenery.position.y+scenery.anchorPoint.y)
               ..rotate(scenery.rotation);
        for (int i = 0; i < Scenery.MAX_ITEMS; ++i) {
            if (!scenery.used[i]) continue;
            itemposition = scenery.positions[i] != null ?
                           scenery.positions[i] : Scenery.DEFAULT_POSITION;
            itemrotation = scenery.rotations[i] != null ?
                           scenery.rotations[i] : Scenery.DEFAULT_ROTATION;
            itemzoom = scenery.zooms[i] != null ?
                           scenery.zooms[i] : 1.0;
            itemanchor = scenery.anchors[i] != null ?
                           scenery.anchors[i] : Scenery.DEFAULT_ANCHOR;

            context..save()
                   ..translate(itemposition.x+itemanchor.x,
                               itemposition.y+itemanchor.y)
                   ..rotate(itemrotation)
                   ..scale(itemzoom,itemzoom);

            if (scenery.customDrawables[i] != null) {
                scenery.customDrawables[i].draw();
            } else if (scenery.animations[i] != null) {
                drawAnimation(scenery.animations[i]);
            } else if (scenery.images[i] != null) {
                context.drawImage(scenery.images[i], 0, 0);
            }

            context.restore();
        }
            
        context.restore();
    }

    void drawAnimation(Anim animation) {
        int frame = animation.getFrame();

        if (animation.flipped) {
            context..save()
                   ..scale(-1,1)
                   ..translate(-animation.width*animation.scaling,0.0);
        }

        context.drawImageScaledFromSource(animation.spritesheet,
                          (frame/animation.rows).floor()*animation.width,
                          (frame % animation.rows).floor()*animation.height,
                          animation.width, animation.height,
                          0.0, 0.0,
                          animation.width*animation.scaling,
                          animation.height*animation.scaling);
        
        if (animation.flipped) {
            context.restore();
        }
    }
}
