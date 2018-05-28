class Voice extends Chubgraph {
  SinOsc s => ADSR e => outlet;
  
  0.5 => s.gain;
  0 => int busy;
  Event @ stop;

  e.set(600::ms, 0::ms, 1.0, 2000::ms);
  
  fun void play(float f, Event st) {
    1 => busy;
    f => s.freq;
    st @=> stop;
    spork ~ playNote();
  }

  fun void playNote() {
    e.keyOn();
    stop => now;
    e.keyOff();
    2000::ms => now;
    0 => busy;
  }
}

public class PushSynth extends Pushable {
  10 => int voices;

  Voice voice[voices];

  for ( 0 => int i; i < voices; i++ ) {
    voice[i] => master;
  }

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

