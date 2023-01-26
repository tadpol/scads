echo(version=version());
// Switched 3 AAA Battery Box
use <MCAD/boxes.scad>

function switched_AAA_dims() = [63.5, 37.1, 16];

module switched_AAA_box() {
	box=[16, 37.1, 63.5];
	rotate([0, 90, 0]) {
		translate(box/2) {
			roundedBox(box, 1, true);
		}
	}
	translate([55.7, 9.5, 0]) {
		cube(size=[3, 3, 1.5]);
	}
	translate([63.5, 31.3, -7]) {
		cube(size=[1, 2, 4]);
	}
}

module switched_AAA_box_clip(width=10, thickness=2) {
	difference() {
		cube([width, 37.1 + thickness*2, 16+thickness]);
		translate([-1, thickness, 16]) {
			switched_AAA_box();
		}
	}
}

switched_AAA_box();
// switched_AAA_box_clip();
