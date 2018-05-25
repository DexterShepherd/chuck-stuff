public class PushGridEvent extends Event {
  int x;
  int y;
  int velocity;

  // 0: Off
  // 1: On
  // 2: aftertouch
  -1 => int type;
}
