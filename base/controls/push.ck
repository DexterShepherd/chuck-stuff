// require('push-grid.ck')
// require('push-knob.ck')
// require('push-control.ck')

public class Push extends CharliMidi {
  // TODO : Something to find the write midi port based on name
  open(1);

  PushGridEvent button;
  PushKnobEvent knob;

  PushControlEvent control[0];
  string controlEventMapping[200];

  initializeControlEvents();


  fun int handleMessage(MidiMsg m) {
    /* logMsg(m); */
    if ( isKnobEvent(m) ) {
      handleKnobEvent(m);
    }
    if ( isGridEvent(m) ) {
      return handleGridEvent(m);
    } 

    handleControlEvent(m);
  }

  fun int isGridEvent(MidiMsg m) {
    return (m.data1 != 176 && m.data2 >= 36 && m.data2 < 100);
  }

  fun int isKnobEvent(MidiMsg m) {
    return(m.data1 == 176 && msg.data2 >= 71 && m.data2 < 80);
  }

  fun int handleKnobEvent(MidiMsg m) {
    for( 0 => int i; i < 8; i++ ) {
      if ( m.data2 == i + 71 ) {
        i => knob.id;  
        if ( m.data3 < 64 ) {
          m.data3 => knob.change;
        } else {
          ( 128 - msg.data3 ) * -1 => knob.change;
        }
        knob.broadcast();
        return 1;
      }
    }
  }

  // TODO: this loop isn't needed
  fun int handleGridEvent(MidiMsg m) {
    for ( 0 => int x; x < 8; x++ ) {
      for ( 0 => int y; y < 8; y++ ) {
        x + ( y * 8 ) + 36 => int index;
        if ( m.data2 == index ) {
          x => button.x;
          y => button.y;
          m.data3 => button.velocity;
          if ( m.data1 == 144 ) {
            1 => button.type;
          } else if ( m.data1 == 128 ) {
            0 => button.type;
          } else if ( m.data1 == 160 ) {
            2 => button.type;
          }
          button.broadcast();
          return 1;
        }
      }
    }
  }

  fun int handleControlEvent(MidiMsg m) {
    <<<controlEventMapping[m.data2]>>>;
    control[controlEventMapping[m.data2]].broadcast();
  }

  fun int initializeControlEvents() {
    createAndAddEvent(85, "play");
    createAndAddEvent(86, "record");
    createAndAddEvent(87, "new");
    createAndAddEvent(88, "duplicate");
    createAndAddEvent(89, "automation");
    createAndAddEvent(90, "fixed");

    createAndAddEvent(116, "quantize");
    createAndAddEvent(117, "double");
    createAndAddEvent(118, "delete");
    createAndAddEvent(119, "undo");

    createAndAddEvent(9, "metronome");
    createAndAddEvent(3, "tap");

    createAndAddEvent(36, "scene-0");
    createAndAddEvent(37, "scene-1");
    createAndAddEvent(38, "scene-2");
    createAndAddEvent(39, "scene-3");
    createAndAddEvent(40, "scene-4");
    createAndAddEvent(41, "scene-5");
    createAndAddEvent(42, "scene-6");
    createAndAddEvent(43, "scene-7");

    createAndAddEvent(28, "master");
    createAndAddEvent(29, "stop");

    createAndAddEvent(46, "top");
    createAndAddEvent(45, "right");
    createAndAddEvent(47, "down");
    createAndAddEvent(44, "left");

    createAndAddEvent(48, "select");
    createAndAddEvent(49, "shift");
    createAndAddEvent(50, "note");
    createAndAddEvent(51, "session");
    createAndAddEvent(52, "effect");
    createAndAddEvent(53, "track");

    createAndAddEvent(54, "oct-up");
    createAndAddEvent(55, "oct-down");
    createAndAddEvent(56, "repeat");
    createAndAddEvent(58, "accent");
    createAndAddEvent(59, "select");
    createAndAddEvent(60, "user");
    createAndAddEvent(61, "mute");
    createAndAddEvent(62, "next");
    createAndAddEvent(63, "prev");

    createAndAddEvent(110, "device");
    createAndAddEvent(110, "browse");
    createAndAddEvent(110, "track");
    createAndAddEvent(110, "clip");
    createAndAddEvent(110, "volume");
    createAndAddEvent(110, "pan-and-send");
  }

  fun void createAndAddEvent(int note, string id) {
    new PushControlEvent @=> control[id];
    id => control[id].id;
    note => control[id].note;
    id => controlEventMapping[note];
  }
}
