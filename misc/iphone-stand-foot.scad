echo(version=version());
use <MCAD/boxes.scad>

// Values are in millimeters

$fs=0.5;
////////////////////////////

extruder_width = 0.4;

width=15;

module bump() {
	difference() {
		roundedBox([15, 15, width], 6, true);
		translate([0, 0, -16/2]) cylinder(h = 16, d = 10.5);
	}
}


original_base=62;
extenstion=40;

cube([width, original_base + extenstion, 2]);
translate([width/2, 15/2, 15/2]) rotate([0, 90, 0]) bump();
translate([width/2, original_base - 15 + 15/2, 15/2]) rotate([0, 90, 0]) bump();
translate([0,0,2]) cube([width, 2, 4]);
translate([0,13,2]) cube([width, 2, 4]);
translate([0,47,2]) cube([width, 2, 4]);
translate([0,60,2]) cube([width, 2, 4]);

translate([0,15,0]) cube([width, original_base - 30, 5]);
translate([0, original_base, 0]) cube([width, extenstion, 5]);