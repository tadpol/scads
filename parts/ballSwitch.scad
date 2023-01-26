module ballSwitch() {
	union() {
		pin=[0.5,1,4.5];
		size=[7.35,7.35,2.68];
		ball=[3.75,3.75,3.75];
		ring=[5.54,5.54,1.87];
		translate([pin[0],0,pin[2]]) {
			translate([size[0]/2,size[1]/2,size[2]]) {
				cylinder(d=ring[0],h=ring[2]);
				translate([0,0,ring[2]])
					sphere(d=ball[0]);
					// Button depresses 0.5mm
			}
			cube(size);
		}
		// pins
		cube(pin);
		translate([0,size[1]-pin[1],0]) cube(pin);
		translate([size[0]+pin[0],0,0]) cube(pin);
		translate([size[0]+pin[0],size[1]-pin[1],0]) cube(pin);
	}
}
module ballSwitchCutout(h=40, gap=0.3) {
	pin=[0.5,1,4.5];
	size=[7.35,7.35,2.68];
	ball=[3.75,3.75,3.75];
	ring=[5.54,5.54,1.87];
	outter_size=[size[0]+pin[0]*2,h,pin[2]+size[2]+ring[2]+ball[2]/2];
	wgap=[(outter_size[0]+gap*2)/outter_size[0],
		(outter_size[1]+gap*2)/outter_size[1],
		(outter_size[2]+gap*2)/outter_size[2]];

	scale([wgap[0],1,wgap[2]]) {
		translate([pin[0],0,pin[2]]) {
			translate([size[0]/2,size[1]/2,size[2]]) {
				hull() {
					cylinder(d=ring[0],h=ring[2]);
					translate([0,h-size[1],0])
						cylinder(d=ring[0],h=ring[2]);
				}
				translate([0,0,ring[2]])
					hull() {
						sphere(d=ball[0]);
						translate([0,h-size[1],0]) sphere(d=ball[0]);
					}
				// Button depresses 0.5mm
			}
			cube([size[0],h,size[2]]);
		}
		// open space for pins
		difference() {
			cube([size[0]+pin[0]*2,h,pin[2]]);
			translate([size[0]/6+pin[0],-0.5,pin[2]/2])
				cube([size[0]*2/3,h+1,pin[2]/2]);
			translate([size[0]/3+pin[0],-0.5,-0.5])
				cube([size[0]/3,h+1,pin[2]]);
		}
	}
}

test=true;
if(test) {
	$fs=1;
	$fa=1;
	$fn=0;

	translate([0,0,0]) {
		ballSwitchCutout(h=20,gap=0.1);
	}

	translate([10,0,0]) {
		ballSwitchCutout(h=20,gap=0.5);
	}

}

// vim: set ai sw=2 ts=2 :
