use <MCAD/boxes.scad>

function micro_switch_size() = [27.8, 15.9, 10.3];

module micro_switch($fs=0.5) {
	difference () {
		roundedCube([27.8, 15.9, 10.3], 3, true, true);
		// Technically, this hole isn't a cylinder. its Y=3.1, X=3.4, so two cylinders
		translate([-(27.8/2)+2.8 -0.15, -(15.9/2)+2.8, 0]) cylinder(d=3.1, h=16, center=true);
		translate([-(27.8/2)+2.8 +0.15, -(15.9/2)+2.8, 0]) cylinder(d=3.1, h=16, center=true);
		// this hole is round.
		translate([(27.8/2)-2.8, (15.9/2)-2.8, 0]) cylinder(d=3.1, h=16, center=true);
	}
	// button
	translate([(27.8/2)-2.8-20.2, (15.9/2), 0]) roundedCube([2.8, 2.8, 4.2], 1, true, true);

	// COM
	translate([-(27.8/2)+2.8+12.2, -(15.9/2) - 2.7, -6.3/2]) {
		cube([0.5, 2.7, 6.3]);
		cube([2, 0.5, 6.3]);
		translate([0, 0, 0.8]) cube([10, 0.5, 4.7]);
	}

	// NO
	 translate([(27.8/2), -(15.9/2) - 2.7 + 7.15, -6.3/2]) {
		cube([4, 0.5, 6.3]);
		translate([0, 0, 0.8]) cube([10, 0.5, 4.7]);
	}

	// NC
	 translate([(27.8/2), -(15.9/2) - 2.7 + 7.15 + 5.5, -6.3/2]) {
		cube([4, 0.5, 6.3]);
		translate([0, 0, 0.8]) cube([10, 0.5, 4.7]);
	}
}

// This is a plate to mount a switch to.
// This has holes for bolts.
module micro_switch_mount_plate(h=2, $fs=0.5) {
	// holes first
	difference () {
		roundedCube([27.8, 15.9, h], 3, true, true);
		// Technically, this hole isn't a cylinder. its Y=3.1, X=3.4, so two cylinders
		translate([-(27.8/2)+2.8 -0.15, -(15.9/2)+2.8, 0]) cylinder(d=3.1, h=h+1, center=true);
		translate([-(27.8/2)+2.8 +0.15, -(15.9/2)+2.8, 0]) cylinder(d=3.1, h=h+1, center=true);
		// this hole is round.
		translate([(27.8/2)-2.8, (15.9/2)-2.8, 0]) cylinder(d=3.1, h=h+1, center=true);
	}
}

// This is a plate to mount a switch to.
// This has pegs
module micro_switch_mount_pannel(h=2, h2=4, $fs=0.5) {
		roundedCube([27.8, 15.9, h], 3, true, true);
		// Technically, this peg isn't a cylinder. its Y=3.1, X=3.4, so two cylinders
		translate([-(27.8/2)+2.8 -0.15, -(15.9/2)+2.8, h2/2]) cylinder(d=3, h=h2, center=true);
		translate([-(27.8/2)+2.8 +0.15, -(15.9/2)+2.8, h2/2]) cylinder(d=3, h=h2, center=true);
		// this peg is round.
		translate([(27.8/2)-2.8, (15.9/2)-2.8, h2/2]) cylinder(d=3, h=h2, center=true);
}

micro_switch();
micro_switch_mount_plate();
micro_switch_mount_pannel();
