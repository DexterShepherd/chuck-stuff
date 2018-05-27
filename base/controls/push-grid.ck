public class PushGridEvent extends Event {
  time sentAt;
  int x;
  int y;
  int index;
  int velocity;

  // 0: Off
  // 1: On
  // 2: aftertouch
  -1 => int type;
}
