import 'dart:math';

import 'package:vector_math/vector_math.dart';

import 'collision.dart';
import 'collisionshapes.dart';
import 'events.dart';
import 'mob.dart';
import 'level.dart';
import 'scenery.dart';

class CollisionDetector {
    Level _level;

    void set level(Level l) {
        _level = l;
    }

    void detect() {
        _level.mobs.forEach((Mob mob) {
            if (mob.collisionShape == null) return;
            
            if (mob.collisionShape is Circle) {
                _level.scenery.forEach((Scenery element) {
                    for (int i = 0; i < Scenery.MAX_ITEMS; ++i) {
                        if (element.used[i] && element.collisionShapes[i] != null) {
                            Vector3 shapepos = element.positions[i] != null ?
                                element.positions[i] : Scenery.DEFAULT_POSITION;
                            shapepos += element.position; 
                            Vector3 distanceAlongNormal;
                            if (element.collisionShapes[i] is Box) {
                                distanceAlongNormal = collideCircleAndBox(
                                    mob.position, mob.collisionShape,
                                    shapepos, element.collisionShapes[i]);
                            } else if (element.collisionShapes[i] is Circle) {
                                distanceAlongNormal = collideCircleAndCircle(
                                    mob.position, mob.collisionShape,
                                    shapepos, element.collisionShapes[i]);
                            }
                            if (distanceAlongNormal != null) {
                                Collision collision = new Collision();
                                collision.collider = mob;
                                collision.scenecollidee = element;
                                collision.distanceAlongNormal = distanceAlongNormal;
                                EventBus.broadcastEvent(
                                    new GameEvent('collision',collision));
                            }
                        }
                    }
                });

                _level.mobs.forEach((Mob othermob) {
                    if (othermob.collisionShape == null || mob == othermob) return;
                    
                    if (othermob.collisionShape is Box) {
                        Vector3 distanceAlongNormal = collideCircleAndBox(
                            mob.position, mob.collisionShape,
                            othermob.position, othermob.collisionShape);
                        if (distanceAlongNormal != null) {
                            Collision collision = new Collision();
                            collision.collider = mob;
                            collision.collidee = othermob;
                            collision.distanceAlongNormal = distanceAlongNormal;
                            EventBus.broadcastEvent(new GameEvent('collision',collision));
                        }
                    }
                });

                _level.warps.forEach((Warpzone warp) {
                    Vector3 distanceAlongNormal = collideCircleAndBox(
                        mob.position, mob.collisionShape,
                        warp.position, warp);
                    
                    if (distanceAlongNormal != null) {
                        EventBus.broadcastEvent(new GameEvent('warp',warp.construct));
                    }
                });
            }
        });
    }

    Vector3 collideCircleAndBox(Vector3 circlepos,
                                Circle circle,
                                Vector3 boxpos,
                                Box box) {

        bool horizontalintersection = circlepos.x+circle.hradius > boxpos.x &&
                circlepos.x-circle.hradius < boxpos.x+box.width;
        bool verticalintersection = circlepos.y+circle.vradius > boxpos.y &&
                circlepos.y-circle.vradius < boxpos.y+box.height;
        if (horizontalintersection && verticalintersection) {
            if (min(circlepos.x+circle.hradius - boxpos.x,
                    boxpos.x+box.width - (circlepos.x-circle.hradius)) >
                min(circlepos.y+circle.vradius - boxpos.y,
                    boxpos.y+box.height- (circlepos.y-circle.vradius))) {
                verticalintersection = false;
            } else {
                horizontalintersection = false;
            }
        }
        if (horizontalintersection) {
            if (circlepos.y-circle.vradius < boxpos.y+box.height &&
                    circlepos.y > boxpos.y+box.height/2.0) {
                return new Vector3(0.0,boxpos.y+box.height-circlepos.y+circle.vradius,0.0);
            } else if (circlepos.y+circle.vradius > boxpos.y &&
                    circlepos.y < boxpos.y+box.height/2.0) {
                return new Vector3(0.0,boxpos.y-circlepos.y-circle.vradius,0.0);
            }
        }
        if (verticalintersection) {
            if (circlepos.x-circle.hradius < boxpos.x+box.width &&
                    circlepos.x > boxpos.x+box.width/2.0) {
                return new Vector3(boxpos.x+box.width-circlepos.x+circle.hradius,0.0,0.0);
            } else if (circlepos.x+circle.hradius > boxpos.x &&
                    circlepos.x < boxpos.x+box.width/2.0) {
                return new Vector3(boxpos.x-circlepos.x-circle.hradius,0.0,0.0);
            }
        }
        /*
        Vector3 cd = boxpos+(new Vector3(box.width,box.height,0.0))-circlepos;
        if (cd.length < circle.radius) return -cd.normalized()*(circle.radius-cd.length);
        cd = boxpos+(new Vector3(box.width,0.0,0.0))-circlepos;
        if (cd.length < circle.radius) return -cd.normalized()*(circle.radius-cd.length);
        cd = boxpos+(new Vector3(0.0,box.height,0.0))-circlepos;
        if (cd.length < circle.radius) return -cd.normalized()*(circle.radius-cd.length);
        cd = boxpos+(new Vector3(0.0,0.0,0.0))-circlepos;
        if (cd.length < circle.radius) return -cd.normalized()*(circle.radius-cd.length);
        */
        return null;
    }

    Vector3 collideCircleAndCircle(Vector3 circle1pos, Circle circle1,
                                   Vector3 circle2pos, Circle circle2) {

        Vector3 dist = circle1pos-circle2pos;
        if (dist.length < circle1.hradius+circle2.hradius) {
            return dist.normalized()*(circle1.hradius+circle2.hradius-dist.length);
        }
        return null;
    }
}
