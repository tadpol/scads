//
// Batter case
// Moteino
// weathershield
//
$fs=0.5;

use <MCAD/boxes.scad>
use <../parts/switched-3AAA-box.scad>;
use <../parts/moteino.scad>;
use <../parts/weather_shield.scad>;

extruder_width = 0.4;
wall_thickness = 2*extruder_width;


wd = weather_shield_dims();
m = moteino_dims();
sab = switched_AAA_dims();

module parts_inside() {

	translate([sab[1]/2 - m[0]/2, 0, 0]) {
		translate([0, 0, m[2]]) {
			weather_shield();
		}
		// rotate([180,0,270])
		moteino();
	}

	translate([sab[1], sab[0] - m[0], -sab[2]]) {
		rotate([180, 0, 270]) {
			switched_AAA_box();
		}
	}
}


// translate([8.5, -18.5, -0.5]) {
// 	rotate([0, 0, 90]) {
// 		%parts_inside();
// 	}
// }

inside = sab + [0, 0, m[2] + wd[2]] + [3, 2, 3];

// full box size
wall_set = [for(i=[0:3]) wall_thickness*2];
outside = inside + wall_set;

module base_case() {
  difference() {
    roundedBox(outside, 4, false );
    roundedBox(inside, 4, false );
  }
}

module case_bot() {
  // lip_edge = 9; // little more than battery
  difference() {
    base_case();
    lift = outside[2] * 0.85;
    translate([0, 0, lift]) cube(outside+[1,1,0], center=true);
  }
  // difference() {
  //   roundedBox(inside, 4, true);
  //   roundedBox(inside - wall_set + [0,0,4], 4, true);
  //   translate([0,0, -inside[2] + 0.2]) cube(outside, center=true);
  //   translate([0,0, lip_edge]) cube(outside, center=true);
  // }
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


	translate([-sab[0]/2, -sab[1]/2, 2]) {
		rotate([0, 0, 0]) {
			switched_AAA_box();
		}
	}
    }
  }
}

module spacer() {
  // spacer around the moteino to hold the battery case up
  h=m[2]+wd[2];
  gap = 5;
  difference() {
    union() {
      translate([0, extruder_width + m[0]/2, 0]) {
        cube([inside[0]-wall_thickness, wall_thickness*2, h]);
      }
      translate([0, -extruder_width - (wall_thickness*2) - (m[0]/2), 0]) {
        cube([inside[0]-wall_thickness, wall_thickness*2, h]);
      }

      translate([gap, -sab[1]/2, 0]) {
        cube([wall_thickness*2, inside[1]-wall_thickness, h]);
      }
      translate([m[1], -sab[1]/2, 0]) {
        difference() {
          cube([wall_thickness*2, inside[1]-wall_thickness, h]);
          translate([-1, inside[1]/2 - 8.5, -0.1]) cube([15, 15, 6]);
        }
      }

      // small lifts for between the sheild and light sensor?
    }

    c = sqrt(pow(gap,2) + pow(gap,2) - 2*gap*gap*cos(90));
    translate([-0.5, inside[1]/2 + wall_thickness, h - c/2]) {
      rotate([45, 0, 0]) {
        cube([inside[0], gap, gap]);
      }
    }
    translate([-0.5, -inside[1]/2 + wall_thickness, h - c/2]) {
      rotate([45, 0, 0]) {
        cube([inside[0], gap, gap]);
      }
    }
    translate([-c/2, -inside[1]/2 + wall_thickness, h]) {
      rotate([0, 45, 0]) {
        cube([gap, inside[1], gap]);
      }
    }
    translate([inside[0]-c/2, -inside[1]/2 + wall_thickness, h]) {
      rotate([0, 45, 0]) {
        cube([gap, inside[1], gap]);
      }
    }

  }
}

// case_bot();
// case_top();
// translate([-inside[0]/2, 0, 0]) {
  spacer();
// }
