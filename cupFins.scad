echo(version=version());

// Values are in millimeters

$fa=1;
$fs=1;
////////////////////////////
// Adjust these for cup
cupDiameter = 80;

TEGsize = 40; 

////////////////////////////
// Plate to connect cup to TEG
rotate([0,0,0])
difference() {
	cube(size=[TEGsize,TEGsize,10]);
	
	translate([TEGsize/2, -2.5, (cupDiameter/2)+2])
		rotate([-90,0,0])
			cylinder(h=TEGsize+5, d=cupDiameter);
}
/*
////////////////////////////
// Cooling fins.  Will just find a CPU heatsink instead
finThick=3;
finGap=3;
module FinGrid() {
	for(i=[finGap: finGap+finThick: TEGsize-finGap]) {
		translate([-1,i,5])
			cube(size=[TEGsize+2,finThick,16]);
	}
}
translate([0,5, TEGsize])
rotate([-90,0,0])
difference() {
	cube(size=[TEGsize,TEGsize,20]);

	FinGrid();
	translate([TEGsize,0,0]) rotate([0, 0, 90]) FinGrid();
}
*/
//  vim: set sw=4 ts=4 :
