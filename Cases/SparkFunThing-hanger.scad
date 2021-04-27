// SparkFun Thing Hanger

/*
    *        *
    |        |
    +--------+
*/
$fn=20;
extruder_width = 0.4;
wall_thickness = 2*extruder_width;

use <../parts/hanger_peg.scad>;

// hanger_peg(h=5);

peg_locations = [
  [0, 0, 0],
  [0, 20.4, 0],
  [31.83, 20.4, 0],
  [31.83, 0, 0],
];

for(p = peg_locations) {
  translate(p) {
    rotate([0, 0, 90]) {
      hanger_peg(h=9, d=3.3);
    }
  }
}
translate([-1.7, -1.7, -(9/2 + wall_thickness)]) {
  cube([35.3, 24.3, wall_thickness]);
}
