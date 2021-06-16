echo(version=version());
use <MCAD/boxes.scad>
use <../parts/pegs.scad>

// Values are in millimeters

$fs=0.5;
////////////////////////////

extruder_width = 0.4;
wall_thickness = 2*extruder_width;

// full box size
inside = [58, 50, 35];
wall_set = [for(i=[0:3]) wall_thickness*2];
outside = inside + wall_set;


module base_case() {
  difference() {
    roundedBox(outside, 4, false );
    roundedBox(inside, 4, false );
  }
}

module case_bot() {
  difference() {
    base_case();
    lift = outside[2] * 0.85;
    translate([0, 0, lift]) cube(outside+[1,1,0], center=true);
  }
  translate([-21, -25, -inside[2]/2]) {
    manyPegs(ProtoBoard2_locations(), ProtoBoard2_sizes(h=4));
  }
}

module case_top() {
  difference() {
    base_case();
    lift = outside[2] * (1 - 0.85);
    translate([0, 0, -lift]) cube(outside+[1,1,0], center=true);
  }

  lip_edge = 5;
  translate([0,0, (inside[2]/2) - lip_edge ]) {
    lipped = [inside[0], inside[1], lip_edge];
    difference() {
      roundedBox(lipped, 4, true);
      roundedBox(lipped - wall_set + [0,0,4], 4, true);
    }
  }
}

case_bot();
case_top();

// vim: set ai et sw=2 ts=2 :
