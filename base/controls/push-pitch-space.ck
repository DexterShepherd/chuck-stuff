public class PushPitchSpace {
  Push @ push;
  LoadedEvent @ trigger;
  50 => int offset;

  fun void init(Push p, LoadedEvent n) {
    p @=> push;
    n @=> trigger;
    spork ~ poll();
  }

  fun void poll() {
    while(1) {
      push.button => now;
      Std.mtof(
        push.button.x * 3 +
        push.button.y * 4 +
        offset
      ) => trigger.freq;
      push.button.type => trigger.type;
      push.button.index => trigger.index;

      trigger.broadcast();
    }
  }
}
