class Voice extends Chubgraph {
  0 => int busy;
  3 => int oscCount;

  Blit osc[oscCount];
  SinOsc sub => ADSR e => LPF lowPass => outlet;

  float freqs[oscCount];

  0.1 => sub.gain;

  2.0 => float keyFollow;

  500 => lowPass.freq;

  50::ms => dur attack;
  0::ms => dur decay;
  1.0 => float sustain;
  300::ms => dur release;

  e.set(attack, decay, sustain, release);

  for( 0 => int i; i < oscCount; i++ ) {
    osc[i] => e;
    spork ~ tick(i);
  }

  0.01 => float spread;

  Event @ stop;

  fun void setFreq(float f) {
    for( 0 => int i; i < oscCount; i++ ) {
      f * keyFollow => lowPass.freq;
      f => freqs[i] => osc[i].freq;
      f / 2 => sub.freq;
    }
  }
  
  fun void play(float f, Event st) {
    1 => busy;
    setFreq(f);
    st @=> stop;
    spork ~ playNote();
  }

  fun void playNote() {
    e.keyOn();
    stop => now;
    e.keyOff();
    release => now;
    0 => busy;
  }

  fun void tick(int index) {
    SinOsc lfo => blackhole;
    Math.random2f(0.01, 0.1) => lfo.freq;
    spread * 20 => lfo.gain;
    while(1) {
      lfo.last() + freqs[index] => osc[index].freq;
      1::samp => now;
    }
  }
}

public class Poly extends Pushable {
  10 => int voices;

  Voice voice[voices];

  for ( 0 => int i; i < voices; i++ ) {
    voice[i] => master;
  }

  0.5 => master.gain;

  Event noteOff[128];

  fun int allocate() {
    for(0 => int i; i < voices; i++) {
      if ( !voice[i].busy ) {
        return i;
      }
    }
  }

  fun void poll() {
    while(1) {
      trigger => now;
      if ( trigger.type == 1 ) {
        allocate() => int index;
        voice[index].play(trigger.freq, noteOff[trigger.index]);
      } else if ( trigger.type == 0 ) {
        noteOff[trigger.index].broadcast();
      }
    }
  }
}

