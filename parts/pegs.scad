
// Basic stand-off peg.  Defaults for a feather.
module peg(h1=5, r1=1.22, r2=2.57) {
  h2=r1*2;
  translate([-r2,-r2,0]) cube([r2*2, r2*2, h1]);
  cylinder(r=r1,h=h1+h2/2);
  translate([0, 0, h1+h2/2]) sphere(r=r1);
}

// Place pegs
module manyPegs(locations=[], sizes) {
  // If sizes is undef, then make array of default sizes same length as locations.
  sizes = sizes==undef ? [for(i=locations) [5, 1.22, 2.57] ] : sizes;

  for( idx = [0 : len(locations)-1]) {
    translate(locations[idx]) {
      h=sizes[idx][0];
      r1=sizes[idx][1];
      r2=sizes[idx][2];
      peg(h1=h, r1=r1, r2=r2);
    }
  }
}

// Layouts for boards I use:

function featherTriWing_locations(edgeToPegCenter=2.57) =  [
  [edgeToPegCenter, edgeToPegCenter, 0],
  [71-edgeToPegCenter, edgeToPegCenter, 0],
  [71-edgeToPegCenter, 51-edgeToPegCenter, 0],
  [edgeToPegCenter, 51-edgeToPegCenter, 0],
];
function featherTriWing_sizes(h=5, edgeToPegCenter=2.57) =  [
  for (i=[0:3]) [h, 1.22, edgeToPegCenter]
];

// Huzzah ESP8266 has two differnet peg sizes and locations.
// two are 1.91mm from edgeToCenter.
function featherHuzzahESP8266_locations() = [
  [2.57, 2.57, 0],
  [23-2.57, 2.57, 0],
  [23-1.91, 51-2.57, 0],
  [1.91, 51-2.57, 0],
];
// two are 2.29mm wide.(r=1.145)
function featherHuzzahESP8266_sizes(h=5) = [
  [h, 1.22, 2.57],
  [h, 1.22, 2.57],
  [h, 1.145, 1.91],
  [h, 1.145, 1.91],
];

// Things have a *lot* of overhang on the X-axis.
function SparkFunThing_locations(edgeToPegCenter=2.79) = [
  [12.06, edgeToPegCenter, 0],
  [12.06, 20.32+edgeToPegCenter, 0],
  [31.75+12.06, 20.32+edgeToPegCenter, 0],
  [31.75+12.06, edgeToPegCenter, 0],
];

function SparkFunThing_sizes(h=3) = [
  for (i=[0:3]) [h, 1.5, 2.79]
];

// ======================================================================
// manyPegs(locations=featherTriWing_locations());
manyPegs(locations=featherHuzzahESP8266_locations(), sizes=featherHuzzahESP8266_sizes());
