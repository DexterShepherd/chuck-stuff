public class Scale {
  0 => int root;
  "minor" => string type;
  1 => int octaves;
  50 => int offset;

  [0, 2, 4, 5, 7, 9, 11] @=> static int major[];
  [0, 2, 3, 5, 7, 8, 10] @=> static int minor[];
  [0, 2, 4, 7, 9] @=> static int majorPent[];
  [0, 2, 3, 7, 8] @=> static int minorPent[];

  int notes[0];
  calculateNotes();

  fun void calculateNotes() {
    baseNotesForScaleType() @=> int baseNotes[];
    baseNotes.size() * octaves => notes.size;
    for(0 => int octave; octave < octaves; octave++) {
      for(0 => int note; note < baseNotes.size(); note++) {
        baseNotes[note] + (octave * 12) + offset => notes[note + ( octave * baseNotes.size() )];
      }
    }
  }


  fun int randomNote() {
    notes[Math.random2(0, notes.size() - 1)] => int choice;
    return choice;
  }

  // TODO: refactor to use either assoc arrays or string parsing
  fun int[] baseNotesForScaleType() {
    if ( type == "major" ) {
      return major;
    } else if ( type == "minor" ) {
      return minor;
    } else if ( type == "major-pent" ) {
      return majorPent;
    } else if ( type == "minor-pent" ) {
      return minorPent;
    }
    return minor;
  }
}
