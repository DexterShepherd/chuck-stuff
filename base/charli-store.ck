public class Charli {
  <<<"Initializing Charli Store">>>;
  static BPM @ _bpm;
  new BPM @=> _bpm;

  _bpm.quarter() => static dur quarter;
  _bpm.eigth() => static dur eigth;
  _bpm.sixteenth() => static dur sixteenth;

  0.5 => static float swing;
  
  static Event @ play;
  static Event @ stop;
  new Event @=> play;
  new Event @=> stop;
  
  fun static void bpm(BPM b) {
    <<<"Changing Global BPM ref">>>;
    b @=> _bpm;
    _bpm.quarter() => quarter;
    _bpm.eigth() => eigth;
    _bpm.sixteenth() => sixteenth;
  }

  fun static void tempo(int tempo) {
    <<<"Changing Global Tempo">>>;
    _bpm.set(tempo);
    _bpm.quarter() => quarter;
    _bpm.eigth() => eigth;
    _bpm.sixteenth() => sixteenth;
  }
}
