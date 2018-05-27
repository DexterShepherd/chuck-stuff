//   pattern key
//   ----------------
//   1 = noteOn
//   - = rest
//   [ = double speed
//   ] = half speed

public class Pattern {
  Event trigger;
  0 => int pos;
  0 => int playing;
  0.5 => float swing;
  0 => int division;
  0 => int shoulAdvanceTime;
  0 => int swingCounter;
  string pattern;
  float speed; 

  fun Event init(string p, float s) {
    p => pattern;
    s => speed;
    return trigger;
  }

  fun Event init(string p, dur s) {
    p => pattern;
    s / ms => speed;
    return trigger;
  }

  fun Event init(string p, float s, float sw) {
    p => pattern;
    s => speed;
    sw => swing;
    return trigger;
  }

  fun Event init(string p, dur s, float sw) {
    p => pattern;
    s / ms => speed;
    sw => swing;
    return trigger;
  }

  fun void changePattern(string p) {
    p => pattern;
  }

  fun void changeSpeed(float s) {
    s => speed;
  }

  fun void start() {
    if ( !playing ) {
      1 => playing;
      spork ~ play();
    }
  }

  fun void pause() {
    0 => playing;
  }

  fun void stop() {
    0 => playing;
    0 => pos;
  }

  fun void play() {
    while(playing) {
      handleChar(pattern.charAt(pos));
      ( pos + 1 ) % pattern.length() => pos;
    }
  }

  fun void onset() {
    trigger.broadcast();
  }

  fun void advanceTime() {
    if ( division > 1 ) {
      if ( swingCounter ) {
        ((speed * 2) * swing)::ms => now;
        0 => swingCounter;
      } else {
        ((speed * 2) * ( 1 - swing ))::ms => now;
        1 => swingCounter;
      }
    } else {
      speed::ms => now;
    }
    0 => shoulAdvanceTime;
  }

  fun void handleChar(int c) {
    if ( c == 'x' ) {
      onset();
      1 => shoulAdvanceTime;
    } else if ( c == '-' ) {
      1 => shoulAdvanceTime;
    } else {
      "0123456789abcdef" => string probabilities;
      probabilities.find(c) => int chance;
      if ( chance != -1 ) {
        if ( Math.random2(0, 16) < chance ) {
          onset();
        }
        1 => shoulAdvanceTime;
      }
    }

    if ( c == '[' ) {
      speed * 0.5 => speed;
      division++;
    } else if ( c == ']' ) {
      speed * 2 => speed;
      division--;
    }

    if ( shoulAdvanceTime ) {
      advanceTime();
    }
  }
}
