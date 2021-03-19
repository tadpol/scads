echo(version=version());

// Values are in millimeters

$fa=1;
$fs=1;
////////////////////////////
include<../parts/sharp-ir-distance.scad>;

tolerance=0.1;

// case
difference() {
	cube([49,28,16]);
	translate([2,2,-1]) cube([45,24,15]);
	translate([2,2,3]) sharp_ir_distance(fuzz=tolerance);
	translate([23,25.5,3-4]) #cube([3.3,3,1.2+4]);
}
	translate([2,2,3]) %sharp_ir_distance(fuzz=tolerance);

// lid
translate([0, 30, 0]) {
	union() {
		cube([49,28,1.5]);
		translate([2+tolerance,2+tolerance,0])
			cube([45-(tolerance*2),24-(tolerance*2),2.9]);
		translate([23+tolerance,25,0])
			cube([3.3-(tolerance*2),3,2.9]);
	}
}

//	vim: set ai sw=2 ts=2 :
