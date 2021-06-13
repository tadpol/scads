echo(version=version());
use <MCAD/boxes.scad>
use <../parts/usbMicroBPlug.scad>
use <../parts/pegs.scad>

// Values are in millimeters

$fs=0.5;
////////////////////////////

// uhg. Need upper and lower to hold board and battery seperatly.
// One box with a partition?

extruder_width = 0.4;
wall_thickness = 2*extruder_width;

// full box size
inside = [45, 70, 35];
wall_set = [for(i=[0:3]) wall_thickness*2];
outside = inside + wall_set;

// Details for places pegs to set Feather onto.
// fWing=[23,51]; // Single Wing
// twPegRadius = 1.22;
// twEdgeToPegCenter = 2.57;
// // The locations of the outter four peg holes (on centers)
// // FIXME: Pegs by the WiFi anntena on Huzzah Feather are not in standard placement.
// // Kinda feels like I need to make a new part file that has the peg and also placements
// // For various boards. (I have triWing and Huzzah-ESP8266)
// // AAAHHH!!! the holes by the anntena are not the same size as the other two!
// // Definitly need to part this out.
// twPegs = [
//   [twEdgeToPegCenter, twEdgeToPegCenter, 0],
//   [fWing[0]-twEdgeToPegCenter, twEdgeToPegCenter, 0],
//   [fWing[0]-twEdgeToPegCenter, fWing[1]-twEdgeToPegCenter, 0],
//   [twEdgeToPegCenter, fWing[1]-twEdgeToPegCenter, 0],
// ];


module base_case() {
  difference() {
    roundedBox(outside, 4, false );
    roundedBox(inside, 4, false );
  }
}

module case_bot() {
  lip_edge = 9; // little more than battery
  difference() {
    base_case();
    lift = outside[2] * 0.85;
    translate([0, 0, lift]) cube(outside+[1,1,0], center=true);

    // cut hole for USB connector
    plift = lip_edge + (wall_thickness*2) + (2 + twPegRadius*2); // lip_edge + platform + peg height
    translate([0, outside[1]/2, -outside[2]/2 + plift]) {
      usbMicroBPlug(plugcutout=false);
    }
  }
  difference() {
    roundedBox(inside, 4, true);
    roundedBox(inside - wall_set + [0,0,4], 4, true);
    translate([0,0, -inside[2] + 0.2]) cube(outside, center=true);
    translate([0,0, lip_edge]) cube(outside, center=true);
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

module platform() {
  tolerance = [wall_thickness,wall_thickness,0];
  plat = [inside[0], inside[1], wall_thickness*2] - tolerance;
  difference() {
    roundedBox(plat, 4, true);

    // hole for battery wires
    translate([inside[0]/2, inside[1]/2 - 10, 0]) {
      cube(size=[8, 8, 4], center=true);
    }
  }

  translate([23/2, inside[1]/2 - 0.4, 0]) {
    rotate(a=[0,0,180])
      manyPegs(locations=featherHuzzahESP8266_locations(), sizes=featherHuzzahESP8266_sizes(h=2));
  }
}

case_bot();
case_top();
translate([0,0, -outside[2]/2 + 9 + wall_thickness]) // put platform in real place so we can see how it fits.
  platform();


// vim: set ai et sw=2 ts=2 :
