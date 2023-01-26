echo(version=version());
use <MCAD/boxes.scad>
use <../parts/usbMicroBPlug.scad>
use <../parts/pegs.scad>

// Values are in millimeters

$fs=0.5;
////////////////////////////

extruder_width = 0.4;
wall_thickness = 2*extruder_width;

// Currently this holds a single feather, and one wing above.
// TODO: Add options to hold a dual- or tri- wing adaptor
// Basically, wider with more pegs.

//wing_style='single' // 'dual', 'tri'
wing_style=2; // [1, 2, 3] Single wing, dual-wing, or tri-wing

// Where to pop holes for USB connector.
// length should match wing_style.
// 0 = no hole.
// 1 = lower (feather below wing)
// 2 = upper (feather above wing)
usb_slots=[2, 0];

// full box size
inside = [45 + ((wing_style-1) * 23), 70, 35+16];
// inside = [45, 70, 35];
wall_set = [for(i=[0:3]) wall_thickness*2];
outside = inside + wall_set;

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
      // lip_edge + platform + peg height + upsidedown?
      // Turns out, when you raise and flip the circuit board, the usb hole is in the same place.
      peg_h = 2;
      cbadj = 2;
      plift = lip_edge + (wall_thickness*2) + peg_h + cbadj;

      // TODO: if dual or tri wing, need option on where to put USB hole. (which spot, or multiple spots?)
      // Also, if a wing is below, then USB hole is higher.

      // So a loop, and offset from where? 

      // used to just be the center, that's why 0
    for(idx = [0:wing_style-1]) {
      translate([0 + 23*idx, outside[1]/2, -outside[2]/2 + plift]) {
        usbMicroBPlug(plugcutout=false);
      }
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

// Want option for upside down feather.
module platform(upsidedown=false) {
  tolerance = [wall_thickness,wall_thickness,0];
  plat = [inside[0], inside[1], wall_thickness*2] - tolerance;
  difference() {
    roundedBox(plat, 4, true);

    // hole for battery wires
    hole_loc = upsidedown ? [-inside[0]/2, inside[1]/2 - 10, 0] : [inside[0]/2, inside[1]/2 - 10, 0];
    translate(hole_loc) {
      cube(size=[8, 8, 4], center=true);
    }
  }

  peg_h = upsidedown ? 7 : 2;
    translate([(23 * (wing_style))/2, inside[1]/2 - 0.4, 0]) {
      rotate(a=[0,0,180]) {
        if (wing_style == 2) {
          manyPegs(locations=featherWingDoubler_locations(), sizes=featherWingDoubler_sizes(h=peg_h));
        } else if (wing_style == 3) {
          manyPegs(locations=featherWingTripler_locations(), sizes=featherWingTripler_sizes(h=peg_h));
        } else {
          // assume single
          manyPegs(locations=featherHuzzahESP8266_locations(), sizes=featherHuzzahESP8266_sizes(h=peg_h));
        }
      }
    }
}

case_bot();
case_top();
translate([0,0, -outside[2]/2 + 9 + wall_thickness]) // put platform in real place so we can see how it fits.
!  platform();


// vim: set ai et sw=2 ts=2 :
