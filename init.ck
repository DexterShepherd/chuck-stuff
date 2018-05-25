// require("base/manifest.ck")
// require("ugens/manifest.ck")
// require("patch.ck")

Patch patch;

spork ~patch.play();

patch.stopEvent => now;
