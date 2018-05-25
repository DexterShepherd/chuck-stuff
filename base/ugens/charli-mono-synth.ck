public class CharliMonoSynth extends Chubgraph {
  ADSR env => outlet;

  0.7 => float amp;

  10::ms  => dur attack;
  0::ms   => dur decay;
  1.0     => float sustain;
  100::ms => dur release;

  setEnvWithState();


  fun void play(dur d) {
    spork ~ playOnce(d);
  }

  fun void playOnce(dur d) {
    env.keyOn();
    d => now;
    env.keyOff();
    release => now;
  }

  fun void setEnv(dur a, dur d, float s, dur r) {
    a => attack;
    d => decay;
    s => sustain;
    r => release;
    setEnvWithState();
  }

  fun void setEnvWithState() {
    env.set(attack, decay, sustain, release);
  }
}
