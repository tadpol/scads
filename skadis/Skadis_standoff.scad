$fs=0.1;

// This needs a M4x12 screw with a hex socket top
module skadis_standoff() {
	difference() {
		cylinder(d1=14.5, d2=16.75, h=20);
		translate([0,0,10])
			cylinder(d=3.9, h=15);
	}
	//translate([0,0,20])
	//	cylinder(d=4.9, h=5);


	translate([0,-5,20])
		cylinder(d=2, h=2.5);
	translate([0,5,20])
		cylinder(d=2, h=2.5);
}

module skadis_topper() {
	difference() {
		translate([0,0,-3]) sphere(d=20);
		translate([0,0,-10]) cube([20,20,20],center=true);
		#translate([0,0,0]) cylinder(d=6.85,h=4.25);
	}
}

//skadis_standoff();
skadis_topper();

// vim: set sw=2 ts=2 :
