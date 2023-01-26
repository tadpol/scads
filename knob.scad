
$fs=1;
$fa=1;
$fn=0;

/* The TFT display board has a 84mm diangle.
 * So that plus thickness to get outer diameter
*/

featherWidth = 23;
featherLength = 51;
featherDepth = 8; // includes components
featherCircuitDepth = 2;

featherTFTWidth = 23;
featherTFTLength = 51;

knobThick=2;
//knobSize=84+4; // Diameter
knobSize=sqrt(pow(featherWidth,2)+pow(featherLength,2)) + (knobThick*2);
knobHeight=20;
knobGap=0.3;
knobLipWidth=1;
knobLipHeight=1;

bumpSize=3;

baseHeight=10;
baseBumps = 2;

module slice(r = 10, deg = 30) {
	degn = (deg % 360 > 0) ? deg % 360 : deg % 360 + 360;
	difference() {
		circle(r);
		if (degn > 180) intersection_for(a = [0, 180 - degn]) rotate(a) translate([-r, 0, 0]) square(r * 2);
		else union() for(a = [0, 180 - degn]) rotate(a) translate([-r, 0, 0]) square(r * 2);
	}
}

module curve_edge(r=10,h=5,deg=90,thick=1) {
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
}

// knob
!union() {
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

		// curve_edge() is currently very cpu intensive.
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
