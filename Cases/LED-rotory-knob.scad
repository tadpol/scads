
$fs=1;
$fa=1;
$fn=0;

use <../parts/ballSwitch.scad>
use <../parts/usbMicroBPlug.scad>
use <../parts/bumpyCylinder.scad>

// TODO: Select board: [feather, esp32Thing]

// [width, length, depth]
feather = [23,51,8];
//featherCircuitDepth = 2;
featherMinSize = sqrt(pow(feather[0],2)+pow(feather[1],2));
feather_usb_plugin = [11,0,2.6];
feather_mounts = [[2.54,2.54],[2.54,48.26],[20.32,2,54],[20.32,48.26]]; // Centers of screw holes.
feather_hole_size = 2.54;
feather_battery_jst=10.795; // to center from left top
jst = [7,7,7];

// Add wing that will hold level shifter, cap, and resistors.
// Not too worried, looks like we'll have plenty of open space.
featherWing = [23, 51, 8]; // 8+?
/*
featherTFTWidth = 65.0;
featherTFTLength = 53;
featherTFTHight = 9.5;
featherTFTMinSize = sqrt(pow(featherTFTWidth,2)+pow(featherTFTLength,2));
*/

// SparkFun ESP32 Thing
esp32Thing = [26.5, 59.5, 8.5];
esp32ThingMinSize = sqrt(pow(esp32Thing[0],2) + pow(esp32Thing[1],2));
esp32Thing_usb_plugin = [8.5,0,2.6];

//battery = [35,62,5]; // 1200mAh
battery = [37,55,6]; // 1000mAh
batteryMinSize = sqrt(pow(battery[0],2) + pow(battery[1],2));

board = feather;
boardMinSize = featherMinSize;
boardHeight = feather[2];
board_usb_plugin = feather_usb_plugin;

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
knobSize=max(ring24_outter+1, boardMinSize, batteryMinSize) + (knobThick*2);
//echo(knobSize);
knobHeight=35;
knobGap=0.3;
knobLipWidth=1;
knobLipHeight=1;

bumpSize=4;

baseHeight=10;
//baseBumps = [0, 5.25];
baseBumps = [0, 13.25]; // For when esp32thing size
useBallSwitch = true;

baseBottomThickness = 2;
baseBottomHeight = boardHeight + 5; // 2 is padding
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
translate([0,0,ring_raised]) {
	union() {
		rotate([0,0,45]) {
			ring_support_spoke();
			rotate([0,0,90]) ring_support_spoke();
/*
			// Support for driver circuit.  May not bother making this and instead just
			// use stiffness of wires.
			translate([0,0,-5.5]) {
				cube([5,5,5.5]);
				translate([2.5,2.5,-2])
					cylinder(h=3,d=3);
				translate([0,-20,0])
				cube([5,5,5.5]);
			}
*/
		}


		%translate([0,0,2]) {
			ring(ring24_outter, ring24_inner, ring24_thick);
			ring(ring16_outter, ring16_inner, ring16_thick);
			//translate([0,0,ring16_thick+1]) ring(ring12_outter, ring12_inner, ring12_thick);
			ring(ringJ_outter, ringJ_inner, ringJ_thick);
		}
	}
}


// knob
!union() {
	difference(){
		cylinder(h=knobHeight, r=knobSize/2);
		translate([0,0,-knobThick]) {
			cylinder(h=knobHeight+knobThick+1, r=(knobSize/2)-knobThick);
		}
		b_radius = (knobSize/2)-(knobThick/2)-0.5;
		// Need to make a ring of divits.  So a ring of cylinders cut out.
		translate([0,0,baseHeight/2-bumpSize/2 +1])
			bumpy_cylinder(r=b_radius, cr=bumpSize, h=bumpSize);

		for(idx=baseBumps) {
			// Cutout to easily slide knob onto base.
			bumpy_cylinder_rotate_to(r=b_radius, cr=bumpSize, idx=idx) {
				translate([(knobSize/2)-(knobThick),0,-0.1]) {
					cylinder(h=baseHeight/2-bumpSize/2+1.2, r=(bumpSize/2), $fs=0.1);
				}
			}

			// Show spheres for visual alignments.
			%bumpy_cylinder_rotate_to(r=b_radius, cr=bumpSize, idx=idx) {
				translate([(knobSize/2)-(knobThick)-knobGap,0,baseHeight/2+1]) {
					sphere(d=bumpSize);
				}
			}
		}
		translate([0,0,knobHeight-2]) {
			cylinder(h=1, r=knobSize/2-knobThick+1);
		}
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
union(){
			translate([0,0,-baseBottomHeight]) {
				cylinder(h=baseBottomHeight,r=knobSize/2);
			}
	difference() {
		dr=12;
		cylinder(h=baseHeight, r=dr-knobGap);
		/*
		For half of a given size of a divit at given radius, how many degrees?
		*/
		for(idx=baseBumps) {
			bumpy_cylinder_rotate_to(r=(knobSize/2)-(knobThick/2-0.5), cr=bumpSize, idx=idx) {
				translate([dr-4.75,0,2+(baseHeight+3)/2]) {
					rotate([90,0,90]) ballSwitchCutout(baseHeight+3, center=true, justcollar=true);
				}
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
				for(idx=baseBumps) {
					bumpy_cylinder_rotate_to(r=(knobSize/2)-(knobThick/2)-0.5, cr=bumpSize, idx=idx) {
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

			// Supports for rings
			for(i = [0,90,180,270]) {
				rotate([0,0,45+i]) {
					translate([(knobSize/2)-(knobThick)-knobGap-4,-6.5,0])
						difference() {
							cube([2,14,ring_raised+ring24_thick-1]);
							translate([-0.5,1.5,ring_raised])
								cube([3,11,ring24_thick]);
						}
				}
			}
		}

		if (useBallSwitch) {
			for(idx=baseBumps) {
				bumpy_cylinder_rotate_to(r=(knobSize/2)-(knobThick/2)-0.5, cr=bumpSize, idx=idx) {
					translate([(knobSize/2)-(knobThick)-knobGap-4.75,0,2+(baseHeight+3)/2]) {
						rotate([90,0,90])
							ballSwitchCutout(baseHeight+3, center=true, justcollar=true);
					}
				}
			}
		} else {
			// Cutout for spring tabs.
			for(idx=baseBumps) {
				bumpy_cylinder_rotate_to(r=(knobSize/2)-(knobThick/2)-0.5, cr=bumpSize, idx=idx) {
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
		}

		// TODO: ?Make this a bigger clearer opening.  Later add mounting holes &| inserts to hold things.
		// *sigh* the best place for the battery is below the circuit, But that means the USB is now floating up in hte air.
		// Cutout for circuits. ?and battery
		translate([-(board[0]+circuitGap)/2, -(board[1]+circuitGap)/2, -baseBottomHeight+baseBottomThickness]) {
			resize([0,0,baseBottomHeight+baseHeight])
				cube(board+circuitGapV);
			
			translate([-(jst[0]/2), feather_battery_jst-(jst[1]/2), 0])
				resize([0,0,baseBottomHeight+baseHeight])
					cube(jst);

			usbMicroBPlug(plugin=board_usb_plugin, gap=0.5, plugcutout=true);
		}

		// Cutout for pushing the mainboard out.
		translate([0,0,-baseBottomHeight+baseBottomThickness-4]) {
			cylinder(r=2.5, h=5);
		}
	}
}



// vim: set ai sw=2 ts=2 :
