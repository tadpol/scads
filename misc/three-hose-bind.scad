echo(version=version());
$fa=1;
$fs=1;

// Values are in millimeters
extusion_width=0.4;
wall_thickness=3*extusion_width;

//
pipeA = 25;
pipeB = 17;
pipeC = 28;

// Not sure if I'll use bolts or not yet.
// If we put a channel around the outside to hold a ziptie, that might be simpler
// (don't have to figure out places for bolts, don't have to have even spacing.)
bolt_head=5.5;
bolt_w=3;
bolt_l=12;

bolt_needs=bolt_head + wall_thickness*2;

zip_width=4;
zip_needs=zip_width + wall_thickness*2;


use <MCAD/boxes.scad>


box=[
	//bolt_needs + pipeA + wall_thickness + pipeB + wall_thickness + pipeC + bolt_needs,
	wall_thickness*2 + pipeA + wall_thickness + pipeB + wall_thickness + pipeC + wall_thickness*2,
	pipeC + wall_thickness*4,
	zip_needs
];

difference() {
	roundedBox(box, 2, false);

	translate([0,0,0]) {
		union() {
			translate([box[0]/2 - pipeA/2 - wall_thickness*2,0,0])
				cylinder(h=zip_needs+2, d=pipeA, center=true);
			translate([box[0]/2 - pipeA - wall_thickness*3 - pipeB/2,0,0])
				cylinder(h=zip_needs+2, d=pipeB, center=true);
			translate([-box[0]/2 + pipeC/2 + wall_thickness*2,0,0])
				cylinder(h=zip_needs+2, d=pipeC, center=true);
		}
	}


	// Channel for zip tie
	if(false) {
		difference() {
			translate([-box[0]/2, -box[1]/2, -2])
				cube([box[0], box[1], zip_width]);
			roundedBox([box[0]-1, box[1]-1, zip_width+2], 2, true);
		}
	}
}




// vim: set sw=2 ts=2 :
