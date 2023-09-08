echo(version=version());
use <MCAD/boxes.scad>
use <../parts/usbMicroBPlug.scad>
use <../parts/pegs.scad>

// Values are in millimeters
//
// A box for a solderable breadboard

$fs=0.5;
////////////////////////////

extruder_width = 0.4;
wall_thickness = 3*extruder_width;

////////////////////////////

// Where to pop holes for USB connector.
// Each entry is [side, offset]
//  side: 0=left, 1=right, 2=front, 3=back
//  offset: [x,y,z] all from center of the side.
usb_holes=[
  [2, [-6.85, 0, 14.8-9]],
];

// full box size
inside = [63.7, 94, 35];
wall_set = [for(i=[0:3]) wall_thickness*2]; // do not change
outside = inside + wall_set; // do not change

// Where to split the top and bottom of the box. (as a percentage of the box height)
case_split = 0.85;

// How tall of a lip on the top to fit into the bottom. (in mm)
lip_height = 5;

// How deep of a well to leave in the bottom for the battery. (in mm)
bottom_well = 9;

////////////////////////////////////////////////////////

// Radius of the rounded corners
inside_r = 2;
outside_r = 4;

////////////////////////////////////////////////////////
// The general thing that will become the case.
module base_case() {
  difference() {
    roundedCube(outside, outside_r, false, true);
    roundedCube(inside, inside_r, false, true);
  }
}

// Hole puncher
// Moves the children to the correct place on a side of the box.
module hole_offset(side=0, where=[0,0,0]) {
  // Side tells us which x|y to pull from the outside of the box.
  // And which x|y to use from offset.
  loc = side == 0 ?
      [outside[0]/2, where[1], where[2]]
    : side == 1 ?
      [-outside[0]/2, where[1], where[2]]
    : side == 2 ?
      [where[0], outside[1]/2, where[2]]
    : side == 3 ?
      [where[0], -outside[1]/2, where[2]]
    : [0,0,0];

  rot = side == 0 ? [0,0,90] : side == 1 ? [0,0,270] : side == 2 ? [0,0,180] : side == 3 ? [0,0,0] : [0,0,0];

  translate(loc) 
    rotate(rot)
      children();
}

module case_bot() {
  difference() {
    base_case();
    lift = outside[2] * case_split;
    translate([0, 0, lift]) cube(outside+[1,1,0], center=true);
    for( idx = [0 : len(usb_holes)-1]) {
      hole_offset(usb_holes[idx][0], usb_holes[idx][1]) {
        usbMicroBPlug(plugcutout=false);
      }
    }
    // punch hole for sensor cables
    hole_offset(side=3, where=[0, 0,  lift/2 - 8]) {
      cube([4,3,8]);
    }
  }
  difference() {
    roundedCube(inside, inside_r, true, true);
    roundedCube(inside - wall_set + [0,0,4], inside_r, true, true);
    translate([0,0, -inside[2] + 0.2]) cube(outside, center=true);
    translate([0,0, bottom_well]) cube(outside, center=true);
  }
}

module case_top() {
  difference() {
    base_case();
    lift = outside[2] * (1 - case_split);
    translate([0, 0, -lift]) cube(outside+[1,1,0], center=true);
  }

  translate([0,0, (inside[2]/2) - lip_height ]) {
    lipped = [inside[0], inside[1], lip_height];
    difference() {
      roundedCube(lipped, inside_r, true, true);
      roundedCube(lipped - wall_set + [0,0,4], inside_r, true, true);
    }
  }
}

module platform() {
  tolerance = [wall_thickness,wall_thickness,0];
  plat = [inside[0], inside[1], wall_thickness*2] - tolerance;
  difference() {
    roundedCube(plat, inside_r, true, true);
  }

  peg_h =  2;
  translate([inside[0]/2, inside[1]/2 - 0.4, 0]) {
    rotate(a=[0,0,180]) {
      manyPegs(locations=Breadboard_half_locations(), sizes=Breadboard_half_sizes(h=peg_h));
    }
  }
}

case_bot();
!case_top();
translate([0,0, -outside[2]/2 + bottom_well + wall_thickness]) // put platform in real place so we can see how it fits.
  platform();


// vim: set ai et sw=2 ts=2 :
