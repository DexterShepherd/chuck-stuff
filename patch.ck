public class Patch extends CharliPatch {
  setDefaults();

  Push p;
  p.debug();

  fun void play() {
    while(1) {
      p.control["play"] => now;
    }
  }
}
