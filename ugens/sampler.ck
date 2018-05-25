public class Sampler extends Chubgraph {
  SndBuf s => outlet;
  Pattern pattern;
  pattern.trigger @=> Event trigger;

  spork ~ pollForTrigger();

  string path;

  0 => int startPos;

  fun void read(string filepath) {
    parsePath(filepath) => path;
    s.read(path);
  }

  fun void play() {
    startPos => s.pos;
  }

  fun void pollForTrigger() {
    while(1) {
      trigger => now;
      play();
    }
  }

  fun string parsePath(string path) {
    path.find("__cloud__") => int cloud;

    if ( cloud != -1 ) {
      path.replace(cloud, 9, "/Users/dextershepherd/Dropbox/samples");
    }

    return path;
  }

  fun void rate(float r) {
    r => s.rate;
  }
}
