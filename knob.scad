
$fs=1;
$fa=1;
$fn=0;

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

knobThick=2;
//knobSize=featherMinSize + (knobThick*2);
//knobSize=featherTFTMinSize + (knobThick*2);
knobSize=max(ring24_outter+1, esp32ThingMinSize) + (knobThick*2);
echo(knobSize);
knobHeight=20;
knobGap=0.3;
knobLipWidth=1;
knobLipHeight=1;

bumpSize=3;

baseHeight=10;
baseBumps = 2;

usbMicroBPlug = [12.33,29.1,8.04];
baseBottomThickness = 2;
baseBottomHeight = 10;
circuitGap = 0.4;
circuitGapV = [circuitGap,circuitGap,circuitGap];


useBallSwitch = true;

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
translate([0,0,knobHeight - ring24_thick - knobLipHeight - 2])
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

module ring_of_cyliners(h=5, cr=3, rr=20) {
	pi = 3.1416;
	// How many degrees each cylinder needs at a distance of cr from 0
	degrees = (180 * (cr*2)) / (rr*pi);
	for(step=[0 : degrees : 360]) {
		rotate([0,0,step]) {
			translate([rr,0,-(h/2)]) {
				cylinder(h=h, r=cr);
			}
		}
	}
}

// knob
union() {
	difference(){
		cylinder(h=knobHeight, r=knobSize/2);
		translate([0,0,-knobThick]) {
			cylinder(h=knobHeight+knobThick+1, r=(knobSize/2)-knobThick);
		}
		// Need to make a ring of divits.  So a ring of cylinders cut out.
		translate([0,0,baseHeight/2])
			ring_of_cyliners(h=bumpSize, cr=(bumpSize/2), rr=(knobSize/2)-(knobThick), $fs=0.1);

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

!union() {
	difference() {
		union() {
			cylinder(h=baseHeight, r=(knobSize/2)-(knobThick)-knobGap);

			// Add the bumps for clicking
			if (useBallSwitch) {
			} else {
				for(step=[0 : (360/baseBumps) : 360]) {
					rotate([0,0,step]) {
						translate([(knobSize/2)-(knobThick)-knobGap,0,baseHeight/2]) {
							sphere(d=bumpSize, $fs=0.1);
						}
					}
				}
			}

			// Bottom Base.
			translate([0,0,-baseBottomHeight]) {
				cylinder(h=baseBottomHeight,r=knobSize/2);
			}
		}

		if (useBallSwitch) {
			// FIXME: One needs to be on the ridge of a divit while the other is inside.
			//for(step=[0 : (360/baseBumps) : 360]) {
			for(step=[0, 185]) { // What is the right degree? How to math it?
				rotate([0,0,step]) {
					translate([(knobSize/2)-(knobThick)-knobGap-9,-3.5,baseHeight/2+3.5]) {
						minkowski() {
							rotate([0,90,0]) ballSwitch();
							cube([0.1,0.1,baseHeight]);
						}
						/*hull() {
							rotate([0,90,0]) ballSwitch();
							translate([0,0,baseHeight/2]) rotate([0,90,0]) ballSwitch();
						}*/
					}
				}
			}
		} else {
			// Cutout for spring tabs.
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

		// Cutout for circuits.
		translate([-(esp32Thing[0]+circuitGap)/2, -(esp32Thing[1]+circuitGap)/2, -baseBottomHeight+baseBottomThickness])
			resize([0,0,baseBottomHeight+baseHeight])
				cube(esp32Thing+circuitGapV);

		//translate([-(feather[0]+0.4)/2, -(feather[1]+0.4)/2, -baseBottomHeight+baseBottomThickness])
			//cube([feather[0]+0.4, feather[1]+0.4, baseHeight+baseBottomHeight]);
		// TODO: cut out for USB port.
		translate([-(10)/2, (feather[1]+0.4)/2-1, -baseBottomHeight+baseBottomThickness])
				cube(usbMicroBPlug+circuitGapV);
	}
}



// vim: set ai sw=2 ts=2 :
