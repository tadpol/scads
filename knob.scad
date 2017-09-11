
$fs=1;
$fa=1;
$fn=0;

use <parts/ballSwitch.scad>
use <parts/usbMicroBPlug.scad>

// [width, length, depth]
feather = [23,51,8];
//featherCircuitDepth = 2;
featherMinSize = sqrt(pow(feather[0],2)+pow(feather[1],2));

// Add wing that will hold level shifter, cap, and resistors.
// Not too worried, looks like we'll have plenty of open space.
featherWing = [23, 51, 8]; // 8+?

// SparkFun ESP32 Thing
esp32Thing = [26, 59, 8];
esp32ThingMinSize = sqrt(pow(esp32Thing[0],2) + pow(esp32Thing[1],2));
esp32Thing_usb_plugin = [8.5,0,2.6];

/*
featherTFTWidth = 65.0;
featherTFTLength = 53;
featherTFTHight = 9.5;
featherTFTMinSize = sqrt(pow(featherTFTWidth,2)+pow(featherTFTLength,2));
*/
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

knobThick=3;
//knobSize=featherMinSize + (knobThick*2);
//knobSize=featherTFTMinSize + (knobThick*2);
//knobSize=max(ring24_outter+1, esp32ThingMinSize) + (knobThick*2);
knobSize = 24 + (knobThick*2);
echo(knobSize);
knobHeight=20;
knobGap=0.3;
knobLipWidth=1;
knobLipHeight=1;

bumpSize=4;

baseHeight=10;
baseBumps = 2;
bumpGap = 1;
useBallSwitch = true;

baseBottomThickness = 2;
baseBottomHeight = 10;
circuitGap = 0.4;
circuitGapV = [circuitGap,circuitGap,circuitGap];



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
ring_raised = knobHeight - ring24_thick - knobLipHeight - 2;
translate([0,0,ring_raised])
union() {
	rotate([0,0,45]) {
		ring_support_spoke();
		rotate([0,0,90]) ring_support_spoke();
	}


	%translate([0,0,2]) {
		ring(ring24_outter, ring24_inner, ring24_thick);
		ring(ring16_outter, ring16_inner, ring16_thick);
		//translate([0,0,ring16_thick+1]) ring(ring12_outter, ring12_inner, ring12_thick);
		ring(ringJ_outter, ringJ_inner, ringJ_thick);
	}
}

/*
	@param h Cylinder height
	@param rr Ring Radius.
	@param cr Cylinder radius
	@param cspace Space between each cylinder
*/
module ring_of_cyliners(h=5, cr=3, cspace=0, rr=20) {
	pi = 3.1416;
	// How many degrees each cylinder needs at a distance of rr from 0
	degrees = (180 * ((cr*2)+cspace)) / (rr*pi);
	gapstep = (180 * (cspace/2)) / (rr*pi);
	for(step=[0 : degrees : 360]) {
		rotate([0,0,step-gapstep]) {
			translate([rr,0,-(h/2)]) {
				cylinder(h=h, r=cr);
			}
		}
	}
}
/* For a ring_of_cyliners, rotate evenly to N of them.
	@param rr Ring Radius.
	@param cr Cylinder radius
	@param cspace Space between each cylinder
	@param count Number of steps around
	@param alton Put every other child onto a ridge.
*/
module bump_location(cr=3, cspace=0, rr=20, count=2, alton=true) {
	pi = 3.1416;
	// How many degrees each cylinder needs at a distance of rr from 0
	degrees = (180 * ((cr*2)+cspace)) / (rr*pi);
	gapstep = (180 * (cspace/2)) / (rr*pi);
	// How many cylinders will this make?
	total = floor(360/degrees);
	// How many to skip
	skip = ceil(total / count);

	for(step=[0 : (skip*degrees)*2 : 359]) {
		rotate([0,0,step-gapstep]) {
			children();
		}
	}
	for(step=[skip*degrees + (alton?degrees/2:0) : (skip*degrees)*2 : 359]) {
		rotate([0,0,step-gapstep]) {
			children();
		}
	}
}
/*
	The above ring_of_cyliners makes uneven hills and valleys.
	The bump_location puts the bumps 50% off phase.

	TODO: The hills/valleys need to be even.
	TODO: 25% phase offset?
*/

// knob
union() {
	difference(){
		cylinder(h=knobHeight, r=knobSize/2);
		translate([0,0,-knobThick]) {
			cylinder(h=knobHeight+knobThick+1, r=(knobSize/2)-knobThick);
		}
		// Need to make a ring of divits.  So a ring of cylinders cut out.
		translate([0,0,baseHeight/2+1])
			ring_of_cyliners(h=bumpSize, cr=(bumpSize/2), cspace=bumpGap, rr=(knobSize/2)-(knobThick), $fs=0.1);

		// Cutout to easily slide knob onto base.
		bump_location(cr=(bumpSize/2), cspace=bumpGap, rr=(knobSize/2)-(knobThick)) {
			translate([(knobSize/2)-(knobThick),0,-0.1]) {
				cylinder(h=baseHeight/2-bumpSize/2+1.2, r=(bumpSize/2), $fs=0.1);
			}
		}

		// Show spheres for visual alignments.
		%bump_location(cr=(bumpSize/2), cspace=bumpGap, rr=(knobSize/2)-(knobThick)) {
			translate([(knobSize/2)-(knobThick)-knobGap,0,baseHeight/2+1]) {
				sphere(d=bumpSize);
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


// Ballswitch mount test
!union(){
			translate([0,0,-baseBottomHeight]) {
				cylinder(h=baseBottomHeight,r=knobSize/2);
			}
	difference() {
		dr=12;
		cylinder(h=baseHeight, r=dr-knobGap);
		/*
		For half of a given size of a divit at given radius, how many degrees?
		*/
		bump_location(cr=(bumpSize/2), cspace=bumpGap, rr=(knobSize/2)-(knobThick)) {
			translate([dr-4.75,0,2+(baseHeight+3)/2]) {
				rotate([90,0,90]) ballSwitchCutout(baseHeight+3, center=true, justcollar=true);
			}
		}
	}
}

union() {
	difference() {
		union() {
			cylinder(h=baseHeight, r=(knobSize/2)-(knobThick)-knobGap);

			// Add the bumps for clicking
			if (useBallSwitch) {
			} else {
				bump_location(cr=(bumpSize/2), rr=(knobSize/2)-(knobThick), count=baseBumps) {
					translate([(knobSize/2)-(knobThick)-knobGap,0,baseHeight/2]) {
						sphere(d=bumpSize, $fs=0.1);
					}
				}
			}

			// Bottom Base.
			translate([0,0,-baseBottomHeight]) {
				cylinder(h=baseBottomHeight,r=knobSize/2);
			}

			// Supports for rings
			for(i = [0,90,180,270]) {
				rotate([0,0,45+i]) {
					translate([(knobSize/2)-(knobThick)-knobGap-4,-6.5,0])
						difference() {
							cube([2,13,ring_raised+ring24_thick-1]);
							translate([-0.5,0.75,ring_raised])
								cube([3,11,ring24_thick]);
						}
				}
			}
		}

		if (useBallSwitch) {
			bump_location(cr=(bumpSize/2), cspace=bumpGap, rr=(knobSize/2)-(knobThick)) {
				translate([(knobSize/2)-(knobThick)-knobGap-4.75,0,2+(baseHeight+3)/2]) {
					rotate([90,0,90])
						ballSwitchCutout(baseHeight+3, center=true, justcollar=true);
				}
			}
		} else {
			// Cutout for spring tabs.
			bump_location(cr=(bumpSize/2), rr=(knobSize/2)-(knobThick), count=baseBumps) {
				rotate([0,0,5]) {
					translate([(knobSize/2)-knobThick-knobGap-2,0,0]) {
						cube([2,1,baseHeight+1]);
					}
					curve_edge(r=knobSize/2-knobThick-knobGap-1, h=baseHeight+1, deg=40);
					translate([0,0,-0.5])
						curve_edge(r=knobSize/2-knobThick-knobGap+0.1, h=1.5, deg=40, thick=2.1);
				}
			}
		}

		// Cutout for circuits.
		translate([-(esp32Thing[0]+circuitGap)/2, -(esp32Thing[1]+circuitGap)/2, -baseBottomHeight+baseBottomThickness]) {
			resize([0,0,baseBottomHeight+baseHeight])
				cube(esp32Thing+circuitGapV);

			usbMicroBPlug(plugin=esp32Thing_usb_plugin, plugcutout=true);
		}
	}
}



// vim: set ai sw=2 ts=2 :
