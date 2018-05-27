public class CharliMidi {
  int port;
  string portName;

  0 => int connected;
  0 => int outConnected;
  0 => int DEBUG;

  MidiIn in;
  MidiMsg inMsg;
  MidiOut out;
  MidiMsg outMsg;

  fun void open(string p) {
    p => portName;
    if ( in.open(portName) ) {
      1 => connected;
    } else {
      <<<"Error opening Midi Device on port " + portName>>>;
    }

    if ( out.open(portName) ) {
      1 => outConnected;
    } else {
      <<<"Unable to open Midi Out">>>;
    }

    logInfo();

    spork ~ poll();
    spork ~ poll();
  }


  fun void open(int p ) {
    p => port;
    if ( in.open(port) ) {
      1 => connected;
    } else {
      <<<"Error opening Midi Device on port " + port>>>;
    }

    logInfo();

    spork ~ poll();
  }

  fun void send(int d1, int d2, int d3) {
    d1 => outMsg.data1;
    d2 => outMsg.data2;
    d3 => outMsg.data3;
    out.send(outMsg);
  }

  fun void poll() {
    while(1) {
      in => now;
      while(in.recv(inMsg)) {
        handleMessage(inMsg);
      }
    }
  }

  fun void handleMessage(MidiMsg m) {
    if ( DEBUG ) {
      logMsg(m);
    }
    <<<"Implement #handleMessage in controller class">>>;
  }

  fun void logMsg(MidiMsg m) {
      <<<"-----", "">>>;
      <<<"1:", m.data1, "2:", m.data2, "3:", m.data3 >>>;
      <<<"-----", "">>>;
  }

  fun void logInfo() {
    if ( connected ) {
      <<<"=====", "">>>;
      <<<"Midi Device: " + in.name() + IO.newline() + "Midi Port: " + port, "">>>;
      <<<"=====", "">>>;
    }
  }

  fun void debug() {
    <<<"Setting debug">>>;
    1 => DEBUG;
  }
}
