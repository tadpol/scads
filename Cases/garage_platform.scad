echo(version=version());
use <MCAD/boxes.scad>
use <../parts/pegs.scad>

// Values are in millimeters

$fs=0.5;
////////////////////////////

extruder_width = 0.4;
wall_thickness = 2*extruder_width;

/*
eventually, needs to be a flat rectangle that mounts to case, and has peg/clips to hold stacked feathers.

*/

module lpeg() {
	rotate([0,90,0]) peg();
}
module rpeg() {
	rotate([0,270,0]) peg();
}

lpeg();
translate([27+10+2,0,0]) rpeg(); 
translate([0, 46, 0]) {
	lpeg();
	translate([27+10+2,0,0]) rpeg(); 
}

difference() {
	// translate([-82/4, -88/4, -4]) cube([82, 88, wall_thickness*2]);
	translate([82/4, 88/4, -wall_thickness -2.5]) roundedBox([82, 88, wall_thickness*2], 3, true);

	// Extra thingies. (why are they a different height?)
	translate([82/4, -88/4 + 4, -4.5]) cylinder(d=10, h=wall_thickness*3);
	translate([82/4, -88/4 + 4 -5, -3.5]) cube([10, 10, wall_thickness*3], center=true);
	translate([82/4, 88*3/4 - 4, -4.5]) cylinder(d=10, h=wall_thickness*3);
	translate([82/4, 88*3/4 - 4 +5, -3.5]) cube([10, 10, wall_thickness*3], center=true);

	// Mounting holes.
	translate([-82/4 + 6.5, -88/4 + 5.5, -4.5]) cylinder(d=4,h=wall_thickness*3);
	translate([82*3/4 - 6.5, -88/4 + 5.5, -4.5]) cylinder(d=4,h=wall_thickness*3);
	translate([82*3/4 - 6.5, 88*3/4 - 5.5, -4.5]) cylinder(d=4,h=wall_thickness*3);
	translate([-82/4 + 6.5, 88*3/4 - 5.5, -4.5]) cylinder(d=4,h=wall_thickness*3);
}