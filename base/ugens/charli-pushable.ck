public class Pushable extends Chubgraph {
  Gain master => outlet;
  Param @ p[0];

  LoadedEvent trigger; 
  spork ~ poll();

  fun void play(LoadedEvent e) {
    <<<"Superclass method #play called for Pushable">>>;
    <<<"Implement #play in child">>>;
  }

  fun void poll() {
    while(1) {
      trigger => now;
      spork ~ play(trigger);
    }
  }

  fun Param param(float val, string id) {
    Param par;
    par.init(val, id);
    p << par;
    par @=> p[id];
    return par;
  }
}
