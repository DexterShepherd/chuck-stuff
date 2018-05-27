public class BPM {
  100 => int bpm;
  bpm / 60.0 => float bps;
  1 / bps => float spb;
  spb * 1000.0 => float mpb;


  fun void set(int b) {
    b => bpm;
    bpm / 60.0 => bps;
    1.0 / bps => spb;
    spb * 1000.0 => mpb;
  }

  fun dur bar() {
    return quarter() * 4;
  }

  fun dur half() {
    return quarter() * 2;
  }

  fun dur quarter() {
    return mpb::ms;
  }

  fun dur eigth() {
    return quarter() / 2;
  }

  fun dur sixteenth() {
    return quarter() / 4;
  }

  fun dur thirtysecond() {
    return quarter() / 8;
  }
}
