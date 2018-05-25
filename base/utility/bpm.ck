public class BPM {
  124 => int bpm;
  bpm / 60 => float bps;
  1 / bps => float spb;
  spb * 1000 => float mpb;


  fun void set(int b) {
    b => bpm;
    bpm / 60 => bps;
    1 / bps => spb;
    spb * 1000 => mpb;
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
