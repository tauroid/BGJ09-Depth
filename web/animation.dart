class Animation {
    ImageElement spritesheet;    
    int rows, columns, width, height;
    int starttime = new DateTime.now().millisecondsSinceEpoch;
    int maxframes;
    int lastframe = 0;

    bool timeperframe = false;
    int framedelayms = 100;
    List<int> _framedelaysms;
    int totaltime;

    bool playing = true;
    int pausetime;
    int start, end;
    bool repeat = true;
    bool flipped = false;

    int scaling = 4;

    Animation(ImageElement spritesheet, int width, int height, [int maxframes])
            : this.spritesheet = spritesheet,
              this.width = width,
              this.height = height,
              this.start = 0 { 

        rows = spritesheet.height/height;
        columns = spritesheet.width/width;
        if (maxframes == null) this.maxframes = rows*columns;
        this.end = this.maxframes-1;
    }

    void set framedelaysms(List<int> fdm) {
        _framedelaysms = fdm;
        totaltime = 0;
        _framedelaysms.forEach((int time) => totaltime += time);
    }

    void play([bool repeat = true]) {
        playing = true;
        this.repeat = repeat;
        starttime = new DateTime.now().millisecondsSinceEpoch - pausetime;
        pausetime = 0;
    }

    void playRange(int start, int end, [bool repeat = true]) {
        this.start = start; this.end = end;
        play(repeat);
    }

    void stop() {
        playing = false;
    }

    void pause() {
        playing = false;
        pausetime = new DateTime.now().millisecondsSinceEpoch - starttime;
    }

    int getFrame() {
        if (!playing) return lastframe;

        int time = new DateTime.now().millisecondsSinceEpoch - starttime;
        if (!timeperframe) {
            if (!repeat && time > maxframes*framedelayms) {
                playing = false;
                lastframe = maxframes-1;
            } else {
                lastframe = (time/framedelayms).floor() % maxframes;
            }
        } else {
            if (!repeat && time > totaltime) {
                playing = false;
                lastframe = maxframes-1;
            } else {
                int frametime = 0;
                time = time % totaltime;
                for (int i = 0; i < _framedelaysms.length; ++i) {
                    frametime += _framedelaysms[i];
                    if (frametime > time) break;
                }
                lastframe = i-1;
            }
        }
        return lastframe;
    }
}
