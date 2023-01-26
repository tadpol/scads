module ballSwitch() {
	union() {
		pin=[0.5,1,4.5];
		size=[7.35,7.35];
		translate([pin[0],0,pin[2]]) {
			translate([size[0]/2,size[1]/2,2.68]) {
				cylinder(d=5.54,h=1.87);
				translate([0,0,1.88])
					sphere(d=3.75);
					// Button depresses 0.5mm
			}
			cube([size[0],size[1],2.68]);
		}
		// pins
		cube(pin);
		translate([0,size[1]-pin[1],0]) cube(pin);
		translate([size[0]+pin[0],0,0]) cube(pin);
		translate([size[0]+pin[0],size[1]-pin[1],0]) cube(pin);
	}
}
module ballSwitchCutout(h=40) {
// TODO: needs to expand for tolerence gap
	size=[7.35,7.35];
	translate([size[0]/2,size[1]/2,2.68]) {
		hull() {
			cylinder(d=5.54,h=1.87);
			translate([h-size[0],0,0])
				cylinder(d=5.54,h=1.87);
		}
		translate([0,0,1.88])
			hull() {
				sphere(d=3.75);
				translate([h-size[0],0,0]) sphere(d=3.75);
			}
		// Button depresses 0.5mm
	}
	cube([h,size[1],2.68]);
}


// vim: set ai sw=2 ts=2 :