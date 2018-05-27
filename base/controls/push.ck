// require('push-grid.ck')
// require('push-knob.ck')
// require('push-control.ck')
// require('push-light.ck')
// require('push-display.ck')

public class Push extends CharliMidi {
  open("Ableton Push User Port");

  PushLight light;
  PushDisplay display;

  out @=> light.out;
  out @=> display.out;


  PushGridEvent button;
  PushKnobEvent knob;

  36 => int gridOffset;
  0 => int numberControl;
  1 => int lightGridOnPress;

  PushControlEvent control[0];

  string controlEventMapping[120];
  for( 0 => int i; i < controlEventMapping.size(); i++ ) {
    "unset" => controlEventMapping[i];
  }

  now => time lastEvent;

  initializeControlEvents();
  light.allControlLights();

  welcome();

  // TODO : implement grid aftertouch
  fun void handleMessage(MidiMsg m) {
    if ( isKnobEvent(m) ) {
      handleKnobEvent(m);
    } else if ( isGridEvent(m) ) {
      handleGridEvent(m);
    } else if ( isKnobTouchEvent(m) ) {
      // TODO : implement knob touch
    } else  {
      handleControlEvent(m);
    }
  }

  fun int isGridEvent(MidiMsg m) {
    return (( m.data1 == 144 || m.data1 == 128 ) &&
            m.data2 >= gridOffset &&
            m.data2 < gridOffset + 64);
  }

  fun int isKnobTouchEvent(MidiMsg m) {
    return ( m.data1 == 144 && m.data2 < 11 );
  }

  fun int isKnobEvent(MidiMsg m) {
    return (m.data1 == 176 &&
           ((m.data2 > 70 && m.data2 < 80) ||
           (m.data2 == 14 || m.data2 == 15 )));
  }

  fun int handleKnobEvent(MidiMsg m) {
    m.data2 - 71 => knob.id;  
    if ( m.data3 < 64 ) {
      m.data3 => knob.change;
    } else {
      ( 128 - m.data3 ) * -1 => knob.change;
    }
    knob.broadcast();
    return 1;
  }

  fun int handleGridEvent(MidiMsg m) {
    m.data2 - gridOffset => int index;
    index / 8 => button.x;
    index % 8 => button.y;
    m.data3 => button.velocity;

    index => button.index;

    if ( m.data1 == 144 ) {
      1 => button.type;

      if ( lightGridOnPress ) {
        light.set(index);
      }

      button.broadcast();
    } else if ( m.data1 == 128 ) {
      0 => button.type;

      if ( lightGridOnPress ) {
        light.off(index);
      }

      spork ~ noteOff(index);
      /* button.broadcast(); */
    } else if ( m.data1 == 160 ) {
      2 => button.type;
    }

    return 1;
  }

  
  // hack to handle stuck notes
  fun void noteOff(int index) {
    for(0 => int i; i < 2; i++) {
      1::ms => now;
      0 => button.type;
      index => button.index;
      button.broadcast();
    }
  }

  fun int handleControlEvent(MidiMsg m) {
    if ( m.data1 == 176 ) {
      control[controlEventMapping[m.data2]].broadcast();
    }
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
    createAndAddEvent(111, "browse");
    createAndAddEvent(112, "track");
    createAndAddEvent(113, "clip");
    createAndAddEvent(114, "volume");
    createAndAddEvent(115, "pan-and-send");
  }

  fun void createAndAddEvent(int note, string id) {
    new PushControlEvent @=> control[id];
    id => control[id].id;
    note => control[id].note;

    id => controlEventMapping[note];
    note => light.controlIndexMapping[id];
    light.controlIndex << note;
  }

  fun void welcome() {
    light.clear();

    display.set([
      "ChucK => PUSH",
      "Dexter Shepherd",
      "2018"
    ]);

    for(0 => int i; i < 32; i++) {
      Math.random2(0, 64) => int index;
      light.set(index);
      10::ms => now;
    }

    light.clear();
  }


}
