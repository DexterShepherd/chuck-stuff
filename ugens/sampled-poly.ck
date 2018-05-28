class Voice extends Chubgraph {
  5 => int numSamples;
  SndBuf s[numSamples];
  ADSR e => outlet;

  "./samples/celesta.wav" => s[0].read;
  "./samples/e-piano.wav" => s[1].read;
  "./samples/recorder.wav" => s[2].read;
  "./samples/flute.wav" => s[3].read;
  "./samples/duduk.wav" => s[4].read;
  
  for ( 0 => int i; i < numSamples; i++ ) {
    s[i] => e;
    1 => s[i].loop;
    0.5 => s[i].gain;
  }

  0 => int busy;
  Event @ stop;

  e.set(100::ms, 0::ms, 1.0, 800::ms);
  
  fun void play(int n, Event st) {
    1 => busy;

    for ( 0 => int i; i < numSamples; i++ ) {
      rateForNote(n) => s[i].rate;
      if ( maybe ) {
        rateForNote(n) / 2 => s[i].rate;
      }
    }

    st @=> stop;
    spork ~ playNote();
  }

  fun void playNote() {
    e.keyOn();
    for( 0 => int i; i < 3; i++ ) {
      0 => s[Math.random2(0, numSamples - 1)].pos;
    }
    stop => now;
    e.keyOff();
    2000::ms => now;
    0 => busy;
  }

  70 => int root;

  fun float rateForNote(int n) {
    n - root => float diff;
    diff / 12 => float semi;
    return ( Math.pow(2, semi) );
  }
}

public class SampledPolySynth extends Pushable {
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
        voice[index].play(trigger.note, noteOff[trigger.index]);
      } else if ( trigger.type == 0 ) {
        noteOff[trigger.index].broadcast();
      }
    }
  }
}

