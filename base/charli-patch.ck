public class CharliPatch {
  <<<"Initializing Base Patch">>>;
  Gain master => Gain base => dac;
  master => WvOut masterRecorder => blackhole;

  Scale scale;
  BPM bpm;

  Event stopEvent;

  0 => int numTracks;
  CharliTrack track[numTracks];


  fun void setDefaults() {
    tracks(16);
  }

  fun void tracks(int n) {
    n => numTracks;
    numTracks => track.size;
    for( 0 => int i; i < numTracks; i++ ) {
      CharliTrack t @=> track[i];
      track[i] => master;
    }
  }

  fun void stop() {
    stopEvent.broadcast();
  }
}
