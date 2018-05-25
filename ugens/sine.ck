public class Sine extends CharliMonoSynth {
  SinOsc osc => env;

  fun void freq(float f) {
    f => osc.freq;
  }
}
