import 'dart:html';
import 'dart:math';

import 'package:vector_math/vector_math.dart';

import 'animation.dart';
import 'assets.dart';
import 'collisionshapes.dart';
import 'events.dart';
import 'mob.dart';
import 'scenery.dart';

import 'mobs/gloopoids.dart';
import 'scenery/movingplatform.dart';

class Eric extends Mob with Subscriber {
    static const int DISENGAGE_TIME = 100;
    static const int ANIMATION_SCALING = 4;
    static const int DEATH_DELAY = 3000;
    static const int DEATH_DISTANCE = 240;

    Map<String,Anim> animations = new Map();

    int lastcontact = new DateTime.now().millisecondsSinceEpoch;
    Vector3 lastcontactlocation;
    
    bool goingleft = false;
    bool leftpressed = false;
    bool rightpressed = false;
    bool jumppressed = false;
    bool inputchanged = false;
    
    int powerlevel = 0;
    double walkaccel = 400.0;
    double maxwalk = 150.0;
    double driftaccel = 100.0;

    int idlestart = 0;
    double idlespeed = 0.0;

    EricState state = EricState.IDLE;
    Scenery contactscenery;
    bool contacthorizontal;

    Eric() {
        EventBus.subscribe(this);
        filters.add('keydown');
        filters.add('keyup');
        filters.add('collision');

        Assets.buildAnimation("/assets/huemanatee/animations/eric/manatee_death_fall.png", 24, 24)
            .then((anim) => animations['death_fall'] = anim);
        Assets.buildAnimation("/assets/huemanatee/animations/eric/manatee_death_sideways.png", 24, 24)
            .then((anim) => animations['death_sideways'] = anim);
        Assets.buildAnimation("/assets/huemanatee/animations/eric/manatee_idle.png",24,24)
            .then((anim) {
                anim.framedelayms = 500;
                animations['idle'] = anim;
                animation = anim;
            });
        Assets.buildAnimation("/assets/huemanatee/animations/eric/manatee_walk.png",24,24)
            .then((anim) {
                anim.framedelayms = 250;
                animations['walk'] = anim;
            });
        Assets.buildAnimation("/assets/huemanatee/animations/eric/manatee_wallgrab.png",24,24)
            .then((anim) => animations['wallgrab'] = anim);
        Assets.buildAnimation("/assets/huemanatee/animations/eric/manatee_falling.png",24,24)
            .then((anim) => animations['falling'] = anim);

        collisionShape = new Circle(10.0*ANIMATION_SCALING,4.0*ANIMATION_SCALING);
        anchor = (new Vector2(12.0,20.0))*ANIMATION_SCALING.toDouble();
    }

    void onEvent(GameEvent event) {
        if (event.type == 'collision') {
            if (event.data.scenecollidee != null) {
                lastcontact = new DateTime.now().millisecondsSinceEpoch;
                if (contactscenery == event.data.scenecollidee) return;

                contactscenery = event.data.scenecollidee;
                if ((event.data.distanceAlongNormal.dot(new Vector3(0.0,1.0,0.0))).abs() >
                        (event.data.distanceAlongNormal.dot(new Vector3(1.0,0.0,0.0))).abs()) {
                    contacthorizontal = true;
                } else {
                    contacthorizontal = false;
                }

                if (contactscenery.kills) {
                    if (contacthorizontal) {
                        kill(animations['death_fall']);
                    } else {
                        kill(animations['death_sideways']);
                    }
                } else if (contacthorizontal && lastcontactlocation != null &&
                        position.y - lastcontactlocation.y > DEATH_DISTANCE) {
                    kill(animations['death_fall']);
                }
                    
                lastcontactlocation = position;
            } else if (event.data.collidee != null && event.data.collidee is Gloopoid) {
                print('found gloop');
                event.data.collidee.explode();
                gainPower(event.data.collidee.powerlevel);
            }            

        }

        if (event.type == 'keydown') {
            if (event.data.keyCode == KeyCode.LEFT ||
                event.data.keyCode == KeyCode.A) leftpressed = true;
            if (event.data.keyCode == KeyCode.RIGHT ||
                event.data.keyCode == KeyCode.D) rightpressed = true;

            inputchanged = true;
        }

        if (event.type == 'keyup') {
            if (event.data.keyCode == KeyCode.LEFT ||
                event.data.keyCode == KeyCode.A) leftpressed = false;
            if (event.data.keyCode == KeyCode.RIGHT ||
                event.data.keyCode == KeyCode.D) rightpressed = false;

            inputchanged = true;
        }
    }

    void gainPower(int powerlevel) {
    }

    void kill(Anim anim) {
        state = EricState.DEAD;
        animation = anim;
        animation.flipped = goingleft;
        animation.play(false);
        EventBus.broadcastEvent(new GameEvent('dead',this));
        active = false;
    }

    void resurrect() {
        state = EricState.IDLE;
        active = true;
    }

    void update(num delta) {
        int time = new DateTime.now().millisecondsSinceEpoch;

        if (time - lastcontact > DISENGAGE_TIME) contactscenery = null;

        if (state != EricState.DEAD && contactscenery == null && state != EricState.AIRSCOOTING) {
            state = EricState.FALLING;
        }

        switch (state) {
            case EricState.IDLE:
                if (animation != animations['idle']) {
                    idlestart = time;
                    idlespeed = velocity.length;
                    animation = animations['idle'];
                    if (animation != null) animation.flipped = goingleft;
                }

                if (contactscenery != null) {
                    double x_rel = 0.0;
                    if (contactscenery is MovingPlatform) {
                        MovingPlatform platform = contactscenery as MovingPlatform;
                        x_rel = platform.velocity.x;
                    }
                    if (contactscenery.slowdowntime > (time-idlestart)) {
                        velocity.x -= x_rel;
                        velocity.x = (velocity.x > 0 ? 1 : -1)*idlespeed
                            *(contactscenery.slowdowntime-time+idlestart)
                            /contactscenery.slowdowntime;
                        velocity.x += x_rel;
                    } else if (time-idlestart > contactscenery.slowdowntime) {
                        velocity.x = x_rel;
                    }
                }

                if (inputchanged) {
                    if (leftpressed || rightpressed) {
                        state = EricState.WALKING;
                    } else if (jumppressed) {
                        state = EricState.FALLING;
                    }
                    inputchanged = false;
                }
                    
                break;
            case EricState.WALKING:
                if (animation != animations['walk']) {
                    animation = animations['walk'];
                    if (animation != null) decideDirection();
                }

                velocity.x += (goingleft ? -1 : 1)*walkaccel*delta/1000.0;
                if (velocity.x.abs() > maxwalk) velocity.x = (goingleft ? -1 : 1)*maxwalk;
                
                if (inputchanged) {
                    if (!leftpressed && !rightpressed) {
                        state = EricState.IDLE;
                    } else {
                        decideDirection();
                    }
                    inputchanged = false;
                }
                
                break;
            case EricState.FALLING:
                if (animation != animations['falling']) {
                    animation = animations['falling'];
                    if (animation != null) animation.flipped = goingleft;
                }

                if (leftpressed != rightpressed) {
                    decideDirection();
                    velocity.x += (goingleft ? -1 : 1)*driftaccel*delta/1000.0;
                    if (velocity.x.abs() > maxwalk) velocity.x = (goingleft ? -1 : 1)*maxwalk;
                }

                if (contactscenery != null) {
                    if (contacthorizontal) {
                        decideLandState();
                    }
                }

                break;
            case EricState.WALLGRAB:
                if (animation != animations['wallgrab']) animation = animations['wallgrab'];

                break;
            case EricState.DEAD:
                break;
        }
    }

    void decideDirection() {
        if (leftpressed && !rightpressed) {
            goingleft = true;
            animation.flipped = true;
        } else if (!leftpressed && rightpressed) {
            goingleft = false;
            animation.flipped = false;
        }
    }

    void decideLandState() {
        if (!leftpressed && !rightpressed) {
            state = EricState.IDLE;
        } else {
            state = EricState.WALKING;
            decideDirection();
        }
    }
}

class EricState {
    static const IDLE = const EricState._(0);
    static const WALKING = const EricState._(1);
    static const FALLING = const EricState._(2);
    static const AIRSCOOTING = const EricState._(3);
    static const WALLGRAB = const EricState._(4);
    static const WALLSLIDING = const EricState._(5);
    static const PHASING = const EricState._(6);
    static const DEAD = const EricState._(7);

    static get values => [IDLE,WALKING,FALLING,AIRSCOOTING,WALLGRAB,WALLSLIDING,PHASING,DEAD];

    final int value;

    const EricState._(this.value);
}
