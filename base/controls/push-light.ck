// Color values and Palette by adamj
// https://forum.ableton.com/viewtopic.php?f=55&t=192920

public class PushLight {
  int colors[0];
  36 => int gridOffset;

  int controlIndexMapping[120];
  int controlIndex[0];

  for( 0 => int i; i < controlIndexMapping.size(); i++ ) {
    -1 => controlIndexMapping[i];
  }

  MidiOut @ out;
  MidiMsg lightMsg;

  0 => colors["black"];

  3 => colors["whitebright"];
  1 => colors["whitedim"];

  120 => colors["redbright"];
  7 => colors["reddim"];

  60 => colors["orangebright"];
  10 => colors["orangedim"];

  13 => colors["yellowbright"];
  15 => colors["yellowdim"];

  21 => colors["greenbright"];
  23 => colors["greendim"];

  33 => colors["cyanbright"];
  35 => colors["cyandim"];

  33 => colors["bluebright"];
  35 => colors["bluedim"];

  49 => colors["indigobright"];
  51 => colors["indigodim"];

  53 => colors["violetbright"];
  55 => colors["violetdim"];


  fun void allControlLights() {
    for( 0 => int i; i < controlIndex.size(); i++ ) {
      spork ~ setControl(controlIndex[i], 1);
    }
  }
  fun void clear() {
    spork ~ setAllButtons("black");
  }

  fun void off(int index) {
    spork ~ setButton(index, "black");
  }

  fun void off(int x, int y) {
    spork ~ setButton(x, y, "black");
  }

  fun void set(int index) {
    spork ~ setButton(index, "whitebright");
  }

  fun void set(int index, string c) {
    spork ~ set(index, c);
  }

  fun void set(int x, int y) {
    spork ~ setButton(x, y, "whitebright");
  }

  fun void setAllButtons(string c) {
    for(0 => int i; i < 64; i++) {
      setButton(i, c);
    }
  }

  fun void setButton(int index, string c) {
    0x90 => lightMsg.data1;
    index + gridOffset => lightMsg.data2;
    colors[c] => lightMsg.data3;
    out.send(lightMsg);
  }

  fun void setButton(int x, int y, string c) {
    y + (x * 8) => int index;
    0x90 => lightMsg.data1;
    index + gridOffset => lightMsg.data2;
    colors[c] => lightMsg.data3;
    out.send(lightMsg);
  }

  fun void setControl(string c, int on) {
    176 => lightMsg.data1;
    controlIndexMapping[c] => lightMsg.data2;
    on * 127 => lightMsg.data3;
    out.send(lightMsg);
  }

  fun void setControl(int c, int on) {
    176 => lightMsg.data1;
    c => lightMsg.data2;
    on * 127 => lightMsg.data3;
    out.send(lightMsg);
  }
}
