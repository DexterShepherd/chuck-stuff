public class PushPitchSpace {
  Push @ push;
  LoadedEvent @ trigger;
  50 => int offset;

  fun void init(Push p, LoadedEvent n) {
    p @=> push;
    n @=> trigger;

    0 => push.lightGridOnPress;
    lightGrid();

    spork ~ poll();
  }

  fun int note(int x, int y) {
    return x * 3 + y * 4 + offset;
  }

  fun void lightGrid() {
    for( 0 => int i; i < 8; i++ ) {
      for( 0 => int j; j < 8; j++ ) {
        note(i, j) % 12 => int index;
        push.light.allBright[index % push.light.allBright.size()] => int c;
        push.light.set(i, j, c);
      }
    }
  }

  fun void poll() {
    while(1) {
      push.button => now;
      Std.mtof(note(push.button.x, push.button.y)) => trigger.freq;
      note(push.button.x, push.button.y) => trigger.note;
      push.button.type => trigger.type;
      push.button.index => trigger.index;

      trigger.broadcast();
    }
  }
}
