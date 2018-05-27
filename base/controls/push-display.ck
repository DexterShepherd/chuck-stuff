// Largely pulled and adapted from work done by 
// Bruce Lott and Ness Morris
// github.com/nessss/push

public class PushDisplay {
  MidiOut @ out;
  MidiMsg displayMsg;

  string line[4];
  68 => int lineLen;


  fun void set(string lines[]) {
    spork ~ setDisplay(lines);
  }

  fun void setDisplay(string lines[]) {
    while( lines.size() < 4 ) {
      lines << "";
    }
    clearDisplay();
    for( 0 => int i; i < 4; i++ ) {
      setLine(i, lines[i]);
    }
    updateDisplay();
  }

  fun void setLine(int row, string d){
    d => string data;
    if( row >= 0 && row < 4){
      if( data.length() <= 68 ) {
        while(data.length() < 68) {
          data + " " => data;
        }
        data => line[row];
      } else {
        <<<"Cannot write line longer that 68 chars: " + data.length()>>>;
      }
    } else {
     <<<"row out of range: " + row>>>;
    }
  }

  fun void clearDisplay(){
    for( 0=>int i; i < line.size(); i++ ){
      clearLine(i);
    }
  }

  fun void clearLine(int l){
    setLine(l, "");
    0xF0 => displayMsg.data1;
    0x47 => displayMsg.data2;
    0x7F => displayMsg.data3;
    out.send(displayMsg);
    0x15 => displayMsg.data1;
    0x1C + l => displayMsg.data2;
    0 => displayMsg.data3;
    out.send(displayMsg);
    0 => displayMsg.data1;
    0xF7 => displayMsg.data2;
    0 => displayMsg.data3;
    out.send(displayMsg);
  }

  fun void updateDisplay(){
    for( 0 => int i; i < line.size(); i++ ){
      updateLine(i);
    }
  }

  fun void updateLine(int l){
    if( l < 4 && l >= 0 ){
      0xF0 => displayMsg.data1;
      0x47 => displayMsg.data2;
      0x7F => displayMsg.data3;
      out.send(displayMsg);
      0x15 => displayMsg.data1;
      0x18 + l => displayMsg.data2;
      0 => displayMsg.data3;
      out.send(displayMsg);
      0x45 => displayMsg.data1;
      0 => displayMsg.data2;

      2 => int index;

      for ( 0 => int i; i < lineLen; i++ ) {
        if ( index == 0 ) {
          line[l].charAt(i) => displayMsg.data1;
        } else if ( index == 1 ) {
          line[l].charAt(i) => displayMsg.data2;
        } else {
          line[l].charAt(i) => displayMsg.data3;
          out.send(displayMsg);
        }
        ( index + 1 ) % 3 => index;
      }
      0xF7 => displayMsg.data2;
      0 => displayMsg.data3;
      out.send(displayMsg);
    } else {
      <<<"cannot update line " + l >>>;
    }
  }

  0 => int char;

  fun void cycleChars() {
    clearDisplay();
    " " => string test;
    test.setCharAt(0, char);
    <<<char>>>;
    char++;
    setLine(0, test);
    updateDisplay();
    300::ms => now;
  }
}


// interesting chars

// 0  - arrow up
// 1  - arrow down
// 2  - 3 horizontal lines ( hamburger )
// 3  - set square right ( vertical line with dash center right )
// 4  - set square left ( vertical line with dash center left )
// 5  - 2 bold vertical lines
// 6  - two dashes ( -- )
// 7  - folder icon
// 8  - 2 vertical dashes
// 9  - top left square
// 24 - %
// 29 - solid block
// 30 - arrow left 
