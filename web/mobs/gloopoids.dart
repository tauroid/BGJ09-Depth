import '../animation.dart';
import '../assets.dart';
import '../collisionshapes.dart';
import '../events.dart';
import '../mob.dart';

class Gloopoid extends Mob {
    int powerlevel;

    bool exploded = false;

    Anim idle;
    Anim explosion;

    Gloopoid() {
        animation = idle;
        collisionShape = new Box(12.0,12.0);
        active = false;
    }

    void explode() {
        if (!exploded) {
            animation = explosion;
            animation.play(false);
            exploded = true;
        }
    }
}

class RedGloopoid extends Gloopoid {
    RedGloopoid() {
        Assets.buildAnimation("/assets/huemanatee/animations/gloopoids/blob_red_idle.png",24,24)
            .then((Anim anim) {
                idle = anim;
                animation = idle;
                print('gloop ready');
            });
        Assets.buildAnimation("/assets/huemanatee/animations/gloopoids/blob_red_explode.png",24,24)
            .then((Anim anim) => explosion = anim);

        this.powerlevel = 1;
    }
}
