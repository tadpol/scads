echo(version=version());

// Values are in millimeters

$fs=0.5;
////////////////////////////

// want something game controller-ish (eventually)

extruder_width = 0.4;
wall_thickness = 2*extruder_width;

battery_thickness = 6 + 4; // +3 for the pins poking outthe bottom of the circuit board.

// How much gap to have between the circuit board and the wall
twTolerence = [extruder_width, extruder_width, 0] * 2; // *2 for both sides

// Size to hold the tri-wing plus JoyWings (the cube that the circuit board fills)
// Top of case should be right inside joysitck tops
triWing = [71, 51, 25 + battery_thickness];

twPegRadius = 1.22;
twEdgeToPegCenter = 2.57;
// The locations of the outter four peg holes (on centers)
twPegs = [
  [twEdgeToPegCenter, twEdgeToPegCenter, 0],
  [triWing[0]-twEdgeToPegCenter, twEdgeToPegCenter, 0],
  [triWing[0]-twEdgeToPegCenter, triWing[1]-twEdgeToPegCenter, 0],
  [twEdgeToPegCenter, triWing[1]-twEdgeToPegCenter, 0],
];

// Need a box to hold the tri-wing with stuff on top.
// Need a top that has openings/buttons in the correct places.
// Need space in bottom for LiPo.

module peg(h1=5, r1=1.22, r2=2.57) {
  h2=r1*2;
  translate([-r2,-r2,0]) cube([r2*2, r2*2, h1]);
  cylinder(r=r1,h=h1+h2/2);
  translate([0, 0, h1+h2/2]) sphere(r=r1);
}

module case() {
  difference() {
    cube(triWing + [2*wall_thickness,2*wall_thickness,2*wall_thickness] + twTolerence);
    // Inside:
    translate([wall_thickness,wall_thickness,wall_thickness]) {
      cube(triWing + [0,0,3] + twTolerence);
    }
  }
  translate([wall_thickness,wall_thickness,0] + twTolerence/2) {
    for (l = twPegs) {
      translate(l + [0,0,wall_thickness])
        peg(h1=battery_thickness, r1=twPegRadius, r2=twEdgeToPegCenter);
    }
  }
  // Now add support pegs to hold board above battery
}

// A flat plate with the four pegs so we can test alignment.
module plate_test() {
  //cube([triWing[0],triWing[1],wall_thickness]);
  for (l = twPegs) {
    translate(l + [0,0,wall_thickness])
      peg(h1=battery_thickness, r1=twPegRadius, r2=twEdgeToPegCenter);
  }
}


case();
//plate_test();
//peg();


// vim: set ai et sw=2 ts=2 :
