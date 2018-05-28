public class Patch extends CharliPatch {
  setDefaults();
  Push p;

  PushPitchSpace pitchSpace;

  SampledPolySynth synth => track[0];
  pitchSpace.init(p, synth.trigger);

  fun void play() {
    while(1) {
      100::ms => now;
    }
  }
}
