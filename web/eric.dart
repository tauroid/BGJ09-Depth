import 'animation.dart';
import 'assets.dart';
import 'events.dart';
import 'mob.dart';

class Eric extends Mob with Subscriber {
    Map<String,Animation> animations;

    Eric() {
        filters.add('keyboard');
        Assets.buildAnimation("/assets/huemanatee/animations/eric/manatee_idle.png", 24, 24)
            .then((anim) {
                anim.framedelayms = 500;
                animations['idle'] = anim;
                animation = anim;
            });
    }

    void onEvent(GameEvent event) {
    
    }
}
