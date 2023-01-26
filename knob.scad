
$fs=1;
$fa=1;
$fn=0;

featherWidth = 23;
featherLength = 51;
featherDepth = 8; // includes components
featherCircuitDepth = 2;
featherMinSize = sqrt(pow(featherWidth,2)+pow(featherLength,2));

featherTFTWidth = 65.0;
featherTFTLength = 53;
featherTFTHight = 9.5;
featherTFTMinSize = sqrt(pow(featherTFTWidth,2)+pow(featherTFTLength,2));

ring24_outter = 65.6;
ring24_inner = 52.3;
ring24_thick = 3.6;
ring16_outter = 44.5;
ring16_inner = 31.75;
ring16_thick = 3.6;
ring12_outter = 36.8;
ring12_inner = 23.3;
ring12_thick = 3.6;
ringJ_outter = 23;
ringJ_inner = 0;
ringJ_thick = 3.6;

knobThick=2;
//knobSize=featherMinSize + (knobThick*2);
//knobSize=featherTFTMinSize + (knobThick*2);
knobSize=max(ring24_outter, featherMinSize) + (knobThick*2);
echo(knobSize);
knobHeight=20;
knobGap=0.3;
knobLipWidth=1;
knobLipHeight=1;

bumpSize=3;

baseHeight=10;
baseBumps = 2;

//rings
module ring(o,i,h) {
	difference(){
			cylinder(h=h, d=o);
		translate([0,0,-0.1])
			cylinder(h=h+0.2, d=i);
	}
}

module ring_support_spoke(width=10, depth=2) {
	difference() {
		translate([-ring24_outter/2,-(width/2),0])
			cube([ring24_outter, width, depth]);
		translate([0,0,-0.1])
			ring(ring24_outter+3, ring24_outter, ring24_thick);
	}
	// edges to hold outer most ring
	difference() {
		translate([-(ring24_outter-1)/2,-(width/2),depth])
			cube([(ring24_outter-1), width, depth]);
		translate([0,0,depth-0.1]) {
			ring(ring24_outter, ring24_inner, ring24_thick);
		}
	// Raised edge to hold 16 ring and support 12 ring
		translate([0,0,depth-0.1])
			ring(ring16_outter, ring16_inner, ring16_thick);

		// Sink into it for the Jewel in center.
		translate([0,0,depth-0.1])
			ring(ringJ_outter, ringJ_inner, ringJ_thick);
	}
}
union() {
	ring_support_spoke();
	rotate([0,0,90]) ring_support_spoke();


	%translate([0,0,2]) {
		ring(ring24_outter, ring24_inner, ring24_thick);
		ring(ring16_outter, ring16_inner, ring16_thick);
		//translate([0,0,ring16_thick+1]) ring(ring12_outter, ring12_inner, ring12_thick);
		ring(ringJ_outter, ringJ_inner, ringJ_thick);
	}
}

// TODO: Need a support/mount to hold the feather.

// knob
union() {
	difference(){
		cylinder(h=knobHeight, r=knobSize/2);
		translate([0,0,-knobThick]) {
			cylinder(h=knobHeight+knobThick+1, r=(knobSize/2)-knobThick);
		}
		// Need to make a ring of divits.  So a ring of cylinders cut out.
		for(step=[0 : 4 : 360]) { // XXX How to calc step size so cylinders touch?
			rotate([0,0,step]) {
				translate([(knobSize/2)-(knobThick),0,(baseHeight/2)-(bumpSize/2)]) {
					cylinder(h=(bumpSize), r=(bumpSize/2), $fs=0.1);
				}
			}
		}
		// Only baseBumps divits need to be full height.
		for(step=[0 : (360/baseBumps) : 360]) {
			rotate([0,0,step]) {
				translate([(knobSize/2)-(knobThick),0,-0.1]) {
					cylinder(h=baseHeight/2, r=(bumpSize/2), $fs=0.1);
				}
			}
		}

		%for(step=[0 : (360/baseBumps) : 360]) {
			rotate([0,0,step]) {
				translate([(knobSize/2)-(knobThick)-knobGap,0,baseHeight/2]) {
					sphere(d=bumpSize);
				}
			}
		}
	}
	// Upper lip
	difference(){
		translate([0,0,knobHeight])
			cylinder(h=knobLipHeight, r=knobSize/2);
		translate([0,0,knobHeight-0.1])
			cylinder(h=knobLipHeight+0.2, r2=knobSize/2-knobLipWidth-knobThick, r1=knobSize/2-knobLipWidth);
	}
}

// base
module slice(r = 10, deg = 30) {
	degn = (deg % 360 > 0) ? deg % 360 : deg % 360 + 360;
	difference() {
		circle(r);
		if (degn > 180) intersection_for(a = [0, 180 - degn]) rotate(a) translate([-r, 0, 0]) square(r * 2);
		else union() for(a = [0, 180 - degn]) rotate(a) translate([-r, 0, 0]) square(r * 2);
	}
}
module curve_edge(r=10,h=5,deg=90,thick=1) {
	if ( version_num() < 20170208 ) {
		// curve_edge() is currently very cpu intensive.
		difference() {
			linear_extrude(height=h, center=false, convexity=10, twist=0, slices=20) {
				slice(r,deg);
			}
			translate([0,0,-0.5])
				rotate([0,0,0.5])
				linear_extrude(height=h+1, center=false, convexity=10, twist=0, slices=20) {
					slice(r-thick,deg+1);
				}
		}
	} else {
		// This is much faster.
		rotate_extrude(angle=-deg, convexity = 10) {
			translate([r-thick,0,0])
				square([thick, h]);
		}
	}
}

union() {
	difference() {
		union() {
			cylinder(h=baseHeight, r=(knobSize/2)-(knobThick)-knobGap);
			for(step=[0 : (360/baseBumps) : 360]) {
				rotate([0,0,step]) {
					translate([(knobSize/2)-(knobThick)-knobGap,0,baseHeight/2]) {
						sphere(d=bumpSize, $fs=0.1);
					}
				}
			}
		}

		for(step=[10 : (360/baseBumps) : 370]) {
			rotate([0,0,step]) {
				translate([(knobSize/2)-knobThick-knobGap-2,0,0]) {
					cube([2,1,baseHeight+1]);
				}
				curve_edge(r=knobSize/2-knobThick-knobGap-1, h=baseHeight+1, deg=45);
				translate([0,0,-0.5])
					curve_edge(r=knobSize/2-knobThick-knobGap+0.1, h=1.5, deg=45, thick=2.1);
			}
		}
	}
	translate([0,0,-4]) {
		cylinder(h=4,r=knobSize/2);
	}

}



// vim: set ai sw=2 ts=2 :