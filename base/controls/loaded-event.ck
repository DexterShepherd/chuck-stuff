public class LoadedEvent extends Event {
  time sentAt;
  int type; // 0 - noteoff
            // 1 - noteon
  float freq;
  int note;
  int index;

  Event @ off;

  1.0 => float vel;
}
