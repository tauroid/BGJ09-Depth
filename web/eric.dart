import 'dart:html';
import 'dart:math';

import 'package:vector_math/vector_math.dart';

import 'animation.dart';
import 'assets.dart';
import 'collisionshapes.dart';
import 'events.dart';
import 'mob.dart';
import 'scenery.dart';

class Eric extends Mob with Subscriber {
    static const int DISENGAGE_TIME = 100;
    static const int ANIMATION_SCALING = 4;

    Map<String,Animation> animations = new Map();

    int lastcontact = new DateTime.now().millisecondsSinceEpoch;
    
    bool goingleft = false;
    bool leftpressed = false;
    bool rightpressed = false;
    bool jumppressed = false;
    bool inputchanged = false;
    
    int powerlevel = 0;
    double walkaccel = 400.0;
    double maxwalk = 150.0;

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
            .then((anim) {
                anim.repeat = false;
                animations['death_fall'] = anim;
            });
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

        collisionShape = new Circle(10*ANIMATION_SCALING);
        anchor = (new Vector2(12.0,14.0))*ANIMATION_SCALING;
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

    void update(num delta) {
        int time = new DateTime.now().millisecondsSinceEpoch;

        if (time - lastcontact > DISENGAGE_TIME) contactscenery = null;

        if (contactscenery == null && state != EricState.AIRSCOOTING) {
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

                if (contactscenery != null &&
                        contactscenery.slowdowntime > (time-idlestart)) {
                    velocity.x = (velocity.x > 0 ? 1 : -1)*idlespeed
                        *(contactscenery.slowdowntime-time+idlestart)
                        /contactscenery.slowdowntime;
                } else if (time-idlestart > contactscenery.slowdowntime) {
                    velocity.x = 0.0;
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

                if (contactscenery != null) {
                    if (contacthorizontal) {
                        decideLandState();
                    }
                }

                break;
            case EricState.WALLGRAB:
                if (animation != animations['wallgrab']) animation = animations['wallgrab'];

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

    static get values => [IDLE,WALKING,FALLING,AIRSCOOTING,WALLGRAB,WALLSLIDING,PHASING];

    final int value;

    const EricState._(this.value);
}
