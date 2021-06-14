// SparkFun Thing Hanger

$fn=20;
extruder_width = 0.4;
wall_thickness = 2*extruder_width;

use <../parts/pegs.scad>

// SparkFunThing = [55.37, 25.91, wall_thickness*2];
SparkFunThing = [55.37, 26.51, wall_thickness*2];

translate([0, wall_thickness +0.3, wall_thickness*2]) {
  manyPegs(locations=SparkFunThing_locations(), sizes=SparkFunThing_sizes());
}

// Want to add short walls on just the Y
ph=3+2.79;
difference() {
  cube(SparkFunThing + [0, wall_thickness*2, wall_thickness*2 + ph]);

  translate([-1, wall_thickness, wall_thickness*2]) {
    cube(SparkFunThing + [2,0,ph+1]);
  }
}

sp=[
 [1.5,       wall_thickness,       ph + 1.71 + wall_thickness],
 [1.5,       26.51+wall_thickness, ph + 1.71 + wall_thickness],
 [55.37-1.5, 26.51+wall_thickness, ph + 1.71 + wall_thickness],
 [55.37-1.5, wall_thickness,       ph + 1.71 + wall_thickness],
];
for (l = sp) {
  translate(l) {
    rotate([0,90,0])
      cylinder(r=wall_thickness, h=3, center=true);
  }
}
