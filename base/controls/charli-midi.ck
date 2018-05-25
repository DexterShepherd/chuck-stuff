public class CharliMidi {
  int port;
  0 => int connected;
  0 => int DEBUG;

  MidiIn in;
  MidiMsg msg;

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


  fun void poll() {
    while(1) {
      in => now;
      while(in.recv(msg)) {
        handleMessage(msg);
      }
    }
  }

  fun int handleMessage(MidiMsg m) {
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
