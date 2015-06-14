import 'dart:async';
import 'dart:html';

import 'animation.dart';

class Assets {
    static Map<String,Anim> animations = new Map();
    static Map<String,AudioElement> audio = new Map();
    static Map<String,ImageElement> images = new Map();

    static Future<Anim> buildAnimation(String path, int width, int height, [int maxframes]) {
        ImageElement spritesheet = getImage(path);
        images[path] = spritesheet;

        return spritesheet.onLoad.first.then((e) {
            Anim animation;
            if (maxframes != null) {
                animation = new Anim(spritesheet, width, height, maxframes);
            } else {
                animation = new Anim(spritesheet, width, height);
            }
            animations[path] = animation;
            return animation;
        });
    }

    static AudioElement getAudio(String path) {
        AudioElement ae = audio[path];
        if (ae == null) {
            ae = new AudioElement(src: path);
            audio[path] = ae;
        }
        return ae;
    }

    static ImageElement getImage(String path) {
        ImageElement ie = images[path];
        if (ie == null) {
            ie = new ImageElement(src: path);
            images[path] = ie;
        }
        return ie;
    }
}
