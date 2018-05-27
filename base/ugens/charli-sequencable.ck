public class CharliSequencable extends Chubgraph {
  Gain master => outlet;

  Pattern _pattern;
  _pattern.trigger @=> Event trigger;

  spork ~pollForTrigger();

  fun void pattern(string p) {
    BPM b;
    b.set(150);
    Charli.tempo(151);
    _pattern.init(p, Charli.quarter, Charli.swing);
  }



  fun void pollForTrigger() {
    while(1) {
      trigger => now;
      play();
    }
  }

  fun void play() {
    <<<"Implement #play in child">>>;
  }
}
